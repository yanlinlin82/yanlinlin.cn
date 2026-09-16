---
name: banner-svg
description: Design and generate 题图/封面 banner SVGs (1200x500, dark gradient, glow, symmetric) instead of flat clip-art. Use when creating or revising a banner, 题图, or cover image for a blog post or article, or when a banner needs to look more high-tech and professional.
---

# Banner SVG Design

Load this skill when generating or revising a 题图 (banner/cover) SVG. The target is a clean,
high-tech, professional graphic built from gradients, glow and symmetry — not a flat background
with clip-art shapes on it.

Start from `templates/banner-dark.svg` (copy it, then add the core silhouette and satellites).

## Hard requirements

- Deliver SVG directly. Never convert SVG to PNG (browsers render SVG natively).
- Canvas 1200 x 500, with `viewBox="0 0 1200 500"` and matching `width`/`height` (9:5 also fits
  WeChat cover specs).
- No text in the image: express the idea with shapes only. The post title already sits next to it.
- Mirror-symmetric composition about the vertical centerline (x = 600).
- Verify the result parses: `python3 -c "import xml.etree.ElementTree as ET; ET.parse('file.svg')"`.

## Forbidden (these read as amateurish)

- A flat solid-color background.
- Stick figures (head circle plus line limbs) or any literal clip-art.
- Randomly scattered dots/confetti pretending to be texture.
- Text labels.
- More than one accent hue family, beyond a single warm accent.

## Required layer stack (back to front)

1. **Background**: diagonal, 3-stop dark linear gradient, e.g. `#070f1e` -> `#152340` -> `#08131f`.
2. **Grid**: 48x48 `<pattern>` of 1px lines at about 0.3 opacity — texture, never dominant.
3. **Ambient light**: large centered `radialGradient` in the accent hue, roughly 0.4 opacity at
   the center fading to 0.
4. **Vignette**: `radialGradient` overlay, transparent at the center, about 0.85 dark at the edges.
5. **Depth rings and HUD frame**: 1px dashed concentric circles, plus two corner brackets (e.g.
   top-left and bottom-right) at about 0.5 opacity, for an instrument-panel feel.
6. **Connectors**: 1.5-2px lines from the core out to the satellite nodes, each with a small
   (r ~3.5) dot about 0.7 of the way out.
7. **Core**: filled circle (r ~88) with a dark gradient fill and a gradient stroke, plus a soft
   `feGaussianBlur` glow filter. Inside it, a solid head-and-shoulders silhouette, optionally with
   a thin accent arc across the head to suggest a worn device.
8. **Satellites**: four 46x46 rounded squares (`rx="13"`) centered on a dashed orbit ring (r ~180)
   at 45/135/225/315 degrees, each carrying one minimal glyph (gear, text lines, bar chart, check
   mark) in that node's accent color.

## Palette

- Accent gradient: cyan `#22d3ee` -> blue `#3b82f6` -> indigo `#818cf8`.
- One warm accent only: `#f59e0b`.
- Silhouette: `#f8fafc` -> `#94a3b8`.
- Node fill `#0e1c33` (or `#0b1c33` for joint dots) over the dark base.
- Define all of these as `<linearGradient>`/`<radialGradient>` in `<defs>` and reference them via
  `url(#id)`. Do not hardcode flat hex fills for strokes that span the canvas.

## Geometry discipline

- Center the composition at (600, 250). Verify each glyph is centered inside its node by computing
  its bounding box — a few pixels off is visible.
- Quadratic curve midpoint: for `M x1,y1 Q cx,cy x2,y2`, the point at t = 0.5 is
  `(0.25*x1 + 0.5*cx + 0.25*x2, 0.25*y1 + 0.5*cy + 0.25*y2)`. Attach struts and pivot dots to that
  point, not to the curve's endpoints.
- Draw connectors and orbit rings before the core disc and the nodes, so the opaque shapes hide the
  inner ends of the lines and the dashes under the nodes.

## Light variant

If a light banner is requested instead (to match an existing light set), keep the same layer
discipline and symmetry, and only swap the palette, e.g. background `#f7f9fc` -> `#eef4fb`,
accent cyan/blue as above, silhouette `#334155` -> `#64748b`, grid stroke `#dbe6f5`, vignette white.

## Blog conventions (yanlinlin.cn)

- Path: `static/uploads/YYYY/MMDD/article-banner.svg`, where `MMDD` is the post date.
- Reference it in the post immediately after the frontmatter:

  ```html
  <div class="p-3 text-center">
    <img class="img-fluid" src="/uploads/YYYY/MMDD/article-banner.svg" alt="题图" style="max-width:640px">
    <div><small>（题图由AI生成）</small></div>
  </div>
  ```

- Rebuild so the file is copied into the output, then confirm:
  `hugo --logLevel warn --quiet` and check that `public/uploads/YYYY/MMDD/article-banner.svg` exists.
