class_name CompletionPanel
extends PanelContainer

signal save_requested
signal reset_requested

@onready var status_label: Label = $MarginContainer/VBoxContainer/StatusLabel
@onready var save_button: Button = $MarginContainer/VBoxContainer/ButtonRow/SaveButton
@onready var reset_button: Button = $MarginContainer/VBoxContainer/ButtonRow/ResetButton

func _ready() -> void:
	visible = false
	save_button.pressed.connect(func() -> void: emit_signal("save_requested"))
	reset_button.pressed.connect(func() -> void: emit_signal("reset_requested"))

func update_completion(complete: bool, placed: int, total: int) -> void:
	visible = complete
	status_label.text = "Room complete: %d/%d placed" % [placed, total]
