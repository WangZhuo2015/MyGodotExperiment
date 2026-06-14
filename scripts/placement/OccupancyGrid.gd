class_name OccupancyGrid
extends RefCounted

var size_cells: Vector2i = Vector2i.ZERO
var occupied: Dictionary = {}

func _init(p_size_cells: Vector2i = Vector2i.ZERO) -> void:
	size_cells = p_size_cells

func clear() -> void:
	occupied.clear()

func key(cell: Vector2i) -> String:
	return "%d,%d" % [cell.x, cell.y]

func is_cell_occupied(cell: Vector2i, ignore_item_id: String = "") -> bool:
	var owner := String(occupied.get(key(cell), ""))
	return owner != "" and owner != ignore_item_id

func are_cells_free(cells: Array[Vector2i], ignore_item_id: String = "") -> bool:
	for cell in cells:
		if is_cell_occupied(cell, ignore_item_id):
			return false
	return true

func reserve_cells(cells: Array[Vector2i], item_id: String) -> void:
	for cell in cells:
		occupied[key(cell)] = item_id

func release_item(item_id: String) -> void:
	for cell_key in occupied.keys():
		if occupied[cell_key] == item_id:
			occupied.erase(cell_key)
