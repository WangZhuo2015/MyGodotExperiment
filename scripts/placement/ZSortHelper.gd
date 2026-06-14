class_name ZSortHelper
extends RefCounted

static func z_index_for_world_position(world_position: Vector2, surface_type: String = "") -> int:
	var base := int(world_position.y)
	if surface_type == "wall_hook" or surface_type == "wall":
		return base - 200
	return base
