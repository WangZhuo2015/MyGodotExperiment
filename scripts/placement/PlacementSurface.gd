class_name PlacementSurface
extends Node2D

@export var surface_id: String = ""
@export var surface_type: String = ""
@export var grid_size_px: int = 12
@export var grid_size_cells: Vector2i = Vector2i(4, 2)
@export var allowed_tags: Array[String] = []
@export var forbidden_tags: Array[String] = []
@export var surface_color: Color = Color(0.35, 0.38, 0.40)
@export var visual_sprite_path: String = ""
@export var visual_offset: Vector2 = Vector2.ZERO
@export var grid_origin_px: Vector2 = Vector2.ZERO

var occupancy := OccupancyGrid.new()
var visual_texture: Texture2D

func _ready() -> void:
	reset_occupancy()
	queue_redraw()

func configure(def: SurfaceDef) -> void:
	surface_id = def.id
	name = def.id
	surface_type = def.surface_type
	position = def.position
	grid_size_px = def.grid_size_px
	grid_size_cells = def.grid_size_cells
	allowed_tags = def.allowed_tags
	forbidden_tags = def.forbidden_tags
	surface_color = def.color
	visual_sprite_path = def.visual_sprite_path
	visual_offset = def.visual_offset
	grid_origin_px = def.grid_origin_px
	visual_texture = _load_texture(visual_sprite_path)
	reset_occupancy()
	queue_redraw()

func reset_occupancy() -> void:
	occupancy = OccupancyGrid.new(grid_size_cells)

func world_to_grid(pos: Vector2) -> Vector2i:
	var local := to_local(pos) - grid_origin_px
	return Vector2i(floori(local.x / grid_size_px), floori(local.y / grid_size_px))

func grid_to_world(cell: Vector2i) -> Vector2:
	return to_global(grid_origin_px + Vector2(cell * grid_size_px))

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

func reserve(item_state: ItemState, cells: Array[Vector2i]) -> void:
	occupancy.release_item(item_state.item_id)
	occupancy.reserve_cells(cells, item_state.item_id)

func reserve_cells(cells: Array[Vector2i], item_id: String) -> void:
	occupancy.reserve_cells(cells, item_id)

func release(item_state: ItemState) -> void:
	occupancy.release_item(item_state.item_id)

func get_candidate_snap_position(_item, world_pos: Vector2) -> Vector2:
	return grid_to_world(world_to_grid(world_pos))

func bounds_rect() -> Rect2:
	return Rect2(to_global(grid_origin_px), Vector2(grid_size_cells * grid_size_px))

func _draw() -> void:
	var size := Vector2(grid_size_cells * grid_size_px)
	if visual_texture != null:
		draw_texture(visual_texture, visual_offset)
		_draw_surface_hint(Rect2(grid_origin_px, size))
		return
	match surface_type:
		"desk":
			_draw_desk(size)
		"shelf":
			_draw_shelf(size)
		"bed":
			_draw_bed(size)
		"floor":
			_draw_floor_zone(size)
		"wall_hook":
			_draw_wall_hook(size)
		_:
			draw_rect(Rect2(Vector2.ZERO, size), surface_color)
			draw_rect(Rect2(Vector2.ZERO, size), Color(0.08, 0.08, 0.09), false, 1.0)

func _draw_desk(size: Vector2) -> void:
	draw_rect(Rect2(0, 4, size.x, size.y - 4), Color(0.39, 0.24, 0.15))
	draw_rect(Rect2(0, 0, size.x, 10), Color(0.61, 0.39, 0.23))
	draw_rect(Rect2(4, 10, 10, size.y + 18), Color(0.37, 0.22, 0.14))
	draw_rect(Rect2(size.x - 14, 10, 10, size.y + 18), Color(0.37, 0.22, 0.14))
	draw_rect(Rect2(6, 3, size.x - 12, 3), Color(0.75, 0.53, 0.32))
	draw_rect(Rect2(0, 0, size.x, 10), Color(0.18, 0.11, 0.08), false, 2.0)
	_draw_surface_hint(Rect2(Vector2.ZERO, size))

func _draw_shelf(size: Vector2) -> void:
	draw_rect(Rect2(-5, size.y - 8, size.x + 10, 8), Color(0.37, 0.22, 0.14))
	draw_rect(Rect2(-2, size.y - 12, size.x + 4, 6), Color(0.65, 0.43, 0.25))
	draw_rect(Rect2(6, size.y - 31, 8, 18), Color(0.23, 0.39, 0.75))
	draw_rect(Rect2(16, size.y - 27, 8, 14), Color(0.76, 0.23, 0.20))
	draw_rect(Rect2(28, size.y - 29, 16, 16), Color(0.38, 0.63, 0.34))
	draw_rect(Rect2(size.x - 28, size.y - 28, 18, 16), Color(0.82, 0.71, 0.43))
	_draw_surface_hint(Rect2(Vector2.ZERO, size))

func _draw_bed(size: Vector2) -> void:
	draw_rect(Rect2(-5, -7, size.x + 10, size.y + 12), Color(0.34, 0.21, 0.16))
	draw_rect(Rect2(0, 0, size.x, size.y), Color(0.48, 0.65, 0.79))
	draw_rect(Rect2(6, 6, 38, 22), Color(0.91, 0.82, 0.67))
	draw_rect(Rect2(48, 5, size.x - 56, size.y - 12), Color(0.36, 0.55, 0.74))
	draw_rect(Rect2(55, 12, size.x - 70, 4), Color(0.62, 0.78, 0.90, 0.65))
	draw_rect(Rect2(0, 0, size.x, size.y), Color(0.13, 0.10, 0.10), false, 2.0)
	_draw_surface_hint(Rect2(Vector2.ZERO, size))

func _draw_floor_zone(size: Vector2) -> void:
	draw_rect(Rect2(Vector2.ZERO, size), Color(0.72, 0.55, 0.38, 0.10))
	for x in range(0, int(size.x), grid_size_px * 3):
		draw_line(Vector2(x, 2), Vector2(x + 18, size.y - 2), Color(0.27, 0.18, 0.12, 0.18), 1.0)
	_draw_surface_hint(Rect2(Vector2.ZERO, size))

func _draw_wall_hook(size: Vector2) -> void:
	draw_rect(Rect2(0, 0, size.x, size.y), Color(0.80, 0.70, 0.55, 0.26))
	draw_rect(Rect2(8, 5, size.x - 16, size.y - 10), Color(0.62, 0.50, 0.38, 0.38), false, 2.0)
	var center := size * 0.5
	draw_line(center + Vector2(0, -12), center + Vector2(0, 6), Color(0.23, 0.17, 0.14), 3.0)
	draw_line(center + Vector2(0, 6), center + Vector2(-8, 13), Color(0.23, 0.17, 0.14), 3.0)
	draw_line(center + Vector2(0, 6), center + Vector2(8, 13), Color(0.23, 0.17, 0.14), 3.0)
	draw_rect(Rect2(center.x - 3, center.y - 15, 6, 6), Color(0.83, 0.68, 0.34))
	_draw_surface_hint(Rect2(Vector2.ZERO, size))

func _draw_surface_hint(rect: Rect2) -> void:
	draw_rect(rect, Color(1.0, 0.95, 0.72, 0.10), false, 1.0)

func _load_texture(path: String) -> Texture2D:
	if path.is_empty() or not ResourceLoader.exists(path):
		return null
	var resource: Resource = load(path)
	return resource as Texture2D
