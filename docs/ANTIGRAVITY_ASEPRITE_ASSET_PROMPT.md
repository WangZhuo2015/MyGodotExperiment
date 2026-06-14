# Antigravity Prompt: Aseprite-Style Pixel Art Asset Pass

Copy this whole prompt into Antigravity.

---

You are working in a Godot 4.x GDScript-only project at:

`/Users/wangzhuo/Documents/MyGodotExperiment`

## Goal

Replace the current procedural placeholder visuals with original, cozy, Aseprite-ready 2.5D pixel art assets for a small bedroom organization game inspired by the interaction feel of room-unpacking games, without copying any specific art, UI, level layout, object design, names, story, sounds, or branding from existing games.

The current prototype works, but the visuals are still too placeholder-like. Your job is to create a real pixel-art asset foundation and wire it into the existing Godot project cleanly.

## Non-Negotiable Constraints

- Use Godot 4.x.
- Use GDScript only.
- Do not add external Godot plugins.
- Do not use copyrighted or copied assets.
- Do not recreate any existing game room, object set, UI, narrative, or visual identity.
- Keep everything original.
- Preserve the current placement/save/load/test systems.
- Do not rewrite the game architecture.
- Keep the internal resolution at 480x270.
- Use nearest-neighbor pixel rendering.
- Keep assets small, readable, and easy to replace with actual `.aseprite` source files later.

## Existing Project Context

Important existing files:

- `project.godot`
- `scenes/main/Main.tscn`
- `scenes/room/Room.tscn`
- `scenes/room/PlacementSurface.tscn`
- `scenes/item/Item.tscn`
- `scenes/item/Box.tscn`
- `scripts/data/DemoDataFactory.gd`
- `scripts/item/Item.gd`
- `scripts/item/ItemDef.gd`
- `scripts/placement/PlacementSurface.gd`
- `scripts/room/Room.gd`
- `scripts/tests/RunTests.gd`

Current item ids and intended object types:

- `book_blue` - blue book
- `book_red` - red book
- `mug_red` - red mug
- `photo_frame` - photo frame
- `plush_bear` - plush bear
- `folded_shirt` - folded shirt
- `socks` - socks
- `headphones` - headphones
- `notebook` - notebook
- `pencil_case` - pencil case
- `desk_lamp` - desk lamp
- `toy_car` - toy car
- `toothbrush_cup` - toothbrush cup
- `small_plant` - small plant
- `alarm_clock` - alarm clock
- `shoes` - shoes
- `scarf` - scarf
- `game_cart` - game cartridge
- `keychain` - keychain
- `poster` - poster

Current surface ids and types:

- `desk_01` - desk
- `shelf_01` - shelf
- `bed_01` - bed
- `floor_01` - floor
- `wall_hook_01` - wall hook

## Visual Direction

Make direction A: cozy bedroom, but in a 2.5D orthographic/oblique pixel-art view.

Target feeling:

- warm, lived-in, quiet
- readable object silhouettes
- pixel art with hand-placed detail
- pleasant but not overly polished
- clear room organization fantasy
- visual density similar to a small playable prototype, not a full production level

Camera/view requirements:

- Do not make a flat front-facing room.
- Use a 2.5D room view: visible back wall, floor plane, and furniture tops.
- The player should visually understand that items sit on surfaces, not on a flat poster.
- Furniture should show top faces and front/side thickness:
  - desk: top plane, front apron, side/legs
  - shelf: top/underside thickness, items sitting on it
  - bed: mattress top plane, front edge, pillow on top
  - cardboard box: open top with visible inner walls and flaps
  - floor zone: floor plane receding toward the back wall
  - wall hook: on the back wall, but still aligned with the 2.5D room perspective
- Keep the perspective simple and consistent: orthographic oblique, no dramatic vanishing point.
- Use pixel-art-friendly diagonals only where helpful; avoid blurry rotated/scaled sprites.

Avoid:

- plain rectangles
- abstract color blocks
- flat poster-like room composition
- front-on furniture with no top plane
- noisy over-dithering
- high-resolution painterly art
- modern flat vector art
- copying Unpacking assets or room compositions

## Asset Specifications

Create PNG assets under:

`art/placeholder/aseprite_style/`

Use this structure:

```text
art/placeholder/aseprite_style/
  room/
    bedroom_background.png
    bed.png
    desk.png
    shelf.png
    wall_hook.png
    floor_soft_zone.png
  item/
    book_blue.png
    book_red.png
    mug_red.png
    photo_frame.png
    plush_bear.png
    folded_shirt.png
    socks.png
    headphones.png
    notebook.png
    pencil_case.png
    desk_lamp.png
    toy_car.png
    toothbrush_cup.png
    small_plant.png
    alarm_clock.png
    shoes.png
    scarf.png
    game_cart.png
    keychain.png
    poster.png
  box/
    open_cardboard_box.png
  source_notes/
    README.md
```

PNG sizing rules:

- `bedroom_background.png`: 480x270.
- `bed.png`: around 132x76, 2.5D mattress top plus visible front/side edge.
- `desk.png`: around 132x70, 2.5D top plane plus front/side/legs.
- `shelf.png`: around 120x42, with thickness and a top lip.
- `wall_hook.png`: around 48x54, wall-mounted with small cast shadow.
- `floor_soft_zone.png`: around 432x56, subtle 2.5D rug/floor placement zone.
- `open_cardboard_box.png`: around 124x96, open top with inside bottom visible and four flaps.
- Item PNGs should match their cell footprint using `12 px` per cell, but may include a few pixels of internal transparent padding:
  - 1x1 item: 12x12.
  - 2x1 item: 24x12.
  - 1x2 item: 12x24.
  - 2x2 item: 24x24.
  - 3x1 item: 36x12.
  - 3x3 item: 36x36.

Use transparency for item PNG backgrounds.

Important item-view rule:

- Items should be drawn in a small 2.5D tabletop/floor-object style, not flat icons.
- Show top/side cues when possible:
  - books: top cover plus page edge
  - mug: elliptical/top rim impression, handle, small side highlight
  - frame: slight thickness or leaning angle
  - plush: volume from shadow and side pixels
  - folded clothes: folded stack with top and front fold
  - shoes: pair with visible openings/top shape
  - lamp: base ellipse/top-ish shape, stem, shade volume
  - plant: pot with top opening/leaves
  - poster: this one can remain flat because it belongs on wall hook/wall

Use a restrained palette:

- dark outline: near-black warm brown, not pure black everywhere
- room wall: warm beige/tan
- wood: medium brown with darker underside
- fabric: muted blue, cream, coral, teal
- accents: red mug, yellow lamp, green plant

## Task List

### Task 1: Add Asset Manifest

Create:

`art/placeholder/aseprite_style/source_notes/README.md`

Include:

- visual direction summary
- palette notes
- per-asset size list
- statement that all assets are original placeholders
- note that future `.aseprite` files should export to these PNG paths

### Task 2: Create 2.5D Pixel Art PNG Assets

Create all PNG files listed above.

If you cannot use Aseprite directly, create the PNGs programmatically or with another local drawing approach, but they must look like intentional 2.5D pixel art, not flat rectangles.

Each item must have a distinct silhouette:

- books need spine/page details
- mug needs handle
- frame needs image area and border
- plush needs ears/face/body
- shirt needs fold lines
- socks should read as paired socks
- headphones need band and ear pads
- lamp needs shade/base/stem
- toy car needs wheels
- plant needs pot/leaves
- shoes need two shoes
- scarf needs long cloth shape/fringe or stripe detail
- poster needs framed/printed interior

Each furniture asset must have 2.5D construction:

- bed: top mattress plane, blanket top, front mattress edge, pillow sitting on top
- desk: top plane that can visually hold items, front face, legs, side thickness
- shelf: wall-mounted board with top plane/underside thickness
- box: open top with visible inside floor and flaps
- floor zone: reads as floor/rug surface in the room plane

### Task 3: Wire Item Sprites Into ItemDef

Modify:

`scripts/data/DemoDataFactory.gd`

Set each `ItemDef.sprite_path` to the matching PNG path, for example:

```gdscript
item.sprite_path = "res://art/placeholder/aseprite_style/item/book_blue.png"
```

Keep the current item ids, sizes, allowed surfaces, tags, and required flags unchanged unless a sprite footprint truly requires a small adjustment.

### Task 4: Update Item Rendering

Modify:

`scripts/item/Item.gd`

Preferred behavior:

- If `item_def.sprite_path` is non-empty and loadable, render a `Sprite2D` or draw a loaded texture.
- Keep procedural drawing as fallback only.
- Keep valid/invalid/hover outlines visible.
- Keep collision/placement footprint based on `size_cells`, not sprite alpha.
- Preserve rotation behavior.

Do not break drag/drop.

### Task 5: Wire Room And Furniture Sprites

Modify or extend:

- `scripts/room/Room.gd`
- `scripts/placement/PlacementSurface.gd`
- `scripts/item/Box.gd`

Preferred behavior:

- Draw `bedroom_background.png` as the room base.
- Draw bed/desk/shelf/wall hook/floor zone assets for surfaces.
- Draw `open_cardboard_box.png` for the box.
- Keep existing procedural drawing as fallback if PNGs are missing.
- Keep placement surfaces aligned with their current world positions and grid sizes.
- The visual sprite may be larger than the logical placement grid. Align the logical grid to the top usable surface, not to the whole sprite bounds.
- If needed, add explicit visual offsets per surface in `PlacementSurface.gd`, but keep the validator using the existing grid cells.

### Task 6: Import Settings

Ensure Godot imports PNGs with pixel-art settings:

- nearest filtering
- no smoothing
- no mipmaps
- no compression artifacts

If `.import` files are generated, do not manually hack them unless needed. Prefer project defaults where possible.

### Task 7: Verify

Run:

```bash
godot --headless --path /Users/wangzhuo/Documents/MyGodotExperiment --editor --quit
godot --headless --path /Users/wangzhuo/Documents/MyGodotExperiment --script res://scripts/tests/RunTests.gd
git diff --check
```

Expected:

- Godot imports without script errors.
- Tests print `All tests passed.`
- No whitespace errors from `git diff --check`.

### Task 8: Visual QA

Open the project:

```bash
godot --path /Users/wangzhuo/Documents/MyGodotExperiment
```

Check:

- Room reads as a cozy bedroom at 480x270.
- Box looks open and usable.
- Items are recognizable before dragging.
- Items remain readable when placed on desk/shelf/bed/floor/wall hook.
- Valid/invalid feedback remains visible.
- No sprite is blurry.
- No sprite is scaled with smoothing.
- Dragging and rotation still work.

## Acceptance Criteria

The task is complete only when:

- All listed PNG files exist.
- Item sprites are loaded from `ItemDef.sprite_path`.
- Room, furniture, and box use PNG assets with procedural fallback.
- The room reads as 2.5D: visible floor plane, back wall, furniture tops, and object volume.
- Placed items visually sit on top of desk/shelf/bed/floor rather than looking pasted on a flat screen.
- Current tests pass.
- The game no longer looks like abstract color blocks.
- The art is original and safe to replace with future Aseprite exports.

## What Not To Do

- Do not clone Unpacking's art.
- Do not use screenshots from any commercial game.
- Do not add licensed third-party art.
- Do not introduce C#.
- Do not add plugins.
- Do not change placement logic unless absolutely necessary for sprite loading.
- Do not remove the tests.
- Do not make a full art pipeline editor yet.

## Final Report Format

When finished, report:

- assets created
- scripts modified
- exact test commands run and results
- any known visual limitations
- next recommended art tasks
