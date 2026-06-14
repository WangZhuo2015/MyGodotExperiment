class_name ItemDef
extends Resource

@export var id: String = ""
@export var display_name: String = ""
@export var size_cells: Vector2i = Vector2i.ONE
@export var sprite_path: String = ""
@export var allowed_surface_types: Array[String] = []
@export var forbidden_surface_types: Array[String] = []
@export var tags: Array[String] = []
@export var can_rotate: bool = true
@export var required: bool = true
@export var story_tags: Array[String] = []
@export var color: Color = Color.WHITE

func _init(
		p_id: String = "",
		p_display_name: String = "",
		p_size_cells: Vector2i = Vector2i.ONE,
		p_allowed_surface_types: Array = [],
		p_forbidden_surface_types: Array = [],
		p_tags: Array = [],
		p_can_rotate: bool = true,
		p_required: bool = true,
		p_color: Color = Color.WHITE) -> void:
	id = p_id
	display_name = p_display_name
	size_cells = p_size_cells
	allowed_surface_types.assign(p_allowed_surface_types)
	forbidden_surface_types.assign(p_forbidden_surface_types)
	tags.assign(p_tags)
	can_rotate = p_can_rotate
	required = p_required
	color = p_color
