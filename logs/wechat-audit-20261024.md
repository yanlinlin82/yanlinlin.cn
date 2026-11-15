# 公众号文章与原文一致性核查报告

核查日期：2026-10-24

## 范围

- 站内 `公众号` 分类文章：144 篇
- 带公众号原文链接：138 篇
- 无原文链接（未在公众号发布或链接缺失）：6 篇
- 原文页面无法解析：1 篇（`210119`，返回页面无 `js_content`）
- 最终完全一致：55 篇
- 仍有差异、需人工确认：82 篇
- 无法核对：7 篇（6 篇无链接 + 1 篇页面无正文）

## 已完成的修正

- 补全了缺失配图：`210103`、`220104`、`220106`、`220109`、`220120`、`220121`、
  `220122`、`220131`、`220203`、`231220`、`231229`、`231230`、`240102`、
  `240105`、`240114`、`221231-2` 等文章中的 `Image` 占位符和遗漏图片。
- 校正题图：将沿用通用图（如 `2020/0629/code.png`）的题图替换为公众号首图，
  并移除正文中与题图重复的图片块（`220105`、`220109`、`220112`、`220113`、
  `220114`、`220115-1`、`220128`、`220202`、`220209`、`220211`、`240130` 等）。
- 恢复排版：按公众号结构恢复 `##` 标题、有序/无序列表、代码围栏、空行和表格，
  涉及 50 余篇文章；`220122` 的 shell 命令已重新放入代码块。
- 按公众号结构修正了三篇重点文章：`231217`（补副标题、分节标题与编号段落）、
  `231220`（数字标题改为 `##`，C++ 标准版本恢复为列表）、
  `200711`（标题恢复 `~~~` 装饰，三个项目改为编号段落）。
- 保留博客中已有的文字修订（错别字、标点、措辞修正），未回退为公众号原文。

## 仍需人工确认的文章

| 文章 | 文本差异 | 图片差异 | 排版差异 | 文字修订 | 主要问题 |
|---|---:|---:|---:|---:|---|
| `content/posts/2026/261024-编程并没有面目全非.md` | 192 | 31 | 8 | 0 | wechat-only=154, md-only=38, wechat-only-image=30, heading-content=7, image-count=1, heading-count=1 |
| `content/posts/2022/220107-如何有效获取高质量信息.md` | 10 | 0 | 1 | 1 | md-only=9, changed=1, wechat-only=1, list-count=1 |
| `content/posts/2024/240804-管道与命令返回值.md` | 8 | 0 | 2 | 1 | wechat-only=8, changed=1, code-count=1, table-count=1 |
| `content/posts/2023/231227-准确率99%到底有多准-.md` | 7 | 0 | 1 | 0 | wechat-only=5, md-only=2, list-count=1 |
| `content/posts/2022/220203-硬核透视一个C++函数调用.md` | 6 | 0 | 5 | 2 | heading-content=4, md-only=3, wechat-only=3, changed=2, heading-count=1 |
| `content/posts/2024/240216-书评-应用线性代数-向量-矩阵及最小二乘.md` | 6 | 0 | 0 | 0 | wechat-only=5, md-only=1 |
| `content/posts/2022/220201-虎年第一天-扯一张虎皮大旗.md` | 4 | 0 | 4 | 4 | changed=4, md-only=4, heading-content=4 |
| `content/posts/2022/220124-Linux后台运行与虚拟终端.md` | 4 | 0 | 1 | 2 | wechat-only=3, changed=2, md-only=1, code-count=1 |
| `content/posts/2019/191130-厚积当如雪-复盘我的20年技术生涯.md` | 4 | 0 | 1 | 1 | md-only=2, wechat-only=2, changed=1, heading-count=1 |
| `content/posts/2024/240106-Promise- 异步编程的强大工具.md` | 3 | 0 | 17 | 4 | code-content=9, split-merge=5, changed=4, wechat-only=3, list-count=1, list-content=1, heading-count=1 |
| `content/posts/2022/220116-现代C++学习笔记-2-型别推导基础.md` | 2 | 0 | 3 | 6 | changed=6, split-merge=1, wechat-only=1, md-only=1, code-content=1, list-count=1 |
| `content/posts/2022/220207-快速解决近期PubMed访问缓慢的问题.md` | 2 | 0 | 1 | 1 | changed=1, wechat-only=1, md-only=1, code-count=1 |
| `content/posts/2022/220214-来猜猜这四行C++代码的结果.md` | 2 | 0 | 1 | 0 | md-only=1, wechat-only=1, code-content=1 |
| `content/posts/2024/240130-书评-从克服人性弱点来提升管理能力 - 书评.md` | 2 | 0 | 0 | 1 | wechat-only=2, changed=1 |
| `content/posts/2024/240205-觉醒年代-读后感.md` | 2 | 0 | 0 | 1 | wechat-only=2, changed=1 |
| `content/posts/2024/240302-如何理解中心极限定理-.md` | 1 | 3 | 1 | 0 | wechat-only-image=2, wechat-only=1, image-count=1, code-count=1 |
| `content/posts/2019/191126-敢于怀疑-才能免遭蒙蔽.md` | 1 | 2 | 1 | 0 | md-only=1, md-only-image=1, image-count=1, heading-count=1 |
| `content/posts/2019/191127-啊哈-我终于也收到这封勒索电子邮件了.md` | 1 | 2 | 1 | 0 | md-only=1, split-merge=1, md-only-image=1, image-count=1 |
| `content/posts/2020/200713-统计思维就该从小养成 - 书评.md` | 1 | 2 | 0 | 1 | changed=1, md-only=1, wechat-only-image=1, image-count=1 |
| `content/posts/2020/200629-颜论公众号重启中…….md` | 1 | 2 | 0 | 0 | md-only=1, md-only-image=1, image-count=1 |
| `content/posts/2024/240520-捉妖记 - 一个奇怪的插入片段长度分布图.md` | 1 | 0 | 7 | 6 | changed=6, code-content=5, wechat-only=1, code-count=1, list-count=1 |
| `content/posts/2019/191216-1-怎样教娃快速且开心地掌握加减法.md` | 1 | 0 | 2 | 0 | md-only=1, split-merge=1, heading-count=1 |
| `content/posts/2023/231218-来-大胆地用AI技术给自己大脑装上外挂吧-.md` | 1 | 0 | 1 | 3 | changed=3, wechat-only=1, list-count=1 |
| `content/posts/2019/191025-如何优雅地应对焦虑.md` | 1 | 0 | 1 | 0 | md-only=1, heading-count=1 |
| `content/posts/2019/191026-编程二十余年的我-是如何理解精准医疗的-.md` | 1 | 0 | 1 | 0 | md-only=1, heading-count=1 |
| `content/posts/2019/191205-我的育儿观-与其逼娃牛逼-不如先逼自己-给娃一个牛逼的爸.md` | 1 | 0 | 1 | 0 | md-only=1, heading-count=1 |
| `content/posts/2020/200714-你想长生不老吗-.md` | 1 | 0 | 1 | 0 | md-only=1, split-merge=1 |
| `content/posts/2022/220209-狐狸或刺猬-你愿意成为谁-.md` | 1 | 0 | 1 | 0 | md-only=1, split-merge=1 |
| `content/posts/2022/220216-如何在产学两界都做到游刃有余 - 书评.md` | 1 | 0 | 1 | 0 | split-merge=1, wechat-only=1 |
| `content/posts/2024/240112-书评-作为家长的我眼中的素质教育改革-跨学科的项目化学习.md` | 1 | 0 | 0 | 1 | changed=1, wechat-only=1 |
| `content/posts/2019/191017-开篇词-数据统治世界.md` | 1 | 0 | 0 | 0 | md-only=1 |
| `content/posts/2020/200719-你的工作会被替代吗-.md` | 1 | 0 | 0 | 0 | md-only=1 |
| `content/posts/2021/210303-个税年度汇算-年终奖方式怎么选-.md` | 1 | 0 | 0 | 0 | md-only=1 |
| `content/posts/2022/220101-再见2021-你好2022-.md` | 1 | 0 | 0 | 0 | md-only=1 |
| `content/posts/2022/220102-关于生命科学行业的遐想 - 未来.md` | 1 | 0 | 0 | 0 | md-only=1 |
| `content/posts/2022/220105-开始这无穷的开始 - 书评.md` | 1 | 0 | 0 | 0 | md-only=1 |
| `content/posts/2022/220106-人工智能会是洪水猛兽吗-.md` | 1 | 0 | 0 | 0 | md-only=1 |
| `content/posts/2022/220109-如何在Windows环境中使用Linux-.md` | 1 | 0 | 0 | 0 | md-only=1 |
| `content/posts/2022/220112-所谓“编程思维”-到底是什么呢-.md` | 1 | 0 | 0 | 0 | md-only=1 |
| `content/posts/2022/220113-从事生信工作-究竟是远见者-还是工具人-.md` | 1 | 0 | 0 | 0 | md-only=1 |
| `content/posts/2022/220114-神话故事也是可被证伪的- 书评.md` | 1 | 0 | 0 | 0 | md-only=1 |
| `content/posts/2022/220115-1-重器在手-是行善-还是作恶-.md` | 1 | 0 | 0 | 0 | md-only=1 |
| `content/posts/2022/220128-什么是“方法论”-.md` | 1 | 0 | 0 | 0 | md-only=1 |
| `content/posts/2022/220202-数据展示-应点到即止-过犹不及 - 书评.md` | 1 | 0 | 0 | 0 | md-only=1 |
| `content/posts/2022/220211-如何保持脑洞大开 - 书评.md` | 1 | 0 | 0 | 0 | md-only=1 |
| `content/posts/2022/220218-如何用Linux命令删除空行 - 技巧.md` | 1 | 0 | 0 | 0 | md-only=1 |
| `content/posts/2023/231216-我在不惑之年的扬帆启航.md` | 1 | 0 | 0 | 0 | wechat-only=1 |
| `content/posts/2023/231223-如何导出与ChatGPT的聊天记录.md` | 0 | 8 | 1 | 0 | md-only-image=7, image-count=1, list-count=1 |
| `content/posts/2022/220103-我近两年的阅读回顾及精选书单.md` | 0 | 2 | 0 | 0 | wechat-only-image=1, md-only-image=1 |
| `content/posts/2024/240101-超高效的图像处理技能-用ImageMagick搞定批量图片编辑.md` | 0 | 0 | 12 | 0 | split-merge=8, heading-content=3, heading-count=1 |
| `content/posts/2023/231230-软件程序结构演变不完全简史.md` | 0 | 0 | 10 | 6 | changed=6, heading-content=6, split-merge=2, list-count=1, heading-count=1 |
| `content/posts/2024/240115-flat_set的性能测试及其实现.md` | 0 | 0 | 6 | 0 | code-content=4, split-merge=2 |
| `content/posts/2024/240126-使用Lets-Encrypt免费配置HTTPS.md` | 0 | 0 | 6 | 0 | split-merge=2, heading-content=2, code-content=1, heading-count=1 |
| `content/posts/2023/231219-关于投资-从债与股说起.md` | 0 | 0 | 4 | 0 | split-merge=2, list-count=1, heading-count=1 |
| `content/posts/2023/231228-我在创业中的抉择与思考-上-.md` | 0 | 0 | 3 | 0 | split-merge=1, list-count=1, heading-count=1 |
| `content/posts/2024/240122-随心所欲地运用ggplot2画图.md` | 0 | 0 | 2 | 7 | changed=7, list-count=1, heading-count=1 |
| `content/posts/2024/240102-从C++语法特性检查想到的.md` | 0 | 0 | 2 | 5 | changed=5, list-count=1, heading-count=1 |
| `content/posts/2023/231221-Python软件包管理的最佳实践.md` | 0 | 0 | 2 | 3 | changed=3, list-count=1, heading-count=1 |
| `content/posts/2024/240109-我在创业中的抉择与思考-中-.md` | 0 | 0 | 2 | 3 | changed=3, list-count=1, heading-count=1 |
| `content/posts/2024/240131-肿瘤疫苗与免疫检查点治疗联用的临床前支持证据 - 文献学习.md` | 0 | 0 | 2 | 1 | changed=1, list-count=1, list-content=1 |
| `content/posts/2022/220131-财富与真理-藏于时间之中.md` | 0 | 0 | 2 | 0 | split-merge=2 |
| `content/posts/2023/231229-关于单干的推荐书目.md` | 0 | 0 | 2 | 0 | split-merge=1, heading-count=1 |
| `content/posts/2024/240104-我对知识开放的理解和态度.md` | 0 | 0 | 2 | 0 | split-merge=2 |
| `content/posts/2023/231231-2-我最近四年的书单.md` | 0 | 0 | 1 | 79 | changed=79, list-count=1 |
| `content/posts/2022/221231-2-2022年阅读回顾及精选书单.md` | 0 | 0 | 1 | 10 | changed=10, list-count=1 |
| `content/posts/2023/231222-如何破坏团队合作-.md` | 0 | 0 | 1 | 10 | changed=10, list-count=1 |
| `content/posts/2022/220120-持续提升防忽悠力的方法.md` | 0 | 0 | 1 | 7 | changed=7, list-count=1 |
| `content/posts/2022/220119-现代C++学习笔记-3-指针与数组.md` | 0 | 0 | 1 | 0 | code-content=1 |
| `content/posts/2022/220121-正是执着于各种不可能-才孕育了最好的创新.md` | 0 | 0 | 1 | 0 | split-merge=1 |
| `content/posts/2022/220123-假如意外穿越-可以用哪些方法来确定时间.md` | 0 | 0 | 1 | 0 | split-merge=1 |
| `content/posts/2022/220126-山雨欲来的开源世界.md` | 0 | 0 | 1 | 0 | split-merge=1 |
| `content/posts/2023/230416-关于价值投资的两篇书评.md` | 0 | 0 | 1 | 0 | heading-count=1 |
| `content/posts/2023/230726-书评-如何成为超级大反派.md` | 0 | 0 | 1 | 0 | split-merge=1 |
| `content/posts/2024/240105-黑魔法-白魔法-能摸鱼的就是好魔法.md` | 0 | 0 | 1 | 0 | split-merge=1 |
| `content/posts/2024/240107-从flat_set管窥C++的价值权衡.md` | 0 | 0 | 1 | 0 | split-merge=1 |
| `content/posts/2024/240111-密码子的探索发现过程.md` | 0 | 0 | 1 | 0 | heading-count=1 |
| `content/posts/2024/240123-我在创业中的抉择与思考-下-.md` | 0 | 0 | 1 | 0 | list-content=1 |
| `content/posts/2024/240124-C++的类型缩窄转换.md` | 0 | 0 | 1 | 0 | code-content=1 |
| `content/posts/2024/240129-在生成式AI泛滥时代-如何鉴别信息的真伪-.md` | 0 | 0 | 1 | 0 | split-merge=1 |
| `content/posts/2022/220210-现代C++学习笔记-6-函数指针与函数引用.md` | 0 | 0 | 0 | 3 | changed=3 |
| `content/posts/2022/220125-现代C++学习笔记-4-auto的前世今生.md` | 0 | 0 | 0 | 1 | changed=1 |
| `content/posts/2022/220130-现代C++学习笔记-5-auto与型别推导.md` | 0 | 0 | 0 | 1 | changed=1 |

## 无法核对的文章

- `content/posts/2021/210119-分享两个突然冒出来的体会.md`：原文页面可访问但无正文结构，
  无法抓取内容。
- 无原文链接：`220824-django-timeout.md`、`260908-Skill并不能让模型更聪明.md`、
  `260916-AI会惩罚用它的学生吗.md`、`261007-算账才是运营一人公司该具备的核心能力.md`、
  `261015-软件越来越便宜生信人的机会在哪里.md`、`261019-现在是最适合一人公司的时代.md`。

## 说明与例外

- `261024-编程并没有面目全非.md` 的公众号链接指向《科技爱好者周刊#416：编程已经面目全非》，
  是包含该文的周刊合集，并非单篇原文，因此不做逐段对齐。
- `240520-捉妖记`、`240302-如何理解中心极限定理`：公众号用图片展示代码，站内改为代码块，
  属于有意的呈现方式差异。
- 2019 年多篇文章的 `导言`、通用题图，以及部分文章的配图说明，是站内新增内容，公众号原文没有。
- `changed` 类差异主要是站内对原文错别字、标点和措辞的修订，未回退。
- 图片比较使用公众号图片顺序和宽高比（及必要时的哈希）对齐；已修正明确缺图，
  对于同一图片被重新裁切或压缩导致的宽高比差异，仍会列为待确认。
