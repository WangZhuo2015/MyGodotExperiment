class_name LevelDef
extends Resource

@export var id: String = ""
@export var display_name: String = ""
@export var room_scene_path: String = "res://scenes/room/Room.tscn"
@export var surfaces: Array[SurfaceDef] = []
@export var items: Array[ItemDef] = []

func required_item_count() -> int:
	var count := 0
	for item_def in items:
		if item_def.required:
			count += 1
	return count
