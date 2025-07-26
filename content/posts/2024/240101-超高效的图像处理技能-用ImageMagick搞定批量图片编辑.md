---
title: 超高效的图像处理技能：用ImageMagick搞定批量图片编辑
date: 2024-01-01 23:19:00+08:00
badges:
- 公众号
categories: [不靠谱颜论, IT技巧]
tags: [图像处理, ImageMagick, 命令行, 批量处理, 教程]
slug: ultra-efficient-image-processing-skills-batch-editing-with-imagemagick
---

<div class="p-3 text-center">
  <img class="img-fluid" src="/images/2024/0101/01.png" alt="题图" style="max-width:640px">
  <div><small>（题图由AI生成）</small></div>
</div>

## 0. 引子

最近在写公众号文章和开发网站应用时，我经常遇到需要批量处理图片的场景。不管是调整尺寸、截取特定区域还是插入文字，图像处理软件虽多且各异，但我发现基于图形界面的工具，如Windows的画笔和Adobe Photoshop，在处理需要精准坐标和批量操作的任务时，往往不够灵活和高效。因此，我转向了一个强大的命令行工具——ImageMagick，以提高工作效率并实现更加精确的图像处理。

## 1. 软件安装方法

在正式介绍ImageMagick的妙用之前，让我们先确保它已正确安装在你的系统上。不同操作系统的安装方法略有差异，但总体上都是直接而简单的。接下来将介绍在Windows、MacOS和Linux上的安装步骤。
Windows:

访问ImageMagick官方网站下载页面（https://imagemagick.org/script/download.php）。

下载相应版本的Windows安装文件。

双击安装文件并遵循安装向导的指示完成安装。

在安装过程中，确保勾选了“Add application directory to your system path”选项，以便于在命令提示符中直接使用convert命令。
MacOS:

最简单的安装方法是使用Homebrew，一个MacOS的包管理器。如果尚未安装Homebrew，请访问Homebrew官网（https://docs.brew.sh/Installation）并按照指示进行安装。

安装Homebrew后，打开终端并输入以下命令：brew install imagemagick。

Homebrew会自动下载并安装ImageMagick。
Linux:

大多数Linux发行版都可以通过包管理器安装ImageMagick。

对于基于Debian的系统（如Ubuntu），在终端中输入：sudo apt-get install imagemagick。

对于RedHat系列，使用：sudo yum install imagemagick。

对于Arch Linux，使用：sudo pacman -S imagemagick。

验证安装:

安装完成后，在终端或命令提示符中输入convert -version。如果看到版本信息和版权声明，说明ImageMagick已成功安装。

请注意，ImageMagick的版本和特性可能会随时间更新和变化，建议访问ImageMagick官方网站查看最新的安装指南和文档。此外，安装过程中可能会遇到权限或环境问题，请根据自己的操作系统调整相应的安装步骤。

## 2. 软件基本使用方法

ImageMagick的魔力在于其简洁而强大的命令行操作。其基本的命令格式为：convert <输入图片名> <参数> <输出文件名> 。

即便是最简单的格式转换，也只需要指定输入和输出的文件名，ImageMagick就能自动处理。例如：

a. 将图片从 jpg 格式转换成 png 格式：

命令：`convert in.jpg out.png`

b. 将图片从 png 格式图片转换成 pdf 格式：

命令：`convert in.png out.pdf`

其他格式之间的转换，以此类推。

## 3. 应用实例介绍

接下来，让我们深入了解ImageMagick的几个实用功能，包括图片伸缩、内容截取、扩展画布、背景透明处理、颜色填充以及文本标签生成等。这些功能在日常的图片处理中非常实用。

a. 图片伸缩（尺寸大小转换）

指定缩放后的具体尺寸（如500x300像素）：
命令：convert in.png -resize 500x300 out.png

默认情况下，图片伸缩会保持图片的原始纵横比。如果你想在调整图片大小时不保持纵横比，可以在指定的宽度和高度后添加一个感叹号“!”：
命令：convert in.png -resize 500x300! out.png

用百分比指定尺寸（如50%）：
命令：convert in.png -resize 50% out.png

通过缩小图片尺寸，可以减小图片文件大小，这在某些要求上传图片（如照片）有文件大小限制的场合特别有用。

b. 图片内容截取（裁剪图片内某个矩形区域）

指定具体坐标位置（如左上角坐标30,40，截取矩形宽300、高200，均以像素为单位）：
命令：convert in.png -crop 300x200+30+40 +repage out.png

从图像中心进行截取（仍是截取宽300、高200的矩形）：
命令：convert in.png -gravity center -crop 300x200+0+0 +repage out.png

c. 扩展画布（与裁剪相反，原图片为处理后图片内的某个矩形区域）

指定具体坐标（如将画布大小扩展到宽800、高600像素，而原始图像位于新画布中心，扩展部分用白色填充）：
命令：convert in.png -gravity center -background white -extent 800x600 out.png

用百分比指定尺寸（如200%，即新图片的宽和高，都是原图片的两倍）：
命令：convert in.png -gravity center -background white -extent 200% out.png

d. 背景透明处理

假如我们有某个图片，想从中抠出前景，而把单色背景（如白色）替换为透明：
命令：convert in.png -transparent white out.png

如果背景颜色不纯，可以通过指定容错范围（如允许颜色差异10%的点，也一并归入背景）：
命令：convert in.png -fuzz 10% -transparent white out.png

e. 颜色填充

如果想将所有除透明背景外的内容，填充为指定颜色（如红色，RGB值表示为“#FF0000”）：
命令：convert in.png -fuzz 10% -transparent white -fill '#FF0000' +opaque none out.png

这对于处理某些单色icon图片，想将它（批量）替换成为其他背景色时，会非常有用。

f. 文本标签生成

如果想生成带有文本的图片，可以自定义文本内容、文字颜色、背景色等：
命令：convert -size 300x200 -gravity center -pointsize 50 -fill '#FF0000' label:'ABC' out.png

在上述命令中，因为无需输入图片，因此无需提供in.pug，而只需提供out.png。

若使用中文时无法正确输出，很可能是字体的问题，此时可以为其指定使用特定字体文件：
命令：convert -size 300x200 -gravity center -pointsize 50 -fill '#FF0000' -font '/path/to/noto/NotoSansCJKsc-Regular.otf' label:'文字内容' out.png

## 4. 结语

通过命令行处理图片，我们不仅能够精确记录每一步操作，还能通过简单的脚本批量处理成千上万张图片，极大地提升了工作效率。ImageMagick的功能远不止于此，它几乎与Photoshop等重量级图形软件不相上下。如果你对深入学习ImageMagick感兴趣，强烈推荐查阅其官方文档和社区，那里有丰富的资源和灵感等你发掘。

<div class="p-5 text-center">--- END ---</div>

<i><b>注：</b>本文首发表于[“不靠谱颜论”公众号](https://mp.weixin.qq.com/s/EA5J2EENzCiWYDjkZDdwVQ)，并同步至本站。</i>
