---
title: 如何恢复Linux误删文件
date: 2020-02-12 19:06:00+08:00
tags: [linux, restore, deleted]
slug: how-to-recover-accidentally-deleted-files-in-linux
---

## 事件背景

常言道，人有失手，马有失蹄。即使在绝大多数时间里，我都很小心地操作有关删除的各种命令，但终究免不了，在偶尔心神不够集中时，也会犯下误删文件的错误。

事件发生时，数百个重要文件在一个命令执行后消失在磁盘里。在懊悔不已的同时，我紧急将该分区取消挂载，以确保不再有新数据写入，覆盖了这些刚删除的文件数据。然后，开始满世界寻找各种数据恢复解决方案，最终找到这个Linux误删文件的恢复工具：`foremost`，用它开始在4TB的硬盘上，进行数小时漫长的恢复过程。

## 恢复方案（TL;DR版）

作为总结，这里简述一下，如何恢复Linux误删文件：

1. 取消挂载数据分区（这个步骤很重要，确保要恢复的数据不被覆盖）：

    ```sh
    $ sudo umount /<挂载点>
    ```

2. 安装`foremost`软件包（如果系统中已经安装过，可以跳过此步骤）：

    ```sh
    $ sudo emerge -av foremost
    ```

    这是Gentoo Linux的安装方法，其他发行版可以使用其他相应的软件包安装命令。

3. 选择一个路径，开始扫描分区，将被删除文件恢复到该路径：

    ```sh
    $ foremost -i <设备> -t jpg,pdf,png -o <恢复结果目录名>
    ```

    这里需要注意，一定确保该路径所在分区有足够的存储空间，因为扫描过程可能将此前所有被删除的残留文件都恢复出来。另外，可以使用“-t”参数指定只恢复某一类型的文件，避免将其他大量不必要的碎片文件也恢复出来。

4. 进入恢复结果目录，检查找回的文件，确认文件内容。

## 模拟演示

接下来，我将创建一个镜像文件，将其当作一个存储设备，创建文件系统并挂载，在其中操作文件删除，并演示恢复的过程。

1. 创建镜像文件

```sh
$ dd if=/dev/zero of=device.img bs=1M count=32 # 创建32MB大小的空白文件
```

2. 将文件作为存储设备使用，有两种方式，可任选其一：

    1. loop设备（需要root权限）：

        ```sh
        $ sudo losetup -fP device.img  # 安装loop设备
        $ losetup -a                   # 查看loop设备
        $ mkfs.ext4 device.img         # 格式化该分区（镜像文件）
        $ mkdir mnt                    # 新建目录，作为挂载点
        $ sudo mount /dev/loop0 mnt/   # 挂载分区（名称`loop0`来自上述`losetup`命令）
        ```

    2. ext4fuse（不需要root权限，但需要额外安装一个小工具）：

        ```sh
        $ git clone https://github.com/gerard/ext4fuse.git  # 下载ext4fuse源码
        $ make -j10 -C ext4fuse                             # 编译ext4fuse
        $ mkdir mnt                                         # 新建目录，作为挂载点
        $ ./ext4fuse/ext4fuse device.img mnt/               # 挂载分区
        ```

3. 进入该分区，下载几个图片文件，以便演示文件删除和恢复过程：

    ```sh
    $ cd mnt/
    $ wget -N https://yanlinlin.cn/images/weixin-zanshang.png
    $ wget -N https://yanlinlin.cn/images/weixin-shoukuan.png
    $ wget -N https://yanlinlin.cn/images/zhifubao-shoukuan.jpg
    $ md5sum *.{png,jpg}  # 计算md5sum，便于后续校验所恢复的文件
    ```

4. 删除文件（模拟误删除操作）：

    ```sh
    $ rm -fv *.{png,jpg}
    ```

5. 接下来，尝试恢复文件，首先取消挂载分区：

    对于loop设备方式：

    ```sh
    $ cd ../
    $ sudo umount mnt/
    ```

    对于ext4fuse方式：

    ```sh
    $ cd ../
    $ fusemount -u mnt/ 
    ```

6. 调用foremost，扫描分区设备（镜像文件），以恢复文件：

    ```sh
    $ foremost -i device.img -t png,jpg -o restored  # 恢复文件
    $ tree -sh restored/                             # 查看恢复结果
    $ cat restored/audit.txt | less                  # 查看恢复日志
    $ md5sum restored/*/*                            # 检查恢复文件的md5sum
    ```

## 小结

1. 事后补救，不如提前尽量多做好备份；
2. 一旦涉及误删，第一时间避免新数据写入；
3. 平时对文件做好md5sum记录，方便恢复后文件的对应。

## 参考

* [How to Recover Permanently Deleted Files In Linux](https://linuxgain.com/recover-deleted-files-linux/)
* [How to Restore a Deleted File in Linux](https://www.rootusers.com/restore-deleted-file-linux/)
* [Recover Deleted Files in Linux](https://opensourceforu.com/2011/09/recover-deleted-files-in-linux/)
* [How to create virtual block device (loop device/filesystem) in Linux](https://www.thegeekdiary.com/how-to-create-virtual-block-device-loop-device-filesystem-in-linux/)
* [GitHub: EXT4 implementation for FUSE](https://github.com/gerard/ext4fuse)
