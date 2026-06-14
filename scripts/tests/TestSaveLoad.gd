class_name TestSaveLoad
extends RefCounted

func run() -> Array[String]:
	var failures: Array[String] = []
	if not _save_load_preserves_positions_and_rotations():
		failures.append("save/load preserves positions and rotations")
	return failures

func _save_load_preserves_positions_and_rotations() -> bool:
	var save_manager := SaveManager.new()
	var state := ItemState.new()
	state.item_id = "book_blue"
	state.current_room_id = "demo_room"
	state.current_surface_id = "desk_01"
	state.position = Vector2(96, 144)
	state.rotation_degrees = 90
	state.is_placed = true
	state.is_in_box = false
	var states := {"book_blue": state}
	var save: Dictionary = save_manager.build_save_dict("demo_level", states, {"complete": false})
	var loaded: Dictionary = save_manager.states_from_save(save)
	save_manager.free()
	if not loaded.has("book_blue"):
		return false
	var loaded_state: ItemState = loaded["book_blue"]
	return loaded_state.position == Vector2(96, 144) and loaded_state.rotation_degrees == 90 and loaded_state.current_surface_id == "desk_01"
