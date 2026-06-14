class_name ItemState
extends Resource

@export var item_id: String = ""
@export var current_room_id: String = ""
@export var current_surface_id: String = ""
@export var position: Vector2 = Vector2.ZERO
@export var rotation_degrees: int = 0
@export var is_placed: bool = false
@export var is_in_box: bool = true

func duplicate_state() -> ItemState:
	var state := ItemState.new()
	state.item_id = item_id
	state.current_room_id = current_room_id
	state.current_surface_id = current_surface_id
	state.position = position
	state.rotation_degrees = rotation_degrees
	state.is_placed = is_placed
	state.is_in_box = is_in_box
	return state

func to_dict() -> Dictionary:
	return {
		"item_id": item_id,
		"current_room_id": current_room_id,
		"current_surface_id": current_surface_id,
		"position": {"x": position.x, "y": position.y},
		"rotation_degrees": rotation_degrees,
		"is_placed": is_placed,
		"is_in_box": is_in_box,
	}

static func from_dict(data: Dictionary) -> ItemState:
	var state := ItemState.new()
	state.item_id = String(data.get("item_id", ""))
	state.current_room_id = String(data.get("current_room_id", ""))
	state.current_surface_id = String(data.get("current_surface_id", ""))
	var pos = data.get("position", {})
	if pos is Dictionary:
		state.position = Vector2(float(pos.get("x", 0.0)), float(pos.get("y", 0.0)))
	state.rotation_degrees = int(data.get("rotation_degrees", 0))
	state.is_placed = bool(data.get("is_placed", false))
	state.is_in_box = bool(data.get("is_in_box", true))
	return state
