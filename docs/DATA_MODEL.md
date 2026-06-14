# Data Model

## ItemDef

`ItemDef.gd` describes an item before runtime:

- `id`
- `display_name`
- `size_cells`
- `sprite_path`
- `allowed_surface_types`
- `forbidden_surface_types`
- `tags`
- `can_rotate`
- `required`
- `story_tags`
- `color`

`color` is temporary placeholder art data. A future Aseprite pipeline can replace it with `sprite_path`.

## ItemState

`ItemState.gd` is runtime and save data:

- `item_id`
- `current_room_id`
- `current_surface_id`
- `position`
- `rotation_degrees`
- `is_placed`
- `is_in_box`

## SurfaceDef

`SurfaceDef.gd` describes an explicit placement region:

- `id`
- `display_name`
- `surface_type`
- `position`
- `grid_size_cells`
- `grid_size_px`
- `allowed_tags`
- `forbidden_tags`
- `color`

## LevelDef

`LevelDef.gd` contains:

- `id`
- `display_name`
- `room_scene_path`
- `surfaces`
- `items`

## Save JSON Schema

```json
{
  "version": 1,
  "level_id": "demo_bedroom",
  "completion_state": {
    "complete": false,
    "placed_required": 3,
    "total_required": 20
  },
  "item_states": [
    {
      "item_id": "book_blue",
      "current_room_id": "demo_bedroom",
      "current_surface_id": "desk_01",
      "position": {"x": 252.0, "y": 130.0},
      "rotation_degrees": 90,
      "is_placed": true,
      "is_in_box": false
    }
  ]
}
```
