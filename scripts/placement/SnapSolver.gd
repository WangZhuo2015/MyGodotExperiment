class_name SnapSolver
extends RefCounted

func closest_surface(world_pos: Vector2, surfaces: Array) -> PlacementSurface:
	var best_surface: PlacementSurface = null
	var best_distance := INF
	for surface in surfaces:
		var local_pos: Vector2 = surface.to_local(world_pos)
		var rect := Rect2(Vector2.ZERO, Vector2(surface.grid_size_cells * surface.grid_size_px))
		var distance := 0.0 if rect.has_point(local_pos) else local_pos.distance_to(rect.get_center())
		if distance < best_distance:
			best_distance = distance
			best_surface = surface
	return best_surface

func candidate_cell(surface: PlacementSurface, world_pos: Vector2) -> Vector2i:
	if surface == null:
		return Vector2i.ZERO
	return surface.world_to_grid(world_pos)
