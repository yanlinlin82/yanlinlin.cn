---
title: GDB基本用法
date: 2020-03-23 06:29:46+08:00
tags: [gdb]
slug: gdb-basic-usage
---

## 1. 编译及启动

要使用gdb进行调试，在使用gcc/g++编译程序时，应该使用“-g”参数，使其目标文件中带有相应的符号信息：

```sh
$ gcc -g src.c -o a.out      # 编译，应使用“-g”选项
$ gdb a.out                  # 启动调试器（无参数）
$ gdb --args a.out arg1 arg2 # 启动调试器（有参数）
```

## 2. 常用基本命令

| 命令 | 缩写 | 含义 |
|------|------|------|
| `run` | `r` | （重新开始）运行程序 |
| `continue` | `c` | 继续运行程序 |
| `next` | `n` | 单步调试运行 |
| `backtrace` | `bt` | 列出当前堆栈信息 |
| `up` / `down` [n] | | 在调用堆栈上，进行上移/下移 |
| `list` [n] | `l` [n] | 列出源代码 |
| `print` [var] | `p` [var] | 显示变量值 |
| `info locals` | `i lo` | 列出当前所有局部变量 |
| `breakpoint` [n] | `b` [n] | 设置调试断点 |
| `info breakpoints` | `i b` | 列出当前设置的调试断点 |

在使用命令时，若无歧义，可使用缩写。比如“`info locals`”可以缩写为“`i lo`”。
