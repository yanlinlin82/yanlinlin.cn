---
title: Linux chmod 权限位详解：SUID、SGID、Sticky Bit 及 ACL
date: 2026-05-31 13:15:00+08:00
categories: [技术]
tags: [Linux, chmod, 权限, SUID, SGID, Sticky Bit, ACL]
slug: linux-chmod-permissions-suid-sgid-sticky-acl
---

Linux 的权限系统是每位运维和开发者的基本功。`chmod` 命令用来修改文件或目录的访问权限，但很多人在面对 SUID、SGID、Sticky Bit 这些"特殊权限位"时，往往只知其然而不知其所以然。

本文从最基础的权限模型讲起，逐步深入到三个特殊权限位，再介绍 ACL（访问控制列表）作为传统权限的补充方案。


## 一、基础权限回顾

Linux 的每个文件或目录都有一组权限位，分为三组：

| 分组 | 含义 | 符号表示 |
|------|------|----------|
| User (u) | 文件所有者 | `rwx` |
| Group (g) | 文件所属组 | `rwx` |
| Others (o) | 其他用户 | `rwx` |

每组三个位分别表示：

- **r** (read) -- 读取权限。对文件可读内容，对目录可列出内容。
- **w** (write) -- 写入权限。对文件可修改内容，对目录可创建/删除文件。
- **x** (execute) -- 执行权限。对文件可执行，对目录可进入（`cd`）。

用 `ls -l` 查看时，权限字符串形如：`-rwxr-xr--`。

### 八进制表示法

将 `rwx` 视为二进制位（`r=4, w=2, x=1`），每个分组用一个八进制数表示：

```
rwx = 4+2+1 = 7
rw- = 4+2+0 = 6
r-x = 4+0+1 = 5
r-- = 4+0+0 = 4
```

例如 `chmod 755 file` 等价于 `chmod u=rwx,g=rx,o=rx file`。

## 二、特殊权限位概述

除了基础的 `rwx` 权限，Linux 还有三个特殊权限位，它们位于权限字符串的最高位（八进制第四位）：

| 特殊位 | 八进制值 | 符号 | 作用对象 |
|--------|----------|------|----------|
| SUID | 4 | `u+s` | 可执行文件 |
| SGID | 2 | `g+s` | 可执行文件 & 目录 |
| Sticky Bit | 1 | `o+t` | 目录 |

当我们执行 `chmod 4755 file` 时，数字 4 就是 SUID 位。权限字符串中表现为所有者执行位变为 `s`（或 `S`）。

## 三、SUID (Set User ID)

### 含义

SUID 位设置在**可执行文件**上。当一个用户执行带有 SUID 的程序时，该进程的有效用户 ID（EUID）会被临时提升为**文件所有者**的 UID，而非执行者自身的 UID。

### 典型例子

```bash
# /usr/bin/passwd 就是一个经典的 SUID 程序
ls -l /usr/bin/passwd
# -rwsr-xr-x 1 root root  ...  /usr/bin/passwd
```

普通用户修改自己的密码，需要写入 `/etc/shadow` 文件（该文件仅 root 可写）。`passwd` 程序的 SUID 位使它在运行时以 root 身份执行，从而能够修改 shadow 文件。

### 如何设置

```bash
# 符号方式
chmod u+s /path/to/program

# 八进制方式（在三位数前加 4）
chmod 4755 /path/to/program
```

### 如何验证

`ls -l` 输出中，所有者的 `x` 位会变成 `s`（小写，表示已有执行权限）或 `S`（大写，表示缺少执行权限）：

```
-rwsr-xr-x  1 root root  ...  program   # SUID 已设置，且所有者有 x 权限
-rwSr-xr-x  1 root root  ...  program   # SUID 已设置，但所有者没有 x 权限（少见）
```

### SUID 在目录上无效

**重要：SUID 对目录没有任何效果。** 现代 Linux 内核完全忽略目录上的 SUID 位。它不会让目录下新建的文件继承目录所有者的身份——那是 SGID 的职责，而且仅限于组继承。试图让文件自动改变所有者会带来严重的安全风险。

```bash
# 即使这样设置，目录也不会改变行为
chmod u+s /path/to/directory
chmod 4770 /path/to/directory
```

`ls -ld` 中虽然能看到 `s` 位，但系统不会执行任何特殊操作：

```
drwsrwxr-x  2 owner group  ...  test_folder
```

### SUID 在脚本上无效

**重要：SUID 对脚本（Shell、Python、Perl 等解释器脚本）同样无效。** 这是很多人容易踩的坑——给一个 `.sh` 脚本设置了 `chmod 4755`，却发现它运行时仍然以当前用户身份执行，并未提权。

原因在于 Linux 执行脚本的底层机制：

1. **内核不直接执行脚本**。当你运行 `./script.sh` 时，内核读取脚本文件头部（`#!/bin/bash`），然后启动对应的解释器程序（如 `/bin/bash`），并将脚本路径作为参数传给它。真正被内核加载执行的**二进制文件是解释器**（`/bin/bash`），而不是脚本本身。

2. **SUID 位在解释器上，而不是在脚本上**。因为实际执行的二进制程序是 `/bin/bash`，而 `/bin/bash` 没有 SUID 位，所以 bash 进程的 EUID 仍然是当前用户。即使脚本文件有 SUID 位，内核的脚本加载器（`binfmt_script`）在处理 `#!` 行时，会**主动忽略**脚本文件上的 setuid 和 setgid 位，以避免安全漏洞。

3. **竞态条件（Race Condition）风险**。假设内核允许脚本上的 SUID 生效，攻击者可以构造以下攻击：
   - 创建一个 SUID root 的脚本 `/tmp/evil.sh`，该脚本调用 `/sbin/ldconfig` 等危险操作。
   - 在 `/tmp/evil.sh` 执行瞬间，通过符号链接（symlink）将其替换为攻击者的恶意脚本。
   - 解释器（如 bash）以 root 权限执行了攻击者的代码。
   这种 TOCTOU（Time-of-Check Time-of-Use）攻击在脚本场景下极难防御，因此 Linux 内核选择直接禁用脚本上的 SUID。

4. **BSD 方式 vs System V 方式**。历史上，System V 风格的 Unix 允许脚本上的 SUID，而 BSD 风格则禁止。Linux 采用 BSD 方式，忽略脚本的 SUID/SGID 位，但这取决于内核配置和发行版。大多数现代发行版（如 RHEL、Debian、Ubuntu）默认禁用。

```bash
# 以下设置对脚本无效！
chmod u+s myscript.sh
chmod 4755 myscript.sh

# 运行后仍然是当前用户身份，不会提权
./myscript.sh
```

如果需要让脚本以特定用户身份运行，正确的做法是：

- 使用 `sudo` 配置（`/etc/sudoers`）允许特定用户无密码执行该脚本。
- 编写一个 SUID 的 **C 封装程序**（wrapper），在该 C 程序中调用 `setuid()` 和 `execvp()`，然后设置该二进制程序的 SUID 位。

```c
// suid-wrapper.c — SUID 封装示例
#include <stdio.h>
#include <unistd.h>
#include <sys/types.h>

int main(int argc, char *argv[]) {
    setuid(0);  // 提升为 root
    execvp("/path/to/script.sh", argv);
    return 0;
}
```

编译并设置 SUID：

```bash
gcc -o suid-wrapper suid-wrapper.c
chown root:root suid-wrapper
chmod u+s suid-wrapper
```

这样，SUID 位设在二进制可执行文件上，内核正常识别并提权；封装程序再以提升后的权限启动脚本。

## 四、SGID (Set Group ID)

### 含义

SGID 有两种行为，取决于它设置在文件还是目录上：

- **文件**：程序运行时，有效组 ID（EGID）被提升为文件所属组的 GID。
- **目录**：在该目录下创建的新文件和子目录**自动继承**该目录的所属组，而非创建者自身的默认组。子目录还会自动继承 SGID 位。

### SGID 在目录上的应用场景

SGID 在目录上的应用是多人协作中最常用的功能之一。假设团队 `teamgroup` 共享一个工作目录：

```bash
# 创建共享目录并设置 SGID
mkdir shared_folder
chgrp teamgroup shared_folder
chmod g+s shared_folder
chmod 2770 shared_folder

# 验证
ls -ld shared_folder
# drwxrws---  2 user teamgroup 4096 May 31 08:00 shared_folder
```

注意权限字符串中的 `s`（在组的执行位置），它表示 SGID 已生效，且组有执行权限。如果显示大写 `S`，说明 SGID 位虽已设置但缺少组执行权限。

### SGID 的好处

1. **无缝协作**：多个团队成员可以读写文件，不会因为主组不同而权限冲突。
2. **自动继承**：子目录自动获得 SGID 位，权限规则递归生效。
3. **简化管理**：管理员无需每次创建文件后手动 `chgrp`。

### SGID 在脚本上无效

与 SUID 同理，SGID 对脚本同样无效。内核在处理 `#!` 脚本时，会忽略脚本文件上的 SGID 位，原因与 SUID 完全一致：真正被内核加载执行的是解释器（如 `bash`、`python3`），而不是脚本文件本身。`binfmt_script` 会主动丢弃 setgid 位，以防止竞态条件攻击。

### 如何设置

```bash
# 符号方式
chmod g+s /path/to/directory

# 八进制方式（在三位数前加 2）
chmod 2770 /path/to/directory
```

### 最佳实践搭配

- **配合 umask**：SGID 只控制组所有权，不控制权限。确保用户有统一的 umask（如 `002` 或 `007`），使新文件自动赋予组的写入权限。
- **配合 Sticky Bit**：如果希望组成员可以编辑文件但不能删除他人的文件，可以同时设置 Sticky Bit：`chmod 3770 /path/to/directory`。

## 五、Sticky Bit (粘滞位)

### 含义

Sticky Bit 设置在**目录**上。当一个目录设置了 Sticky Bit，只有以下用户才能删除或重命名该目录下的文件：

- 文件的拥有者
- 目录的拥有者
- root 用户

其他用户即使对该目录有写入权限，也无法删除他人的文件。

### 典型例子

最经典的例子就是 `/tmp` 目录：

```bash
ls -ld /tmp
# drwxrwxrwt  10 root root  ...  tmp
```

权限字符串末尾的 `t`（在 others 的执行位置）表示 Sticky Bit 已生效。所有用户都可以在 `/tmp` 下创建和写入文件，但无法删除不属于自己的文件。

### 如何设置

```bash
# 符号方式
chmod o+t /path/to/directory

# 八进制方式（在三位数前加 1）
chmod 1777 /path/to/directory
```

### 验证

`ls -ld` 中 others 的 `x` 位会变成 `t`（小写，表示已有执行权限）或 `T`（大写，表示缺少执行权限）：

```
drwxrwxrwt  10 root root  ...  tmp     # Sticky Bit 已设置，others 有 x 权限
drwxrwxr-T  10 root root  ...  dir     # Sticky Bit 已设置，但 others 没有 x 权限
```

## 六、三个特殊位综合速查

| 八进制前缀 | 符号设置 | 作用 |
|------------|----------|------|
| `chmod 4xxx` | `chmod u+s` | 设置 SUID（仅文件有效） |
| `chmod 2xxx` | `chmod g+s` | 设置 SGID（文件与目录均有效） |
| `chmod 1xxx` | `chmod o+t` | 设置 Sticky Bit（仅目录有效） |
| `chmod 0xxx` | 无 | 清除所有特殊位 |
| `chmod 6xxx` | `chmod ug+s` | 同时设置 SUID 和 SGID |
| `chmod 7xxx` | `chmod ug+s,o+t` | 设置 SUID、SGID 和 Sticky Bit |
| `chmod 3xxx` | `chmod g+s,o+t` | 同时设置 SGID 和 Sticky Bit |

### 权限字符串解读速查

```
-rwsr-xr-x    SUID 已设置，所有者有执行权限
-rwSr-xr-x    SUID 已设置，所有者无执行权限
-rwxr-sr-x    SGID 已设置，组有执行权限
-rwxr-Sr-x    SGID 已设置，组无执行权限
drwxrws---    SGID 已设置（目录），组有执行权限
drwxrwxrwt    Sticky Bit 已设置，others 有执行权限
drwxrwxr-T    Sticky Bit 已设置，others 无执行权限
```

## 七、安全注意事项

### 查找设置了特殊位的文件

```bash
# 查找所有 SUID 文件
find / -perm -4000 -type f 2>/dev/null

# 查找所有 SGID 文件
find / -perm -2000 -type f 2>/dev/null

# 查找所有 SGID 目录
find / -perm -2000 -type d 2>/dev/null

# 查找 Sticky Bit 目录
find / -perm -1000 -type d 2>/dev/null
```

### 安全建议

1. **定期审计**：SUID/SGID 文件是权限提升的常见入口，应定期审计并尽量减少数量。
2. **不必要的 SUID**：对于不需要提权的程序，使用 `chmod u-s` 移除 SUID 位。
3. **不要给脚本设置 SUID/SGID**：内核不会对脚本文件上的 SUID/SGID 位生效（详见第三节 **SUID 在脚本上无效**），这样做只会带来错误的安全预期。若需脚本提权，应使用 `sudo` 或 C 封装程序。

## 八、ACL（访问控制列表）——传统权限的补充

当传统 UGO 模型无法满足复杂的权限需求时，ACL 提供了更精细的控制能力。

### ACL 能做什么

传统 Linux 权限限制为"一个所有者"和"一个所属组"。ACL 允许：

- **任意数量的特定用户**：单独为 UserA 赋予只读权限，UserB 赋予读写权限。
- **任意数量的特定组**：允许 `developers` 组读写，`testers` 组只读。
- **默认继承权限（Default ACLs）**：目录上设置默认 ACL 后，新文件和子目录自动继承规则。
- **Mask 掩码**：一键限制所有 ACL 用户/组的最大权限上限。

### 快速上手示例

```bash
# 查看 ACL
getfacl /path/to/dir

# 给用户 bob 读写权限
setfacl -m u:bob:rw /path/to/dir

# 设置默认 ACL，后续创建的文件自动允许 bob 读写
setfacl -d -m u:bob:rw /path/to/dir

# 删除所有 ACL
setfacl -b /path/to/dir
```

设置了 ACL 的文件/目录，在 `ls -l` 中权限末尾会多一个 `+` 号：

```
drwxrwxr-x+  2 user group  ...  dir_with_acl
```

### 使用建议

**推荐使用场景**：

- 多部门协作的共享目录（研发、产品、测试需不同权限）。
- 敏感数据审计（对特定审计人员开放只读权限）。
- 备份账号自动拥有对新建文件的管理权限（通过 Default ACL）。

**不宜滥用的原因**：

- 维护复杂度增加：必须用 `getfacl` 查看规则。
- 备份迁移风险：需使用支持 ACL 的工具（如 `tar --acls` 或 `rsync -A`）。
- 极端规模下（数百万文件）有轻微性能开销。

## 九、总结

| 权限机制 | 适用场景 | 优点 | 局限 |
|----------|----------|------|------|
| 传统 UGO | 简单权限管理 | 直观、兼容性好 | 只有三组权限，粒度粗 |
| SUID | 需要提权的二进制程序（如 passwd） | 临时提升执行权限 | 安全风险高；对目录和脚本无效 |
| SGID | 共享目录、协作项目 | 自动组继承；控制文件所属组 | 对脚本无效；需配合 umask |
| Sticky Bit | 公共临时目录（如 /tmp） | 防删除他人文件 | 仅对目录有效 |
| ACL | 复杂权限需求 | 粒度极细、支持继承 | 维护复杂度高 |

掌握这些权限位的含义和用法，是 Linux 系统管理的重要基础。无论是搭建共享文件服务器、配置开发环境，还是进行安全审计，都需要灵活运用这些工具。

## 参考链接

1. [Linux File Permissions: Understanding setuid, setgid, and the Sticky Bit — CBT Nuggets](https://www.cbtnuggets.com/blog/technology/system-admin/linux-file-permissions-understanding-setuid-setgid-and-the-sticky-bit)
2. [Setuid — Wikipedia](https://en.wikipedia.org/wiki/Setuid)
3. [How to reassign UID/GID to all users and fix all file ownerships — Super User](https://superuser.com/questions/1736609/how-to-reassign-uidgid-to-all-users-and-automatically-fix-all-file-ownerships-a)
4. [SUID, SGID, Sticky Bit — Red Hat](https://www.redhat.com/en/blog/suid-sgid-sticky-bit)
5. [What's the purpose of setgid directory? — Server Fault](https://serverfault.com/questions/93894/whats-the-purpose-of-setgid-directory)
6. [Sticky bit vs setgid for facilitating shared write access — Unix StackExchange](https://unix.stackexchange.com/questions/23063/sticky-bit-vs-setgid-for-facilitating-shared-write-access)
