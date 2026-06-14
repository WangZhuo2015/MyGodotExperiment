class_name InputRouter
extends Node

signal rotate_requested

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_R:
		emit_signal("rotate_requested")
