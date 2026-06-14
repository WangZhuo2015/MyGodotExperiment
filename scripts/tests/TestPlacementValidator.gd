class_name TestPlacementValidator
extends RefCounted

var validator := PlacementValidator.new()

class TestSurface:
	var surface_id := ""
	var surface_type := ""
	var grid_size_cells := Vector2i.ZERO
	var grid_size_px := 8
	var occupancy := OccupancyGrid.new()
	var allowed_tags: Array[String] = []
	var forbidden_tags: Array[String] = []

	func _init(p_id: String, p_type: String, p_size: Vector2i) -> void:
		surface_id = p_id
		surface_type = p_type
		grid_size_cells = p_size
		occupancy = OccupancyGrid.new(grid_size_cells)

	func can_accept_item(item_def: ItemDef) -> bool:
		for tag in item_def.tags:
			if forbidden_tags.has(tag):
				return false
		if allowed_tags.size() == 0:
			return true
		for tag in item_def.tags:
			if allowed_tags.has(tag):
				return true
		return false

	func are_cells_free(cells: Array[Vector2i], ignore_item_id: String = "") -> bool:
		return occupancy.are_cells_free(cells, ignore_item_id)

	func reserve_cells(cells: Array[Vector2i], item_id: String) -> void:
		occupancy.reserve_cells(cells, item_id)

	func grid_to_world(cell: Vector2i) -> Vector2:
		return Vector2(cell * grid_size_px)

func run() -> Array[String]:
	var failures: Array[String] = []
	_check(failures, "mug can be placed on desk", _mug_can_be_placed_on_desk())
	_check(failures, "mug cannot be placed on bed", _mug_cannot_be_placed_on_bed())
	_check(failures, "shoes only on floor", _shoes_only_on_floor())
	_check(failures, "poster only on wall hook", _poster_only_on_wall_hook())
	_check(failures, "overlap is rejected", _overlap_is_rejected())
	_check(failures, "out of bounds is rejected", _out_of_bounds_is_rejected())
	_check(failures, "90-degree rotation swaps footprint", _rotation_swaps_footprint())
	return failures

func _check(failures: Array[String], label: String, ok: bool) -> void:
	if not ok:
		failures.append(label)

func _item(id: String, size: Vector2i, allowed: Array[String], forbidden: Array[String] = [], tags: Array[String] = [], can_rotate: bool = true) -> ItemDef:
	return ItemDef.new(id, id.capitalize(), size, allowed, forbidden, tags, can_rotate, true, Color.WHITE)

func _state(id: String) -> ItemState:
	var state := ItemState.new()
	state.item_id = id
	return state

func _surface(id: String, type: String, size: Vector2i) -> TestSurface:
	return TestSurface.new(id, type, size)

func _mug_can_be_placed_on_desk() -> bool:
	var result := validator.can_place(_item("mug", Vector2i(1, 1), ["desk", "shelf"]), _state("mug"), _surface("desk", "desk", Vector2i(4, 2)), Vector2i.ZERO, 0)
	return result.valid and result.reason == PlacementResult.OK

func _mug_cannot_be_placed_on_bed() -> bool:
	var result := validator.can_place(_item("mug", Vector2i(1, 1), ["desk", "shelf"], ["bed"]), _state("mug"), _surface("bed", "bed", Vector2i(4, 2)), Vector2i.ZERO, 0)
	return not result.valid and result.reason in [PlacementResult.WRONG_SURFACE, PlacementResult.FORBIDDEN_SURFACE]

func _shoes_only_on_floor() -> bool:
	var shoes := _item("shoes", Vector2i(2, 1), ["floor"], [], ["floor_only"])
	var bed_result := validator.can_place(shoes, _state("shoes"), _surface("bed", "bed", Vector2i(5, 2)), Vector2i.ZERO, 0)
	var floor_result := validator.can_place(shoes, _state("shoes"), _surface("floor", "floor", Vector2i(8, 3)), Vector2i.ZERO, 0)
	return not bed_result.valid and floor_result.valid

func _poster_only_on_wall_hook() -> bool:
	var poster := _item("poster", Vector2i(2, 2), ["wall_hook"], [], ["wall_only"], false)
	var desk_result := validator.can_place(poster, _state("poster"), _surface("desk", "desk", Vector2i(5, 2)), Vector2i.ZERO, 0)
	var hook_result := validator.can_place(poster, _state("poster"), _surface("hook", "wall_hook", Vector2i(3, 3)), Vector2i.ZERO, 0)
	return not desk_result.valid and hook_result.valid

func _overlap_is_rejected() -> bool:
	var surface := _surface("desk", "desk", Vector2i(4, 2))
	var book := _item("book", Vector2i(2, 1), ["desk"])
	var state := _state("book")
	surface.reserve_cells([Vector2i(1, 0)], "other_item")
	var result := validator.can_place(book, state, surface, Vector2i.ZERO, 0)
	return not result.valid and result.reason == PlacementResult.OVERLAP

func _out_of_bounds_is_rejected() -> bool:
	var result := validator.can_place(_item("book", Vector2i(2, 1), ["shelf"]), _state("book"), _surface("shelf", "shelf", Vector2i(2, 1)), Vector2i(1, 0), 0)
	return not result.valid and result.reason == PlacementResult.OUT_OF_BOUNDS

func _rotation_swaps_footprint() -> bool:
	var item := _item("lamp", Vector2i(1, 2), ["desk"])
	var result := validator.can_place(item, _state("lamp"), _surface("desk", "desk", Vector2i(2, 1)), Vector2i.ZERO, 90)
	return result.valid and result.occupied_cells.size() == 2 and result.occupied_cells.has(Vector2i(1, 0))
