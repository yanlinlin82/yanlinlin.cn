# 待解决问题清单（TODO）

本文件记录 2026-08-02 全站检查中发现的未解决事项，供后续处理。
这些事项或需要外部素材（缺失的源文件），或属于低优先级的清理工作。
已修复问题的完整说明见检查记录。

## 1. 缺失的书评封面图（6 张）

2024 年下半年发布的 6 篇书评引用的封面图从未提交到仓库（已穷尽搜索所有 git 分支与路径确认：`static/uploads/2024/` 的历史文件仅到 `0804`）。
需从外部获取原图（如对应公众号文章配图、豆瓣读书封面等），放入预期路径即可。

| 文章 | 期望的图片路径 |
|---|---|
| `content/posts/2024/240927-1-书评-风云录2023-这一年给我们留下了什么.md` | `static/uploads/2024/0927/book-cover.png` |
| `content/posts/2024/240927-2-书评-故事从这说起-孙悟空父母之谜.md` | `static/uploads/2024/0927/book-cover-2.png` |
| `content/posts/2024/241027-书评-股权融资-创业与风险投资.md` | `static/uploads/2024/1027/book-cover.png` |
| `content/posts/2024/241113-书评-销售大师之乔·吉拉德推销思想精读全集.md` | `static/uploads/2024/1113/book-cover.png` |
| `content/posts/2024/241115-书评-大客户销售这样说这样做.md` | `static/uploads/2024/1115/book-cover.png` |
| `content/posts/2024/241221-书评-持续交付-发布可靠软件的系统方法.md` | `static/uploads/2024/1221/book-cover.png` |

解决方式：获取原封面后放入上表对应目录，文件名与引用保持一致，重新构建即可，无需改动文章内容。

## 2. 无效的 `/public/` 链接（2 处）

2019 年两篇文章将公众号名称链接到 `/public/`，该路径是旧 WordPress 时代的遗留，当前站点不存在此页面。

- `content/posts/2019/191211-1-写在封尘一年后.md:10`
- `content/posts/2019/191231-2019年终总结.md:71`

可选解决方案（需决策）：
- 改为链接到公众号二维码图片：`/images/bukaopuyanlun-qrcode.jpg`
- 或去掉链接，保留纯文本名称。

## 3. 非标准 meta 标签（低优先级）

`layouts/partials/meta-basic.html` 与 `layouts/partials/meta-social.html` 输出了若干浏览器、搜索引擎和社交平台均不识别（本站自定义、无实际作用但无害）的 meta 标签：

- `meta name="author:name|author:title|author:bio|site:name|site:description"`
- `meta name="expertise"`、`meta name="research-area"`、`meta name="content-category"`
- `meta property="og:author|og:author:title|og:author:bio|og:site_description|og:expertise|og:research_area"`

解决方式：删除这些标签，或将信息迁移到已有的 JSON-LD（`Person`、`WebSite`）结构块中。

## 4. 页脚版权年份硬编码

`layouts/partials/footer.html:2` 硬编码了 `© 2007-2026`。建议将结束年份改为 `{{ now.Year }}`，避免逐年过期。

## 5. thumbnails.js 中重复的 resize 监听

`static/assets/js/thumbnails.js` 对 `window` 的 `resize` 事件注册了两次：一次直接注册（第 51 行），一次防抖处理（第 55 行）。直接注册的处理器使防抖版本形同虚设。建议删除直接注册，保留防抖版本。

## 6. 搜索弹窗中重复的 border 声明

`layouts/partials/search.html` 中 `#searchModal .modal-content` 声明了两次 `border`（一次为 2px 橙色边框，一次为 1px `var(--bs-border-color)`）。保留预期的那一条即可。
