class_name Box
extends Node2D

@export var box_size: Vector2 = Vector2(110, 72)
@export var fill_color: Color = Color(0.58, 0.36, 0.18)
@export var sprite_path: String = "res://art/placeholder/aseprite_style/box/open_cardboard_box.png"
@export var sprite_offset: Vector2 = Vector2(-62, -68)

var box_texture: Texture2D

func _ready() -> void:
	box_texture = _load_texture(sprite_path)

func _draw() -> void:
	if box_texture != null:
		draw_texture(box_texture, sprite_offset)
		return
	var rect := Rect2(-box_size * 0.5, box_size)
	var dark := Color(0.22, 0.12, 0.06)
	var edge := Color(0.37, 0.20, 0.10)
	draw_rect(Rect2(rect.position + Vector2(4, 8), rect.size), Color(0.12, 0.08, 0.05, 0.22))
	draw_rect(rect, fill_color)
	draw_rect(rect, dark, false, 2.0)
	draw_rect(Rect2(rect.position.x + 5, rect.position.y + 9, rect.size.x - 10, 10), Color(0.72, 0.47, 0.24))
	draw_line(Vector2(rect.position.x, rect.position.y + 24), Vector2(rect.end.x, rect.position.y + 24), edge, 2.0)
	draw_line(Vector2(rect.position.x + rect.size.x * 0.5, rect.position.y), Vector2(rect.position.x + rect.size.x * 0.5, rect.end.y), edge, 1.0)
	draw_rect(Rect2(rect.position.x - 8, rect.position.y - 14, rect.size.x * 0.52, 18), Color(0.68, 0.42, 0.20))
	draw_rect(Rect2(rect.position.x + rect.size.x * 0.50, rect.position.y - 12, rect.size.x * 0.50 + 8, 18), Color(0.78, 0.50, 0.26))
	draw_rect(Rect2(rect.position.x - 8, rect.position.y - 14, rect.size.x * 0.52, 18), dark, false, 2.0)
	draw_rect(Rect2(rect.position.x + rect.size.x * 0.50, rect.position.y - 12, rect.size.x * 0.50 + 8, 18), dark, false, 2.0)

func _load_texture(path: String) -> Texture2D:
	if path.is_empty() or not ResourceLoader.exists(path):
		return null
	var resource: Resource = load(path)
	return resource as Texture2D
