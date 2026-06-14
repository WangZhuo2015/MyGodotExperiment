class_name PlacementValidator
extends RefCounted

func can_place(item_def: ItemDef, item_state: ItemState, surface, candidate_cell: Vector2i, rotation_degrees: int) -> PlacementResult:
	if surface == null:
		return PlacementResult.new(false, PlacementResult.NO_SURFACE)
	if not item_def.can_rotate and normalized_rotation(rotation_degrees) != 0:
		return PlacementResult.new(false, PlacementResult.ROTATION_NOT_ALLOWED)
	if item_def.allowed_surface_types.size() > 0 and not item_def.allowed_surface_types.has(surface.surface_type):
		return PlacementResult.new(false, PlacementResult.WRONG_SURFACE)
	if item_def.forbidden_surface_types.has(surface.surface_type):
		return PlacementResult.new(false, PlacementResult.FORBIDDEN_SURFACE)
	if item_def.tags.has("wall_only") and not ["wall", "wall_hook"].has(surface.surface_type):
		return PlacementResult.new(false, PlacementResult.WRONG_SURFACE)
	if item_def.tags.has("floor_only") and surface.surface_type != "floor":
		return PlacementResult.new(false, PlacementResult.WRONG_SURFACE)
	if not surface.can_accept_item(item_def):
		return PlacementResult.new(false, PlacementResult.FORBIDDEN_SURFACE)

	var footprint := footprint_for(item_def, rotation_degrees)
	var cells := cells_for(candidate_cell, footprint)
	for cell in cells:
		if cell.x < 0 or cell.y < 0 or cell.x >= surface.grid_size_cells.x or cell.y >= surface.grid_size_cells.y:
			return PlacementResult.new(false, PlacementResult.OUT_OF_BOUNDS)
	if not surface.are_cells_free(cells, item_state.item_id):
		return PlacementResult.new(false, PlacementResult.OVERLAP)
	return PlacementResult.new(true, PlacementResult.OK, surface.grid_to_world(candidate_cell), cells)

func footprint_for(item_def: ItemDef, rotation_degrees: int) -> Vector2i:
	var rotation := normalized_rotation(rotation_degrees)
	if rotation == 90 or rotation == 270:
		return Vector2i(item_def.size_cells.y, item_def.size_cells.x)
	return item_def.size_cells

func cells_for(origin: Vector2i, footprint: Vector2i) -> Array[Vector2i]:
	var cells: Array[Vector2i] = []
	for y in range(footprint.y):
		for x in range(footprint.x):
			cells.append(origin + Vector2i(x, y))
	return cells

func normalized_rotation(rotation_degrees: int) -> int:
	var value := rotation_degrees % 360
	if value < 0:
		value += 360
	return value
