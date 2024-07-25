---
title: 理解Bash中的协程
date: 2020-03-06T07:41:32+08:00
tags: [ bash, coproc, pipe, 并发编程, 协程 ]
---

## 引子

过去做并发编程的开发时，接触得比较多的概念，就是“进程（procedure）”和“线程（thread）”。然而，不知道从什么时候起，“协程（co-processes）”这个概念突然就遍布整个世界了。偶然翻看bash的man帮助信息时，发现竟然连bash都已经自带了关键词`coproc`的支持，于是抽空做了点研究学习。

## 预备知识

### 1. 管道

Unix/Linux系统的一个设计思想，是把每个简单功能都拆分开来，单独实现成为独立的（内部或外部）命令，然后通过管道等方式将它们组合起来，灵活地完成各种任务。

管道的常规使用形式如下：

```sh
$ command-A | command-B | command-C
```

用管道（`|`）串联起来的各命令，每个命令都以前一个命令的“标准输出（stdout）”，作为自身的“标准输入（stdin）”。

例如，下面的命令排序展示了最近一周内登录到系统的用户及其登录次数：

```sh
$ last -s -7days | head -n -2 | awk '{print$1}' | sort | uniq -c | sort -nr
    130 yanll
     36 root
     31 reboot
```

解释如下：

```sh
$ last -s -7days \      # 列出最近七天的用户登录明细
   | head -n -2 \       # 去掉末尾两行（无关信息）
   | awk '{print$1}' \  # 取出第一列（用户名）
   | sort \             # 排序（使相同用户名排到一起，便于下一步统计）
   | uniq -c \          # 统计计数
   | sort -nr           # 根据计数再次做排序
```

### 2. 重定向

每个命令都允许从“标准输入”读取数据，并将结果输出到“标准输出”。此外，为便于调试和检查问题，程序还能把日志或报错信息输出到“标准错误（stderr）”。

在Linux系统中，“标准输入”、“标准输出”和“标准错误”都被封装成为设备文件的形式，分别是“`/dev/stdin`”、“`/dev/stdout`”和“`/dev/stderr`”。这样，应用程序可以很方便地以文件读写的方式，完成数据输入输出的操作。对于文件的处理，在操作系统层面，会为每个打开的文件分配一个文件描述符（file descriptor，简称fd），通常是一个整数。上述三个设备文件，因为每个应用程序都会带有，其实被固定为0、1、2。

有了这些知识，我们就可以通过“重定向（redirection）”来深度定制bash命令的执行了，例如：

```sh
$ echo 1>&2 "some error message."  # 这里的“1>&2”，就是把文件描述符“1”重定向到“2”，
                                   # 即“标准输出”改为“标准错误”
```

这个技巧很常用，可以在写bash脚本时，用于日志输出：

```sh
$ cat some-pipeline.sh
#!/bin/bash

echo 1>&2 "step 1 - bla bla bla" # 输出日志到“标准错误”
do_step_1  # 这里产出的结果，输出到“标准输出”

echo 1>&2 "step 2 - bla bla bla" # 输出日志到“标准错误”
do_step_2  # 这里产出的结果，输出到“标准输出”

$ ./some-pipeline.sh > output.txt  # 保存结果到文件，同时在屏幕上（通过“标准错误”）展示提示信息
step 1 - bla bla bla
step 2 - bla bla bla
```

反过来，经常有些命令的帮助信息被输出到了“标准错误”，而我们又想从篇幅较长的该帮助中查找（`grep`）到某项内容，则可以：

```sh
$ some-command 2>&1 | grep keyword
```

### 3. awk命令

GNU awk也许是Linux下最强大的基础命令。在我看来，要做数据分析，这个命令几乎是必学的。它有很多操作技巧甚至是不可替代的，或者说，用其他语言或工具，即使能实现同样功能，效率或便利程度都总有所不及。

比如，对一个非常非常巨大的文件，排除其重复行：

```sh
$ cat very-large-file.txt | awk '!s[$0]++' > no-dup-lines.txt
```

稍微调整一下，选取其中出现过三次或三次以上的行，不重复地输出出来：

```sh
$ cat very-large-file.txt | awk 's[$0]++==3' > three-times-lines.txt
```

此外，本文会用到的一个awk用法，给每一行内容增加一个当前时间的前缀：

```sh
$ cat input.txt | awk '{print strftime("[%Y-%m-%d %H:%M:%S]"),$0}'
```

### 4. bash数组

Bash支持变量操作，这些变量定义了各个命令的执行环境，所以通常也称为环境变量（environment variables）。

```sh
$ echo $PATH | tr ':' '\n'  # 按行显示可执行文件查找路径（来自环境变量PATH）
```

```sh
$ export FOO=abc.xyz   # 定义并赋值变量
$ echo ${FOO}          # 查看变量
$ echo ${FOO%.xyz}     # 去掉后缀
```

除了单值变量外，bash也支持数组变量：

```sh
$ export FOO=(abc.xyz 123 测试)          # 数组变量初始化
$ set | grep FOO=                        # 查看数组数值
FOO=([0]="abc.xyz" [1]="123" [2]="测试")
$ echo $FOO                              # 若当作单值变量，则显示的是第一个元素（下标为0）
abc.xyz
$ echo ${FOO[1]}                         # 显示第二个元素（下标为1）
123
$ echo ${FOO[2]}                         # 显示第三个元素（下标为2）
测试
```

## 协程

接下来，进入正题。首先看下`man bash`中关于协程的介绍：

> **Coprocesses**
>
> A coprocess is a shell command preceded by the coproc reserved word. A coprocess is executed asynchronously
> in a subshell, as if the command had been terminated with the & control operator, with a two-way pipe
> established between the executing shell and the coprocess.
> 
> The format for a coprocess is:
> 
>     coproc [NAME] command [redirections]
> 
> This creates a coprocess named NAME. If NAME is not supplied, the default name is COPROC. NAME must not be
> supplied if command is a simple command (see above); otherwise, it is interpreted as the first word of the
> simple command. When the coprocess is executed, the shell creates an array variable (see Arrays below) named
> NAME in the context of the executing shell. The standard output of command is connected via a pipe to a file
> descriptor in the executing shell, and that file descriptor is assigned to NAME[0]. The standard input of
> command is connected via a pipe to a file descriptor in the executing shell, and that file descriptor is
> assigned to NAME[1]. This pipe is established before any redirections specified by the command (see REDIRECTION below).
> The file descriptors can be utilized as arguments to shell commands and redirections using standard word expansions.
> The file descriptors are not available in subshells. The process ID of the shell
> spawned to execute the coprocess is available as the value of the variable NAME\_PID. The wait builtin command
> may be used to wait for the coprocess to terminate.
> 
> Since the coprocess is created as an asynchronous command, the coproc command always returns success. The
> return status of a coprocess is the exit status of command.

可以了解到，bash里的协程，与其他编程语言中的协程（诸如Python等语言中，协程区别于线程的，至少还有资源分配是否轻量级等问题，等以后再仔细做研究学习），应该还是有所区别的。

bash的协程，其实是类似于“&”后台命令的方式，帮助用户在运行一个命令时，自动创建管道。

下面看下创建协程的过程，相应的环境变量与（管道）文件描述符的变化：

```sh
$ set | grep COPROC  # 创建协程前，不存在环境变量COPROC
$ ll /proc/$$/fd/    # 当前bash环境中，也只有0、1、2和255这四个文件描述符
total 0
lrwx------ 1 yanll yanll 64 2020-03-06 10:10:11 0 -> /dev/pts/12
lrwx------ 1 yanll yanll 64 2020-03-06 10:10:11 1 -> /dev/pts/12
lrwx------ 1 yanll yanll 64 2020-03-06 10:10:11 2 -> /dev/pts/12
lrwx------ 1 yanll yanll 64 2020-03-06 10:11:13 255 -> /dev/pts/12
```

```sh
$ coproc cat         # 创建协程
[1] 14676

$ jobs               # 查看当前后台进程，该协程也在其中
[1]+  Running                 coproc COPROC cat &

$ set | grep COPROC  # 查看环境变量，其中`[0]="63"`是该协程的标准输出，`[1]="60"`是其标准输入
COPROC=([0]="63" [1]="60")
COPROC_PID=14676
$ ll /proc/$$/fd/    # 查看文件描述符，多了60和63两个文件
total 0
lrwx------ 1 yanll yanll 64 2020-03-06 10:10:11 0 -> /dev/pts/12
lrwx------ 1 yanll yanll 64 2020-03-06 10:10:11 1 -> /dev/pts/12
lrwx------ 1 yanll yanll 64 2020-03-06 10:10:11 2 -> /dev/pts/12
lrwx------ 1 yanll yanll 64 2020-03-06 10:11:13 255 -> /dev/pts/12
l-wx------ 1 yanll yanll 64 2020-03-06 10:11:29 60 -> 'pipe:[115296]'
lr-x------ 1 yanll yanll 64 2020-03-06 10:11:29 63 -> 'pipe:[115295]'
```

```sh
$ echo hello >&${COPROC[1]}  # 将内容传给协程，写入协程的标准输入

$ read WORD <&${COPROC[0]}   # 从协程读取内容，读取协程的标准输出

$ echo $WORD                 # 读取结果
hello
```

```sh
$ kill %1            # 终止协程
[1]+  Terminated              coproc COPROC cat

$ set | grep COPROC  # 查看环境变量，COPROC变量已经不存在了
$ ll /proc/$$/fd/    # 查看文件描述符，60和63已经不存在了
total 0
lrwx------ 1 yanll yanll 64 2020-03-06 10:10:11 0 -> /dev/pts/12
lrwx------ 1 yanll yanll 64 2020-03-06 10:10:11 1 -> /dev/pts/12
lrwx------ 1 yanll yanll 64 2020-03-06 10:10:11 2 -> /dev/pts/12
lrwx------ 1 yanll yanll 64 2020-03-06 10:11:13 255 -> /dev/pts/12
```

## 示例

综上，可以看到，bash的协程，其实是一个预定义了输入输出文件描述符的后台进程。

那么协程有什么实际用途呢？

下面展示一个例子，给每行输出文字增加一个时间字符串前缀：

```sh
$ coproc awk '{print strftime("[%Y-%m-%d %H:%M:%S]"),$0;fflush()}'  # 定义协程
[1] 7789

$ set | grep COPROC           # 查看协程变量
COPROC=([0]="63" [1]="60")
COPROC_PID=7789

$ cat <&${COPROC[0]}          # 将协程的输出重定向到屏幕，这里需先运行程序，然后按Ctrl+Z将其放置到后台
^Z
[2]+  Stopped                 cat 0<&${COPROC[0]}
$ bg                          # 设置后台运行
[2]+ cat 0<&${COPROC[0]} &

$ echo "hello, world!" >&${COPROC[1]}  # 尝试通过协程输出文字，可以看到结果的确被加上了时间前缀
[2020-03-06 10:36:50] hello, world!
```

这里有两个细节值得注意下：

1. awk中加了一个“fflush()”语句，用于确保结果被实时输出，避免缓存导致阻塞。
2. 在重定向协程的输出时，使用了Ctrl+Z的方式，来将程序放入后台，这个过程并不能直接使用“&”实现，推测原因应该与“&”的实现机制有关（可能是创建了一个bash子环境，待后续确认）。

## 小结

* 协程，是协作进程的简称，这是并发编程领域里一个相对比较新的概念。
* 在bash中，协程其实是一个后台进程，预定义了输入输出管道的文件描述符，方便后续其他命令与之进行交互。

## 参考链接

* [Bash manual: Coprocesses](https://www.gnu.org/software/bash/manual/html_node/Coprocesses.html)
* [StackExchange: How do you use the command coproc in various shells?](https://unix.stackexchange.com/questions/86270/how-do-you-use-the-command-coproc-in-various-shells)
* [StackExchange: Is coproc \<command\> the same as \<command\> \&?](https://unix.stackexchange.com/questions/472561/is-coproc-command-the-same-as-command)
* [Bash百宝箱：协作进程coproc](https://blog.csdn.net/iEearth/article/details/52534981)
* [小议bash中的COPROC](http://blog.lujun9972.win/blog/2018/04/26/%E5%B0%8F%E8%AE%AEbash%E4%B8%AD%E7%9A%84coproc/)

## 扩展阅读

关于文件描述符255的介绍：

* [StackOverflow: What is the use of file descriptor 255 in bash process](https://stackoverflow.com/questions/29729906/what-is-the-use-of-file-descriptor-255-in-bash-process)

下面这篇帖子的回答中，论述了bash协程存在的问题，以及不被推荐的原因：

* [StackExchange: How do you use the command coproc in various shells?](https://unix.stackexchange.com/questions/86270/how-do-you-use-the-command-coproc-in-various-shells)

相较于bash协程，更被推荐使用的`expect`命令：

* [GeeksforGeeks: expect command in Linux with Examples](https://www.geeksforgeeks.org/expect-command-in-linux-with-examples/)

其他相关链接：

* [How to create the effect of Multithreading in Linux shell scripts?](http://husseinbakri.org/how-to-create-the-effect-of-multithreading-in-linux-shell-scripts/)
* [云栖社区：进程，线程，协程](https://yq.aliyun.com/articles/53673)
* [云栖社区：Python并发编程协程(Coroutine)之Gevent](https://yq.aliyun.com/articles/422192)
* [知乎：进程 线程 协程](https://zhuanlan.zhihu.com/p/42623969)
* [知乎：线程、进程与协程](https://zhuanlan.zhihu.com/p/25735154)
* [腾讯云社区：浅谈进程、线程和协程三者之间的区别和联系](https://cloud.tencent.com/developer/article/1376478)
