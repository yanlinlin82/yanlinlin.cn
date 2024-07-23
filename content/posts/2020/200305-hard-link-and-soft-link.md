---
title: "理解Linux下的硬链接与软链接"
date: 2020-03-05T07:02:12+08:00
tags: [ linux, hard link, soft link, inode ]
---

这是一篇简单解释Linux文件系统中关于文件链接（link）的笔记，总结自对`cp`与`ln`命令区别的解释。

对于Linux初学者，在学习到创建链接的`ln`命令时，也许很难搞清它与拷贝文件的命令之间有何区别，以及硬链接（hard link）和软链接（soft link）之间又有何区别。其实，这个问题从数据块存储的角度来理解，就会容易得多。

文件存储在磁盘上，是按照数据块的方式，一块一块写的。在读取文件时，系统是通过一个数据块的索引号，来找到文件数据的。这个索引号，在linux下，通常叫做inode，通过`ls -i`可以看到。inode相同，则它们指向同一个数据块，只占用一份空间。inode不同，则它们指向不同的数据块，分别占用磁盘上的不同空间。

* 硬链接：inode相同，两个文件其实是同一个存储位置的数据。
* 软链接：链接其实相当于是一个文本文件，其内容保存了所指向的文件的路径。

也因此，硬链接不能跨设备，软链接可以跨设备。但是软链接容易受到相对路径的影响（比如遇到“../”等路径，或者做文件移动操作后，就经常会指向混乱），硬链接则可以任意移动而不受影响。

下面用实际例子展示一下：
```sh
$ mkdir foo  # 创建一个测试目录
$ cd foo/  # 进入该目录

$ touch a.txt  # 创建一个文件
$ ls -i a.txt  # 查看该文件的inode
106829508 a.txt

$ cp a.txt b.txt  # 拷贝文件
$ ls -i -1 a.txt b.txt  # 查看这两个文件的inode，是不相同的
106829508 a.txt
106829509 b.txt

$ ln a.txt c.txt  # 创建硬链接
$ ls -i -1 a.txt c.txt  # 查看这两个文件的inode，是相同的
106829508 a.txt
106829508 c.txt

$ cp -l a.txt d.txt  # 其实cp命令也能创建硬链接（`-l`参数）
$ ls -i -1 a.txt d.txt  # 同理，它们的inode也是相同的
106829508 a.txt
106829508 d.txt

$ ln -s a.txt e.txt  # 创建软链接
$ ls -i -1 a.txt e.txt  # 查看文件及软链接的inode，是不相同的
106829508 a.txt
106829510 e.txt

$ ls -l e.txt  # 查看软链接，下面的第五项（即数字“5”），其实是该“文本文件”的实际大小
lrwxrwxrwx 1 yanll yanll 5 2020-03-04 21:30:58 e.txt -> a.txt
$ readlink e.txt  # 查看软链接的实际内容（“文本文件”内容）
a.txt

$ ls -i -l *.txt  # 至此，再实际查看一下各文件的详情
106829508 -rw-r--r-- 3 yanll yanll 0 2020-03-04 21:29:32 a.txt
106829509 -rw-r--r-- 1 yanll yanll 0 2020-03-04 21:29:49 b.txt
106829508 -rw-r--r-- 3 yanll yanll 0 2020-03-04 21:29:32 c.txt
106829508 -rw-r--r-- 3 yanll yanll 0 2020-03-04 21:29:32 d.txt
106829510 lrwxrwxrwx 1 yanll yanll 5 2020-03-04 21:30:58 e.txt -> a.txt
# 如上，第一列是inode，a.txt、c.txt、d.txt 是相同的
# 第三列是计数，因为有三个文件指向同一个数据块，所以这三个文件的该计数都是3，而另外两个文件都是1
```

最后，再来看下文件移动对链接的影响：

```sh
$ mkdir sub  # 创建子目录
$ mv -v {b,c,d,e}.txt sub/  # 把拷贝的文件、硬链接、软链接都移动到子目录中
renamed 'b.txt' -> 'sub/b.txt'
renamed 'c.txt' -> 'sub/c.txt'
renamed 'd.txt' -> 'sub/d.txt'
renamed 'e.txt' -> 'sub/e.txt'

$ ls -i -l  # 查看原文件
total 4
106829508 -rw-r--r-- 3 yanll yanll    0 2020-03-04 21:29:32 a.txt
106829511 drwxr-xr-x 2 yanll yanll 4096 2020-03-04 22:19:02 sub
# 其inode与计数仍保持不变。

$ ls -i -l sub/  # 查看子目录中的文件
total 0
106829509 -rw-r--r-- 1 yanll yanll 0 2020-03-04 21:29:49 b.txt
106829508 -rw-r--r-- 3 yanll yanll 0 2020-03-04 21:29:32 c.txt
106829508 -rw-r--r-- 3 yanll yanll 0 2020-03-04 21:29:32 d.txt
106829510 lrwxrwxrwx 1 yanll yanll 5 2020-03-04 21:30:58 e.txt -> a.txt
# 其inode与计数，以及软链接的“文本内容”也都不变
# 注意：这里第一行给出的（total）数字是列举文件占用磁盘空间的总数（单位是kB），所以，在我的磁盘上，
#  这几个空文件占用的空间是0，全部加起来还不如一个目录所占用的空间（4096字节）大。

$ file sub/*  # 尝试用`file`命令访问文件内容
sub/b.txt: empty
sub/c.txt: empty
sub/d.txt: empty
sub/e.txt: broken symbolic link to a.txt
# 拷贝和硬链接都能正确访问，而软链接会尝试从链接所在目录出发去寻找源文件，因而失效
```

小结一下：

* 文件拷贝会在磁盘上完全复制所有数据块，让磁盘上存储多份拷贝。
* 硬链接会复用原来的数据块，不会增加磁盘占用，多个硬链接指向磁盘上相同的数据块。
* 软链接记录的是文件路径，除了链接本身，也不会增加其他磁盘占用，但是路径变更可能导致其失效。

最后，补充一个冷知识：在早期，删除文件的命令是用
unlink（编程语言里面也是这么提供的），意思是将当前硬链接删掉，inode计数减一，而只有当计数减到0时，才会真正将占用空间的数据块释放掉。
