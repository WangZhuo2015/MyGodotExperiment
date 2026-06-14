# Aseprite-Style Placeholder Assets

This folder is reserved for original 2.5D pixel-art PNG exports.

The framework already points demo items, surfaces, the room background, and the open box at these paths. Missing files are safe: scripts fall back to procedural placeholder drawing until real PNGs are added.

Expected layout:

- `room/` - bedroom background and furniture/surface sprites
- `item/` - one transparent PNG per `ItemDef.id`
- `box/` - open cardboard box sprite
- `source_notes/` - palette, size, and future `.aseprite` export notes
