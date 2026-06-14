class_name PlacementResult
extends RefCounted

const OK := "OK"
const WRONG_SURFACE := "WRONG_SURFACE"
const FORBIDDEN_SURFACE := "FORBIDDEN_SURFACE"
const OUT_OF_BOUNDS := "OUT_OF_BOUNDS"
const OVERLAP := "OVERLAP"
const ROTATION_NOT_ALLOWED := "ROTATION_NOT_ALLOWED"
const NO_SURFACE := "NO_SURFACE"

var valid: bool
var reason: String
var snap_position: Vector2
var occupied_cells: Array[Vector2i]

func _init(
		p_valid: bool = false,
		p_reason: String = NO_SURFACE,
		p_snap_position: Vector2 = Vector2.ZERO,
		p_occupied_cells: Array[Vector2i] = []) -> void:
	valid = p_valid
	reason = p_reason
	snap_position = p_snap_position
	occupied_cells = p_occupied_cells
