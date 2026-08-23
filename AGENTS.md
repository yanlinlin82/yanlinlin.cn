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

## Writing pitfalls

- Avoid passages that assume prior knowledge the reader has not been given. In particular, do not refer to an "original" draft, "the feel/impression" from an earlier version, or any half-finished idea that never appears in the intended final text.
- Do not fabricate a claim just to attack it. Never invent a "common belief", "a common claim found online", "the old convention", or a specific number (e.g. "IQ 110 means ~68%", "the ceiling is 160-170", "an SD=10 scale") that has no real, verifiable source, then set it up as a strawman to refute - even under another label. If the article never introduced the claim, either introduce it with real evidence, or simply present the correct result directly.
- When a source does need explaining, use a neutral, general reference that the reader can verify (e.g. state what the actual empirical rule is, or cite a real fact), rather than pointing at a claim of uncertain provenance.
- Give the reader something to act on. Where the argument depends on the reader's own experience or reasoning, end by inviting them to verify or recompute it themselves (e.g. "try changing the numbers and recalculating"), rather than closing with a lecturing summary.

## Math formulas (KaTeX)

- Math formulas are rendered client-side with KaTeX. Set `math: true` in the frontmatter to load KaTeX.
- **In the Markdown source, write every backslash as a double backslash** - both the `\( ... \)` delimiters and the LaTeX commands inside (e.g. `\dfrac`, `\Phi`, `\sum`, `\mathbf`). Hugo's goldmark turns `\\` into a single `\` in the rendered HTML, which is exactly what KaTeX expects.
- Do NOT write single backslashes (\\(, \dfrac). Goldmark treats `\(` as a Markdown escape sequence and drops the backslash, leaving only `(`, so KaTeX receives no opening delimiter and the formula is rendered as literal text (e.g. it shows as `( z = ... )` instead of a math expression).
