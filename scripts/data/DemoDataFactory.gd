class_name DemoDataFactory
extends RefCounted

static func create_level() -> LevelDef:
	var level := LevelDef.new()
	level.id = "demo_bedroom"
	level.display_name = "Demo Bedroom"
	level.surfaces = _create_surfaces()
	level.items = _create_items()
	return level

static func _create_surfaces() -> Array[SurfaceDef]:
	return [
		SurfaceDef.new("desk_01", "Desk", "desk", Vector2(252, 130), Vector2i(9, 3), 12, Color(0.55, 0.41, 0.28)),
		SurfaceDef.new("shelf_01", "Shelf", "shelf", Vector2(268, 58), Vector2i(8, 2), 12, Color(0.48, 0.34, 0.22)),
		SurfaceDef.new("bed_01", "Bed", "bed", Vector2(48, 136), Vector2i(10, 5), 12, Color(0.45, 0.62, 0.78)),
		SurfaceDef.new("floor_01", "Floor", "floor", Vector2(24, 210), Vector2i(36, 4), 12, Color(0.38, 0.32, 0.26)),
		SurfaceDef.new("wall_hook_01", "Wall Hook", "wall_hook", Vector2(152, 54), Vector2i(4, 4), 12, Color(0.62, 0.58, 0.48)),
	]

static func _create_items() -> Array[ItemDef]:
	return [
		_item("book_blue", "Blue Book", Vector2i(2, 1), ["desk", "shelf", "bed"], [], ["book"], true, true, Color(0.18, 0.36, 0.88)),
		_item("book_red", "Red Book", Vector2i(2, 1), ["desk", "shelf", "bed"], [], ["book"], true, true, Color(0.86, 0.18, 0.14)),
		_item("mug_red", "Red Mug", Vector2i(1, 1), ["desk", "shelf"], ["bed"], ["cup"], false, true, Color(0.92, 0.22, 0.18)),
		_item("photo_frame", "Photo Frame", Vector2i(2, 2), ["desk", "shelf"], [], ["decor"], true, true, Color(0.88, 0.72, 0.42)),
		_item("plush_bear", "Plush Bear", Vector2i(2, 2), ["bed", "shelf"], [], ["soft"], true, true, Color(0.64, 0.42, 0.24)),
		_item("folded_shirt", "Folded Shirt", Vector2i(2, 1), ["bed", "shelf"], [], ["clothing"], true, true, Color(0.31, 0.72, 0.82)),
		_item("socks", "Socks", Vector2i(1, 1), ["bed", "shelf", "floor"], [], ["clothing"], true, true, Color(0.94, 0.94, 0.78)),
		_item("headphones", "Headphones", Vector2i(2, 1), ["desk", "shelf", "bed"], [], ["tech"], true, true, Color(0.12, 0.12, 0.14)),
		_item("notebook", "Notebook", Vector2i(2, 2), ["desk", "shelf", "bed"], [], ["school"], true, true, Color(0.28, 0.68, 0.34)),
		_item("pencil_case", "Pencil Case", Vector2i(2, 1), ["desk", "shelf"], [], ["school"], true, true, Color(0.90, 0.58, 0.18)),
		_item("desk_lamp", "Desk Lamp", Vector2i(1, 2), ["desk"], [], ["light"], true, true, Color(0.98, 0.86, 0.26)),
		_item("toy_car", "Toy Car", Vector2i(2, 1), ["floor", "shelf", "desk"], [], ["toy"], true, true, Color(0.22, 0.70, 0.94)),
		_item("toothbrush_cup", "Toothbrush Cup", Vector2i(1, 2), ["desk", "shelf"], [], ["cup"], true, true, Color(0.78, 0.95, 0.96)),
		_item("small_plant", "Small Plant", Vector2i(2, 2), ["desk", "shelf"], [], ["decor", "plant"], false, true, Color(0.22, 0.64, 0.24)),
		_item("alarm_clock", "Alarm Clock", Vector2i(2, 1), ["desk", "shelf"], [], ["decor"], false, true, Color(0.78, 0.20, 0.62)),
		_item("shoes", "Shoes", Vector2i(2, 1), ["floor"], [], ["floor_only", "clothing"], true, true, Color(0.24, 0.20, 0.18)),
		_item("scarf", "Scarf", Vector2i(3, 1), ["bed", "shelf", "wall_hook"], [], ["clothing"], true, true, Color(0.72, 0.18, 0.56)),
		_item("game_cart", "Game Cart", Vector2i(1, 1), ["desk", "shelf"], [], ["tech"], true, true, Color(0.45, 0.45, 0.50)),
		_item("keychain", "Keychain", Vector2i(1, 1), ["desk", "shelf", "wall_hook"], [], ["small"], false, true, Color(0.96, 0.74, 0.18)),
		_item("poster", "Poster", Vector2i(3, 3), ["wall_hook"], [], ["wall_only", "decor"], false, true, Color(0.86, 0.44, 0.88)),
	]

static func _item(id: String, display_name: String, size: Vector2i, allowed: Array, forbidden: Array, tags: Array, can_rotate: bool, required: bool, color: Color) -> ItemDef:
	return ItemDef.new(id, display_name, size, allowed, forbidden, tags, can_rotate, required, color)
