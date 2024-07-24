---
title: "Perl Taint Mode"
date: 2020-03-16T11:38:12+08:00
tags: [ perl, taint ]
---

## 背景

最近修改过去写的一些perl脚本，将其“释伴”（shebang，即解释器定义行）修改为更加具备可移植性的“#!/usr/bin/env perl”写法。在这个过程中，看到了这样一种推荐写法：

```perl
#!/usr/bin/env -S perl -T -w
```

第一行中，“`-S`”是`env`的参数，用来表示后续并不是单个命令名称，而是具有参数的命令行；“-T”和“-w”都是`perl`的参数，分别表示打开“Taint检查”和“警告检查”。

对于Perl的警告检查，这个我用得相对多一些，它能避免错误使用未定义的变量名。然而“Taint模式”或者说“Taint检查”，之前没有听过，于是对此做了一番调研学习。

## 解释

来自Perl文档的说明如下：

`perldoc perlrun`：

> **-T**
> turns on "taint" so you can test them. Ordinarily these checks are
> done only when running setuid or setgid. It's a good idea to turn
> them on explicitly for programs that run on behalf of someone else
> whom you might not necessarily trust, such as CGI programs or any
> internet servers you might write in Perl. See perlsec for details.
> For security reasons, this option must be seen by Perl quite early;
> usually this means it must appear early on the command line or in
> the "#!" line for systems which support that construct.

`perldoc perlsec`：

> Perl automatically enables a set of special security checks, called
> *taint mode*, when it detects its program running with differing real
> and effective user or group IDs. The setuid bit in Unix permissions is
> mode 04000, the setgid bit mode 02000; either or both may be set. You
> can also enable taint mode explicitly by using the -T command line flag.
> This flag is *strongly* suggested for server programs and any program
> run on behalf of someone else, such as a CGI script. Once taint mode is
> on, it's on for the remainder of your script.

出于安全性的考虑，该检查选项是被强烈推荐使用的。它会检查各数据输入，若是运行时来自文件输入，则避免将其用于其他磁盘写或命令执行等操作。

StackOverflow上有一个[回答](https://stackoverflow.com/questions/2228457/is-perls-taint-mode-useful)，比较鲜明地展示了这种检查的作用甚至是必要性：

```sh
$ echo '`rm -rf /`' | perl -Te 'eval while <>'
Insecure dependency in eval while running with -T switch at -e line 1, <> line 1.
```

上面的perl命令会从输入读取每一行，并将其作为命令进行执行，遇到“rm -rf /”这种命令，不加限制，可想而知后果会多么恶劣。

## 示例

有如下perl脚本：

```sh
$ cat foo.pl
#!/usr/bin/env -S perl -T -w
use strict;
use warnings;

print "Input: ";
my $s = <>;              # `s` is taint
print "Command: ", $s;   # `print()` does not check taint
print "Results: ", `$s`; # backtick does check taint
```

其运行结果如下：

```
$ ./foo.pl
Input: hostname
Command: hostname
Insecure dependency in `` while running with -T switch at ./foo.pl line 8, <> line 1.
```

上面代码框中的第二行中的“hostname”是输入的命令；第三行是单纯用print输出其内容，此时并不会检查，因而成功输出；第四行由于变量`s`被用于反引号（命令执行），于是受到taint检查，报出错误信息，而不会被执行。

## 参考

* [Wikipedia: Taint checking](https://en.wikipedia.org/wiki/Taint_checking)
* [StackOverflow: Is Perl's taint mode useful?](https://stackoverflow.com/questions/2228457/is-perls-taint-mode-useful)
* [Perldoc: perlsec](https://perldoc.perl.org/perlsec.html)
