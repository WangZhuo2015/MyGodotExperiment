class_name Item
extends Area2D

signal picked_up(item)
signal drag_updated(item)
signal dropped(item, result)
signal placement_changed(item)

@export var cell_px: int = 12

var item_def: ItemDef
var state: ItemState
var level_manager: LevelManager
var is_dragging := false
var drag_offset := Vector2.ZERO
var previous_position := Vector2.ZERO
var previous_surface_id := ""
var previous_rotation := 0
var preview_result := PlacementResult.new(false, PlacementResult.NO_SURFACE)
var visual_state := "idle"

@onready var collision_shape: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	input_event.connect(_on_input_event)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func configure(p_item_def: ItemDef, p_state: ItemState, p_level_manager: LevelManager) -> void:
	item_def = p_item_def
	state = p_state
	level_manager = p_level_manager
	name = item_def.id
	position = state.position
	rotation_degrees = state.rotation_degrees
	_update_collision()
	queue_redraw()

func _process(_delta: float) -> void:
	if not is_dragging:
		return
	position = (get_global_mouse_position() + drag_offset).round()
	preview_result = level_manager.preview_item_placement(self)
	visual_state = "valid" if preview_result.valid else "invalid"
	emit_signal("drag_updated", self)
	queue_redraw()

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			pick_up()
		elif is_dragging:
			drop()

func _unhandled_input(event: InputEvent) -> void:
	if is_dragging and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
		drop()
	if is_dragging and event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_R:
		rotate_clockwise()

func pick_up() -> void:
	if item_def == null:
		return
	is_dragging = true
	z_index = 10000
	previous_position = position
	previous_surface_id = state.current_surface_id
	previous_rotation = state.rotation_degrees
	drag_offset = position - get_global_mouse_position()
	level_manager.release_item(self)
	state.is_placed = false
	state.is_in_box = false
	visual_state = "dragging"
	emit_signal("picked_up", self)

func drop() -> void:
	is_dragging = false
	var result := level_manager.place_item(self, preview_result)
	emit_signal("dropped", self, result)
	if result.valid:
		position = result.snap_position
		state.position = position
		state.rotation_degrees = int(rotation_degrees)
		visual_state = "idle"
		emit_signal("placement_changed", self)
	else:
		position = previous_position
		rotation_degrees = previous_rotation
		state.rotation_degrees = previous_rotation
		state.current_surface_id = previous_surface_id
		level_manager.restore_previous_item_surface(self)
		visual_state = "idle"
	z_index = ZSortHelper.z_index_for_world_position(global_position, level_manager.surface_type_for_id(state.current_surface_id))
	queue_redraw()

func rotate_clockwise() -> void:
	if item_def == null or not item_def.can_rotate:
		return
	state.rotation_degrees = (state.rotation_degrees + 90) % 360
	rotation_degrees = state.rotation_degrees
	_update_collision()
	queue_redraw()

func _on_mouse_entered() -> void:
	if not is_dragging:
		visual_state = "hover"
		queue_redraw()

func _on_mouse_exited() -> void:
	if not is_dragging:
		visual_state = "idle"
		queue_redraw()

func footprint_px() -> Vector2:
	if item_def == null:
		return Vector2(cell_px, cell_px)
	return Vector2(item_def.size_cells * cell_px)

func _update_collision() -> void:
	if collision_shape == null or item_def == null:
		return
	var shape := RectangleShape2D.new()
	shape.size = footprint_px()
	collision_shape.shape = shape
	collision_shape.position = shape.size * 0.5

func _draw() -> void:
	if item_def == null:
		return
	var rect := Rect2(Vector2.ZERO, footprint_px())
	var size := Vector2i(int(rect.size.x), int(rect.size.y))
	if not is_dragging:
		draw_rect(Rect2(2, size.y - 2, max(4, size.x - 2), 3), Color(0.05, 0.04, 0.04, 0.22))
	_draw_item_art(item_def.id, size)
	if visual_state == "valid":
		draw_rect(rect, Color(0.28, 1.0, 0.45, 0.18))
		draw_rect(rect.grow(1), Color(0.18, 0.95, 0.35), false, 2.0)
	elif visual_state == "invalid":
		draw_rect(rect, Color(1.0, 0.18, 0.18, 0.20))
		draw_rect(rect.grow(1), Color(1.0, 0.20, 0.18), false, 2.0)
	elif visual_state == "hover":
		draw_rect(rect.grow(1), Color(1.0, 0.95, 0.62, 0.75), false, 1.0)

func _draw_item_art(item_id: String, size: Vector2i) -> void:
	match item_id:
		"book_blue":
			_draw_book(size, Color(0.17, 0.32, 0.78))
		"book_red":
			_draw_book(size, Color(0.78, 0.18, 0.14))
		"mug_red":
			_draw_mug(size)
		"photo_frame":
			_draw_photo_frame(size)
		"plush_bear":
			_draw_plush(size)
		"folded_shirt":
			_draw_folded_shirt(size)
		"socks":
			_draw_socks(size)
		"headphones":
			_draw_headphones(size)
		"notebook":
			_draw_notebook(size)
		"pencil_case":
			_draw_pencil_case(size)
		"desk_lamp":
			_draw_lamp(size)
		"toy_car":
			_draw_toy_car(size)
		"toothbrush_cup":
			_draw_toothbrush_cup(size)
		"small_plant":
			_draw_plant(size)
		"alarm_clock":
			_draw_clock(size)
		"shoes":
			_draw_shoes(size)
		"scarf":
			_draw_scarf(size)
		"game_cart":
			_draw_game_cart(size)
		"keychain":
			_draw_keychain(size)
		"poster":
			_draw_poster(size)
		_:
			_draw_generic_item(size)

func _r(x: int, y: int, w: int, h: int, color: Color) -> void:
	draw_rect(Rect2(x, y, w, h), color)

func _frame(size: Vector2i, color: Color = Color(0.06, 0.05, 0.05)) -> void:
	draw_rect(Rect2(Vector2.ZERO, Vector2(size)), color, false, 1.0)

func _draw_book(size: Vector2i, cover: Color) -> void:
	_r(1, 2, size.x - 2, size.y - 4, Color(0.07, 0.05, 0.05))
	_r(2, 1, size.x - 4, size.y - 3, cover)
	_r(4, 3, 2, size.y - 6, cover.lightened(0.35))
	_r(size.x - 5, 3, 2, size.y - 6, Color(0.92, 0.84, 0.66))
	_r(size.x - 3, 4, 1, size.y - 8, Color(0.38, 0.30, 0.22))

func _draw_mug(size: Vector2i) -> void:
	_r(2, 3, size.x - 5, size.y - 4, Color(0.12, 0.06, 0.05))
	_r(3, 2, size.x - 7, size.y - 4, Color(0.88, 0.18, 0.14))
	_r(size.x - 5, 5, 4, 4, Color(0.12, 0.06, 0.05))
	_r(size.x - 4, 6, 2, 2, Color(0.72, 0.55, 0.42))
	_r(4, 3, size.x - 9, 2, Color(0.97, 0.52, 0.42))

func _draw_photo_frame(size: Vector2i) -> void:
	_r(2, 1, size.x - 4, size.y - 2, Color(0.20, 0.12, 0.08))
	_r(4, 3, size.x - 8, size.y - 6, Color(0.91, 0.78, 0.48))
	_r(6, 5, size.x - 12, size.y - 10, Color(0.52, 0.73, 0.77))
	_r(8, size.y - 8, size.x - 16, 3, Color(0.40, 0.57, 0.35))

func _draw_plush(size: Vector2i) -> void:
	var fur := Color(0.59, 0.36, 0.19)
	_r(4, 4, 5, 5, Color(0.13, 0.08, 0.05))
	_r(size.x - 9, 4, 5, 5, Color(0.13, 0.08, 0.05))
	_r(3, 8, size.x - 6, size.y - 11, Color(0.13, 0.08, 0.05))
	_r(5, 6, size.x - 10, size.y - 10, fur)
	_r(7, 4, size.x - 14, 8, fur.lightened(0.18))
	_r(size.x / 2 - 2, 9, 4, 3, Color(0.86, 0.67, 0.47))
	_r(8, 8, 2, 2, Color(0.03, 0.02, 0.02))
	_r(size.x - 10, 8, 2, 2, Color(0.03, 0.02, 0.02))

func _draw_folded_shirt(size: Vector2i) -> void:
	_r(2, 3, size.x - 4, size.y - 5, Color(0.10, 0.08, 0.07))
	_r(3, 2, size.x - 6, size.y - 5, Color(0.26, 0.70, 0.80))
	_r(1, 4, 5, 4, Color(0.20, 0.56, 0.66))
	_r(size.x - 6, 4, 5, 4, Color(0.20, 0.56, 0.66))
	_r(size.x / 2 - 1, 3, 2, size.y - 7, Color(0.75, 0.91, 0.94, 0.55))

func _draw_socks(size: Vector2i) -> void:
	_r(2, 2, 4, size.y - 5, Color(0.93, 0.90, 0.73))
	_r(5, size.y - 6, 5, 3, Color(0.93, 0.90, 0.73))
	_r(6, 3, 4, size.y - 5, Color(0.82, 0.84, 0.92))
	_r(8, size.y - 5, 4, 3, Color(0.82, 0.84, 0.92))
	_frame(size)

func _draw_headphones(size: Vector2i) -> void:
	_r(5, 2, size.x - 10, 2, Color(0.05, 0.05, 0.06))
	_r(3, 4, 3, size.y - 7, Color(0.05, 0.05, 0.06))
	_r(size.x - 6, 4, 3, size.y - 7, Color(0.05, 0.05, 0.06))
	_r(4, 6, 5, 5, Color(0.19, 0.19, 0.22))
	_r(size.x - 9, 6, 5, 5, Color(0.19, 0.19, 0.22))

func _draw_notebook(size: Vector2i) -> void:
	_r(2, 1, size.x - 4, size.y - 2, Color(0.08, 0.06, 0.05))
	_r(3, 2, size.x - 6, size.y - 4, Color(0.23, 0.62, 0.30))
	_r(5, 4, 2, size.y - 8, Color(0.12, 0.37, 0.18))
	_r(9, 6, size.x - 14, 2, Color(0.82, 0.91, 0.72))
	_r(9, 11, size.x - 16, 2, Color(0.82, 0.91, 0.72, 0.75))

func _draw_pencil_case(size: Vector2i) -> void:
	_r(2, 3, size.x - 4, size.y - 6, Color(0.12, 0.08, 0.04))
	_r(3, 2, size.x - 6, size.y - 6, Color(0.88, 0.52, 0.16))
	_r(5, 5, size.x - 10, 1, Color(0.20, 0.13, 0.08))
	_r(size.x - 8, 4, 3, 3, Color(0.95, 0.82, 0.40))

func _draw_lamp(size: Vector2i) -> void:
	_r(2, 2, size.x - 4, 7, Color(0.12, 0.08, 0.04))
	_r(3, 1, size.x - 6, 7, Color(0.96, 0.82, 0.27))
	_r(size.x / 2 - 1, 8, 2, size.y - 14, Color(0.28, 0.20, 0.15))
	_r(3, size.y - 5, size.x - 6, 3, Color(0.43, 0.31, 0.22))

func _draw_toy_car(size: Vector2i) -> void:
	_r(3, 5, size.x - 6, 5, Color(0.10, 0.06, 0.04))
	_r(4, 3, size.x - 8, 6, Color(0.20, 0.62, 0.88))
	_r(9, 1, 7, 4, Color(0.48, 0.78, 0.90))
	_r(5, size.y - 4, 4, 4, Color(0.04, 0.04, 0.04))
	_r(size.x - 9, size.y - 4, 4, 4, Color(0.04, 0.04, 0.04))

func _draw_toothbrush_cup(size: Vector2i) -> void:
	_r(3, 8, size.x - 6, size.y - 10, Color(0.12, 0.09, 0.08))
	_r(4, 7, size.x - 8, size.y - 10, Color(0.72, 0.91, 0.93))
	_r(4, 2, 2, 8, Color(0.86, 0.22, 0.20))
	_r(size.x - 6, 1, 2, 9, Color(0.24, 0.52, 0.86))
	_r(3, 1, 4, 2, Color(0.95, 0.95, 0.88))

func _draw_plant(size: Vector2i) -> void:
	_r(6, size.y - 8, size.x - 12, 5, Color(0.44, 0.23, 0.12))
	_r(8, size.y - 11, size.x - 16, 4, Color(0.73, 0.39, 0.19))
	_r(size.x / 2 - 2, 6, 4, size.y - 15, Color(0.20, 0.45, 0.18))
	_r(5, 4, 8, 6, Color(0.20, 0.63, 0.25))
	_r(size.x - 13, 3, 8, 7, Color(0.23, 0.72, 0.30))
	_r(size.x / 2 - 5, 1, 10, 6, Color(0.18, 0.56, 0.22))

func _draw_clock(size: Vector2i) -> void:
	_r(4, 2, size.x - 8, size.y - 4, Color(0.13, 0.08, 0.09))
	_r(5, 1, size.x - 10, size.y - 4, Color(0.78, 0.18, 0.55))
	_r(7, 3, size.x - 14, size.y - 8, Color(0.94, 0.78, 0.88))
	_r(size.x / 2, 5, 1, 4, Color(0.12, 0.08, 0.09))
	_r(size.x / 2, 8, 4, 1, Color(0.12, 0.08, 0.09))

func _draw_shoes(size: Vector2i) -> void:
	_r(2, 5, 9, 5, Color(0.12, 0.09, 0.07))
	_r(5, 3, 8, 4, Color(0.23, 0.18, 0.14))
	_r(size.x - 12, 5, 9, 5, Color(0.12, 0.09, 0.07))
	_r(size.x - 15, 3, 8, 4, Color(0.23, 0.18, 0.14))
	_r(5, 8, 7, 1, Color(0.84, 0.78, 0.62))
	_r(size.x - 12, 8, 7, 1, Color(0.84, 0.78, 0.62))

func _draw_scarf(size: Vector2i) -> void:
	_r(2, 3, size.x - 4, 5, Color(0.65, 0.16, 0.48))
	_r(5, 2, 4, size.y - 4, Color(0.78, 0.22, 0.58))
	_r(size.x - 9, 2, 4, size.y - 4, Color(0.78, 0.22, 0.58))
	for x in range(4, size.x - 4, 8):
		_r(x, 3, 2, 5, Color(0.94, 0.58, 0.80))

func _draw_game_cart(size: Vector2i) -> void:
	_r(2, 2, size.x - 4, size.y - 4, Color(0.13, 0.13, 0.15))
	_r(3, 3, size.x - 6, 3, Color(0.47, 0.47, 0.52))
	_r(4, 7, size.x - 8, 2, Color(0.78, 0.78, 0.65))
	_r(size.x - 5, 3, 2, 2, Color(0.86, 0.23, 0.18))

func _draw_keychain(size: Vector2i) -> void:
	_r(3, 2, 5, 5, Color(0.92, 0.68, 0.20))
	_r(5, 4, 1, 1, Color(0.20, 0.15, 0.08))
	_r(7, 6, 4, 2, Color(0.92, 0.68, 0.20))
	_r(9, 8, 2, 3, Color(0.92, 0.68, 0.20))

func _draw_poster(size: Vector2i) -> void:
	_r(3, 2, size.x - 6, size.y - 4, Color(0.18, 0.10, 0.12))
	_r(5, 4, size.x - 10, size.y - 8, Color(0.82, 0.38, 0.78))
	_r(8, 7, size.x - 16, 7, Color(0.96, 0.72, 0.42))
	_r(10, 17, size.x - 20, size.y - 25, Color(0.34, 0.47, 0.70))

func _draw_generic_item(size: Vector2i) -> void:
	_r(1, 1, size.x - 2, size.y - 2, Color(0.08, 0.07, 0.06))
	_r(2, 2, size.x - 4, size.y - 4, item_def.color)
	_r(4, 4, max(2, size.x - 10), 2, item_def.color.lightened(0.25))
