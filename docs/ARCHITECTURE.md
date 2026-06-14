# Architecture

This project is a Godot 4 vertical-slice foundation for a 2D pixel-art room organization game. It uses deterministic rule-based placement instead of physics, and keeps data, validation, scene nodes, and UI separate so future agents can extend one area without needing to rewrite the others.

## Game Loop

`Main.tscn` owns `Game.gd`, a `LevelManager`, the world root, and the debug/completion UI. `LevelManager.gd` creates the demo level from `DemoDataFactory.gd`, spawns the room, surfaces, box, and items, then tracks placement state and completion.

The loop is:

1. Spawn demo data.
2. Player drags an `Item`.
3. The item asks `LevelManager` for a placement preview.
4. `SnapSolver` finds the nearest `PlacementSurface`.
5. `PlacementValidator` returns a `PlacementResult`.
6. Drop either reserves the occupied cells or restores the previous placement.
7. Completion and debug UI update from signals.

## Item Lifecycle

Items start in the open cardboard box with `ItemState.is_in_box = true`. Picking up an item releases any previous surface reservation. Dropping onto a valid surface updates `ItemState`, reserves cells on the surface occupancy grid, sorts z-index, and emits placement signals. Invalid drops restore the previous position, surface, and rotation.

## Drag And Drop Pipeline

`Item.gd` handles hover, pick up, drag, rotate, preview, and drop. Rotation is limited to 0/90/180/270 degrees with the `R` key while dragging. The item never uses rigid body physics; all placement decisions come from grid footprint checks against explicit surfaces.

## Placement Validation Pipeline

`PlacementValidator.gd` is pure logic as much as possible. It checks:

- Missing surface.
- Rotation permissions.
- Allowed and forbidden surface types.
- Wall-only and floor-only tags.
- Surface tag acceptance.
- Bounds.
- Occupancy overlap.

The return value is always a `PlacementResult` with a boolean, reason string, snapped position, and occupied cells.

## 2.5D Visual Layer

The logic grid and the visual art are deliberately separate. `PlacementSurface.gd` can draw a 2.5D PNG via `SurfaceDef.visual_sprite_path`, offset it with `visual_offset`, and still validate placement against a deterministic cell grid. `grid_origin_px` marks where the usable top surface begins inside a larger sprite, so a desk can have a front face and legs without changing item placement rules.

Items load `ItemDef.sprite_path` when a PNG exists, with procedural pixel drawing as fallback. The item collision and placement footprint still come from `size_cells`, not sprite alpha. `Room.gd` and `Box.gd` follow the same pattern: use PNG assets when available, otherwise draw safe placeholders.

## Save/Load Pipeline

`SaveManager.gd` serializes `ItemState` objects into `user://save_demo.json` with version `1`, level id, item states, and completion state. A migration hook exists for future save versions.

## Adding A New Item

Add an `ItemDef` entry in `DemoDataFactory.gd` with id, display name, footprint in cells, allowed surface types, forbidden surface types, tags, rotation support, required flag, and placeholder color.

## Adding A New Surface

Add a `SurfaceDef` entry in `DemoDataFactory.gd` with id, display name, type, world position, grid size, pixel cell size, and color. Use explicit `PlacementSurface` regions instead of making every floor tile placeable.

## Adding A New Room

Create a new room scene under `scenes/room/`, then create a new `LevelDef` factory method with that scene path, surfaces, and item list. `LevelManager` can be expanded to select between level ids later.
