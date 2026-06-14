class_name LevelManager
extends Node

signal selection_changed(item, surface, result)
signal completion_changed(is_complete, placed_required, total_required)

@export var room_parent_path: NodePath
@export var ui_debug_path: NodePath
@export var ui_completion_path: NodePath

var level_def: LevelDef
var save_manager: SaveManager
var validator := PlacementValidator.new()
var snap_solver := SnapSolver.new()
var surfaces: Array[PlacementSurface] = []
var surfaces_by_id := {}
var item_defs := {}
var item_states := {}
var item_nodes := {}
var selected_item: Item = null
var last_surface: PlacementSurface = null
var last_result := PlacementResult.new(false, PlacementResult.NO_SURFACE)
var completion_state := {"complete": false, "placed_required": 0, "total_required": 0}
var room_root: Node2D
var box: Box

func _ready() -> void:
	save_manager = SaveManager.new()
	add_child(save_manager)
	load_demo_level()

func load_demo_level() -> void:
	level_def = DemoDataFactory.create_level()
	_cache_item_defs()
	_clear_room()
	_spawn_room()
	_spawn_surfaces()
	_spawn_box()
	_spawn_items()
	_load_existing_save_if_present()
	check_completion()

func _cache_item_defs() -> void:
	item_defs.clear()
	for item_def in level_def.items:
		item_defs[item_def.id] = item_def

func _clear_room() -> void:
	var parent := _room_parent()
	for child in parent.get_children():
		child.queue_free()
	surfaces.clear()
	surfaces_by_id.clear()
	item_states.clear()
	item_nodes.clear()

func _spawn_room() -> void:
	var packed: PackedScene = load(level_def.room_scene_path)
	room_root = packed.instantiate() if packed != null else Node2D.new()
	_room_parent().add_child(room_root)

func _spawn_surfaces() -> void:
	var packed := preload("res://scenes/room/PlacementSurface.tscn")
	for surface_def in level_def.surfaces:
		var surface: PlacementSurface = packed.instantiate()
		surface.configure(surface_def)
		room_root.add_child(surface)
		surfaces.append(surface)
		surfaces_by_id[surface.surface_id] = surface

func _spawn_box() -> void:
	box = preload("res://scenes/item/Box.tscn").instantiate()
	box.position = Vector2(82, 78)
	room_root.add_child(box)

func _spawn_items() -> void:
	var packed := preload("res://scenes/item/Item.tscn")
	var index := 0
	for item_def in level_def.items:
		var state := ItemState.new()
		state.item_id = item_def.id
		state.current_room_id = level_def.id
		state.position = box.position + Vector2(-42 + (index % 5) * 18, -26 + int(index / 5) * 14)
		state.is_in_box = true
		item_states[item_def.id] = state
		var item: Item = packed.instantiate()
		room_root.add_child(item)
		item.configure(item_def, state, self)
		item.picked_up.connect(_on_item_picked_up)
		item.drag_updated.connect(_on_item_drag_updated)
		item.dropped.connect(_on_item_dropped)
		item_nodes[item_def.id] = item
		index += 1

func _load_existing_save_if_present() -> void:
	var save: Dictionary = save_manager.read_save()
	if save.is_empty() or String(save.get("level_id", "")) != level_def.id:
		return
	var loaded_states: Dictionary = save_manager.states_from_save(save)
	for item_id in loaded_states.keys():
		if item_states.has(item_id):
			var loaded_state: ItemState = loaded_states[item_id]
			item_states[item_id] = loaded_state
			var item: Item = item_nodes[item_id]
			item.state = loaded_state
			item.position = loaded_state.position
			item.rotation_degrees = loaded_state.rotation_degrees
	rebuild_occupancy()

func rebuild_occupancy() -> void:
	for surface in surfaces:
		surface.reset_occupancy()
	for item_id in item_states.keys():
		var state: ItemState = item_states[item_id]
		if not state.is_placed or not surfaces_by_id.has(state.current_surface_id):
			continue
		var item_def: ItemDef = item_defs[item_id]
		var surface: PlacementSurface = surfaces_by_id[state.current_surface_id]
		var result := validator.can_place(item_def, state, surface, surface.world_to_grid(state.position), state.rotation_degrees)
		if result.valid:
			surface.reserve(state, result.occupied_cells)

func preview_item_placement(item: Item) -> PlacementResult:
	var surface := snap_solver.closest_surface(item.global_position, surfaces)
	last_surface = surface
	if surface == null:
		last_result = PlacementResult.new(false, PlacementResult.NO_SURFACE)
	else:
		var cell := snap_solver.candidate_cell(surface, item.global_position)
		last_result = validator.can_place(item.item_def, item.state, surface, cell, item.state.rotation_degrees)
	selected_item = item
	emit_signal("selection_changed", item, last_surface, last_result)
	return last_result

func place_item(item: Item, result: PlacementResult) -> PlacementResult:
	if not result.valid or last_surface == null:
		check_completion()
		return result
	item.state.current_room_id = level_def.id
	item.state.current_surface_id = last_surface.surface_id
	item.state.position = result.snap_position
	item.state.is_placed = true
	item.state.is_in_box = false
	last_surface.reserve(item.state, result.occupied_cells)
	check_completion()
	return result

func release_item(item: Item) -> void:
	if item.state.current_surface_id != "" and surfaces_by_id.has(item.state.current_surface_id):
		var surface: PlacementSurface = surfaces_by_id[item.state.current_surface_id]
		surface.release(item.state)

func restore_previous_item_surface(item: Item) -> void:
	if item.state.current_surface_id == "" or not surfaces_by_id.has(item.state.current_surface_id):
		check_completion()
		return
	var surface: PlacementSurface = surfaces_by_id[item.state.current_surface_id]
	var cell := surface.world_to_grid(item.position)
	var result := validator.can_place(item.item_def, item.state, surface, cell, item.state.rotation_degrees)
	if result.valid:
		item.state.is_placed = true
		item.state.is_in_box = false
		surface.reserve(item.state, result.occupied_cells)
	check_completion()

func check_completion() -> bool:
	var placed := 0
	var total := 0
	for item_def in level_def.items:
		if not item_def.required:
			continue
		total += 1
		var state: ItemState = item_states[item_def.id]
		if state.is_placed:
			placed += 1
	var complete := total > 0 and placed == total
	completion_state = {"complete": complete, "placed_required": placed, "total_required": total}
	emit_signal("completion_changed", complete, placed, total)
	return complete

func save_game() -> void:
	save_manager.write_save(level_def.id, item_states, completion_state)

func reset_demo() -> void:
	var save_path: String = ProjectSettings.globalize_path(SaveManager.SAVE_PATH)
	if FileAccess.file_exists(SaveManager.SAVE_PATH):
		DirAccess.remove_absolute(save_path)
	load_demo_level()

func surface_type_for_id(surface_id: String) -> String:
	if surfaces_by_id.has(surface_id):
		return surfaces_by_id[surface_id].surface_type
	return ""

func _on_item_picked_up(item: Item) -> void:
	selected_item = item
	emit_signal("selection_changed", item, null, PlacementResult.new(false, PlacementResult.NO_SURFACE))

func _on_item_drag_updated(item: Item) -> void:
	selected_item = item

func _on_item_dropped(item: Item, result: PlacementResult) -> void:
	selected_item = item
	emit_signal("selection_changed", item, last_surface, result)

func _room_parent() -> Node:
	if room_parent_path == NodePath():
		return self
	return get_node(room_parent_path)
