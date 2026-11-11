---
name: alttext-ai-api-source
description: "Where to read alttext.ai's API when its docs can't be fetched; its WP plugin describes every upload itself"
metadata:
  node_type: memory
  type: reference
  originSessionId: 67456e97-9f8e-4083-928f-7bcdbe7e3240
  modified: 2026-11-11T18:24:48.287Z
---

alttext.ai's docs page (alttext.ai/apidocs) is refused by WebFetch. Its own WordPress plugin source is readable at
`plugins.svn.wordpress.org/alttext-ai/trunk/includes/` (`class-atai-api.php`, `class-atai-attachment.php`,
`class-atai.php`) and shows how the API is used. Fact from it (2026-11-11, media-avif-alt planner): the plugin describes
every new upload on `add_attachment` and writes the alt unconditionally; WordPress's REST upload applies the request's
`alt_text` after that hook (attachments controller 6.8 L187-209). So a site running the plugin pays a credit per upload
and a command that sends `alt_text` with the file overwrites the plugin's words. The panel's client is `src/ui/describe.ts`.
Related: [[importer-media-upload]].
