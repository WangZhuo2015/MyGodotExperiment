class_name DebugPanel
extends PanelContainer

@onready var label: Label = $MarginContainer/Label

var selected_item_id := "-"
var surface_id := "-"
var validity := "NO_SURFACE"
var item_position := Vector2.ZERO
var rotation_value := 0
var placed_required := 0
var total_required := 0
var is_complete := false

func _ready() -> void:
	_refresh()

func update_selection(item: Item, surface: PlacementSurface, result: PlacementResult) -> void:
	selected_item_id = item.item_def.id if item != null and item.item_def != null else "-"
	surface_id = surface.surface_id if surface != null else "-"
	validity = ("%s" % result.reason) if result != null else PlacementResult.NO_SURFACE
	item_position = item.position if item != null else Vector2.ZERO
	rotation_value = item.state.rotation_degrees if item != null and item.state != null else 0
	_refresh()

func update_completion(complete: bool, placed: int, total: int) -> void:
	is_complete = complete
	placed_required = placed
	total_required = total
	_refresh()

func _refresh() -> void:
	if label == null:
		return
	label.text = "Selected: %s\nSurface: %s\nValidity: %s\nPosition: %d,%d\nRotation: %d\nCompletion: %d/%d %s" % [
		selected_item_id,
		surface_id,
		validity,
		int(item_position.x),
		int(item_position.y),
		rotation_value,
		placed_required,
		total_required,
		"READY" if is_complete else "",
	]
