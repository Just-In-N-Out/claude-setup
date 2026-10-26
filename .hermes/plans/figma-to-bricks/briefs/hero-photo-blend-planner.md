# Brief: PLANNER for figma-to-bricks feature "hero-photo-blend" (bug)

## The ask (rewritten)
Bug on the live page `/remanufactured-hydraulics-cylinders-final/` (hero section, desktop). Justin's photo (attached, a phone photo of his screen) shows:
- The hero's background is a greyscale photo of a Terex dump truck on a gravel road; the page title "…FACTURED HYDRAULIC …S", body text and an "EMERGENCY CALL 24/7" pill sit on the left.
- On the right, a second picture (a media/image element) sits over the background: an orange hydraulic cylinder over the truck. That picture is a rectangle (roughly the right 40% of the hero, from about the truck's middle to near the right edge, from just under the header down to the road) whose content is slightly different in tone/brightness from the background behind it, so its **rectangular edges show**: a visible vertical seam through the truck's wheels and a horizontal seam lower down, plus a faint frame/border line around it.
- What he expects: the picture blends into the background so no edges or borders show, like in Figma.

Find the cause (systematic-debugging), comparing the Figma data with the paste:
- In Figma, how does this layer blend? Look for a layer blend mode (multiply, screen, luminosity…), opacity, a gradient/feather mask, an image fill with a gradient overlay, an effect (layer blur, drop shadow, stroke), a crop, or an image whose own edges are transparent (PNG with alpha) that the plugin flattens or re-encodes (JPEG/WebP loses alpha → a solid rectangle). Use Justin's debug JSON (read-only copy; it's build 20.6 of "Hydraulic Cylinder Repairs Final"; check whether this page/design is in it or the corpus) and corpus files with a similar layered hero.
- In the paste: read the live page over HTTP read only (never log in or change anything) — the element's CSS (mix-blend-mode, opacity, filter, border, outline, box-shadow, background on the image wrapper), and the uploaded media file (format, alpha channel, size). A visible border line could be a wrapper's border/outline/shadow or a 1px background showing at sub-pixel edges.
- Reproduce with the renderer at the real paste width (1440/1728/1920), not just Figma's frame width.
- Compare with working siblings: a picture over a background elsewhere that blends correctly.

Then plan a general fix (detect from structure/Figma properties — blend modes, masks, alpha — never key on this page, layer name or picture). If the source picture itself has a visible rectangle (no blending in Figma either), say so and suggest the content fix instead. Questions at the top, lettered, ⭐.

Note: photo-hover-glass (another planner, running) is investigating a "glass" flicker on photo hover: possibly the same picture element. Name any shared cause or files with it.

## Constraints
- Load `skill_view('figma-to-bricks')` (PLANNER) and `skill_view('systematic-debugging')`; say so. rules-summary first, then only the CLAUDE.md sections you need. Look at the attached image with your own vision.
- No worktree, code or commit. Plan to `~/.hermes/plans/figma-to-bricks/hero-photo-blend.md`, questions first, written as if ⭐ chosen, tasks test first, before/after pictures planned, Docs & records task last.
- Size: Opus 5.5 medium builder (Justin's pick), Opus xhigh reviewer.
- In flight: layout-floors (adapt), text-link-followups (normalise/contact-links, style/rag, emit/page-addresses, emit/elements, ui/site-pages), google-font-hardening (ui/fonts.ts), photo-hover-glass and csv-list-pdfs planners, card-link-words (awaiting go). Name overlaps.
- Other bugs: found_else. Plain words for WhatsApp.

Justin's words: "There is also an issue. The media photo here and the background you can see how it shows the borders of the media. Is it possible we can make it blend so that the borders do not show? Put this also on an opus 5.5 medium model"
