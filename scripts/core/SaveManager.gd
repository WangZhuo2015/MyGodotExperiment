class_name SaveManager
extends Node

const SAVE_VERSION := 1
const SAVE_PATH := "user://save_demo.json"

func build_save_dict(level_id: String, item_states: Dictionary, completion_state: Dictionary) -> Dictionary:
	var items: Array = []
	for item_id in item_states.keys():
		var state: ItemState = item_states[item_id]
		items.append(state.to_dict())
	return {
		"version": SAVE_VERSION,
		"level_id": level_id,
		"completion_state": completion_state,
		"item_states": items,
	}

func write_save(level_id: String, item_states: Dictionary, completion_state: Dictionary, path: String = SAVE_PATH) -> Error:
	var file := FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		return FileAccess.get_open_error()
	file.store_string(JSON.stringify(build_save_dict(level_id, item_states, completion_state), "\t"))
	return OK

func read_save(path: String = SAVE_PATH) -> Dictionary:
	if not FileAccess.file_exists(path):
		return {}
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		return {}
	var parsed = JSON.parse_string(file.get_as_text())
	if not (parsed is Dictionary):
		return {}
	return migrate_save(parsed)

func migrate_save(data: Dictionary) -> Dictionary:
	var version := int(data.get("version", 0))
	if version > SAVE_VERSION:
		push_warning("Save version is newer than this prototype understands.")
	if version < 1:
		data["version"] = SAVE_VERSION
	return data

func states_from_save(data: Dictionary) -> Dictionary:
	var states := {}
	for item_data in data.get("item_states", []):
		if item_data is Dictionary:
			var state := ItemState.from_dict(item_data)
			states[state.item_id] = state
	return states
