class_name Room
extends Node2D

@export var background_path: String = "res://art/placeholder/aseprite_style/room/bedroom_background.png"

var background_texture: Texture2D

func _ready() -> void:
	background_texture = _load_texture(background_path)

func _draw() -> void:
	if background_texture != null:
		draw_texture(background_texture, Vector2.ZERO)
		return
	_draw_wall()
	_draw_floor()
	_draw_window()
	_draw_wall_details()

func _draw_wall() -> void:
	draw_rect(Rect2(0, 0, 480, 194), Color(0.72, 0.63, 0.51))
	for y in range(16, 188, 16):
		draw_line(Vector2(0, y), Vector2(480, y), Color(0.64, 0.54, 0.43, 0.22), 1.0)
	for x in range(12, 480, 48):
		draw_rect(Rect2(x, 18, 2, 4), Color(0.82, 0.74, 0.62, 0.45))
		draw_rect(Rect2(x + 24, 50, 2, 4), Color(0.82, 0.74, 0.62, 0.35))
	draw_rect(Rect2(0, 188, 480, 6), Color(0.49, 0.33, 0.23))
	draw_rect(Rect2(0, 194, 480, 3), Color(0.25, 0.17, 0.13))

func _draw_floor() -> void:
	draw_rect(Rect2(0, 197, 480, 73), Color(0.55, 0.39, 0.27))
	for y in range(206, 270, 13):
		draw_line(Vector2(0, y), Vector2(480, y), Color(0.39, 0.27, 0.19), 1.0)
	for x in range(0, 480, 36):
		draw_line(Vector2(x, 197), Vector2(x + 18, 270), Color(0.62, 0.46, 0.32, 0.22), 1.0)
	draw_rect(Rect2(168, 218, 118, 30), Color(0.64, 0.42, 0.38, 0.75))
	draw_rect(Rect2(174, 223, 106, 20), Color(0.78, 0.57, 0.48, 0.55), false, 2.0)

func _draw_window() -> void:
	draw_rect(Rect2(28, 24, 68, 56), Color(0.38, 0.28, 0.25))
	draw_rect(Rect2(32, 28, 60, 48), Color(0.86, 0.78, 0.63))
	draw_rect(Rect2(38, 34, 48, 36), Color(0.54, 0.74, 0.78))
	draw_line(Vector2(62, 34), Vector2(62, 70), Color(0.31, 0.45, 0.50), 2.0)
	draw_line(Vector2(38, 52), Vector2(86, 52), Color(0.31, 0.45, 0.50), 2.0)
	draw_rect(Rect2(34, 30, 10, 44), Color(0.82, 0.44, 0.38))
	draw_rect(Rect2(80, 30, 10, 44), Color(0.82, 0.44, 0.38))
	draw_rect(Rect2(42, 38, 12, 5), Color(0.88, 0.93, 0.86, 0.45))

func _draw_wall_details() -> void:
	draw_rect(Rect2(122, 32, 42, 54), Color(0.35, 0.24, 0.23))
	draw_rect(Rect2(126, 36, 34, 46), Color(0.78, 0.40, 0.49))
	draw_rect(Rect2(132, 42, 22, 10), Color(0.94, 0.72, 0.54))
	draw_rect(Rect2(134, 56, 18, 20), Color(0.39, 0.53, 0.70))
	draw_rect(Rect2(402, 38, 36, 30), Color(0.45, 0.31, 0.25))
	draw_rect(Rect2(406, 42, 28, 22), Color(0.86, 0.76, 0.54))
	draw_line(Vector2(412, 48), Vector2(428, 58), Color(0.33, 0.43, 0.34), 2.0)

func _load_texture(path: String) -> Texture2D:
	if path.is_empty() or not ResourceLoader.exists(path):
		return null
	var resource: Resource = load(path)
	return resource as Texture2D
