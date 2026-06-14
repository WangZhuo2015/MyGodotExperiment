class_name SurfaceDef
extends Resource

@export var id: String = ""
@export var display_name: String = ""
@export var surface_type: String = ""
@export var position: Vector2 = Vector2.ZERO
@export var grid_size_cells: Vector2i = Vector2i(1, 1)
@export var grid_size_px: int = 12
@export var allowed_tags: Array[String] = []
@export var forbidden_tags: Array[String] = []
@export var color: Color = Color(0.35, 0.35, 0.35)
@export var visual_sprite_path: String = ""
@export var visual_offset: Vector2 = Vector2.ZERO
@export var grid_origin_px: Vector2 = Vector2.ZERO

func _init(
		p_id: String = "",
		p_display_name: String = "",
		p_surface_type: String = "",
		p_position: Vector2 = Vector2.ZERO,
		p_grid_size_cells: Vector2i = Vector2i(1, 1),
		p_grid_size_px: int = 12,
		p_color: Color = Color(0.35, 0.35, 0.35),
		p_visual_sprite_path: String = "",
		p_visual_offset: Vector2 = Vector2.ZERO,
		p_grid_origin_px: Vector2 = Vector2.ZERO) -> void:
	id = p_id
	display_name = p_display_name
	surface_type = p_surface_type
	position = p_position
	grid_size_cells = p_grid_size_cells
	grid_size_px = p_grid_size_px
	color = p_color
	visual_sprite_path = p_visual_sprite_path
	visual_offset = p_visual_offset
	grid_origin_px = p_grid_origin_px
