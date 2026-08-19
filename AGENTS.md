# Repository Instructions

- Do not introduce terminal color codes or emoji characters in scripts, logs, comments, or user-facing build messages.
- Write comments, log messages, and documentation in English unless a file already has a strong reason to use another language.
- Prefer self-explanatory code over explanatory comments; add comments only when intent is not obvious from the code itself.
- Keep script output concise and neutral.
- In Chinese prose within Markdown content, use full-width Chinese quotation marks (U+201C/U+201D) instead of ASCII straight quotes (U+0022), except inside code blocks, inline code spans, HTML attributes, and YAML frontmatter structure.

# Blog Content Conventions

## Post files

- Name post files as `YYMMDD-` followed by the main title with special characters (：、、？、《》 etc.) removed and separators replaced with `-` (e.g. `260820-做研究需有自证清白的觉悟.md`).
- If the title contains a subtitle after `：`, keep only the main title when it would make the filename too long.
- The frontmatter `slug` (not the filename) determines the URL. Filenames may be renamed freely without breaking URLs; keep slugs stable and unique.
- The frontmatter `date` must not be in the future: Hugo skips future-dated content by default (dev server runs without `--buildFuture`, and no `future: true` is set). Use the actual current time when publishing.

## AI assistance note

- When an article was written with AI assistance, append after the closing `--- END ---` marker:
  `<i><b>注：</b>本文由AI辅助润色，文章内容与观点均由作者本人提出并复核。</i>`

## Banner images (题图)

- Use SVG directly (e.g. `static/uploads/YYYY/MMDD/article-banner.svg`); do not convert SVG to PNG with ImageMagick for verification or delivery - browsers render SVG natively.
- Prefer minimal or no text in banners; express the concept through graphics and shapes rather than words.
- Reference in the post after the frontmatter, matching the site convention:
  ```html
  <div class="p-3 text-center">
    <img class="img-fluid" src="/uploads/YYYY/MMDD/article-banner.svg" alt="题图" style="max-width:640px">
    <div><small>（题图由AI生成）</small></div>
  </div>
  ```

## Validation

- After content changes, run `hugo --renderToMemory --logLevel warn` to confirm the site builds without errors or warnings.
- Run `python3 scripts/check_slugs.py --content-dir content` to verify slug uniqueness and frontmatter validity.
