extends Node2D

@onready var level_manager: LevelManager = $LevelManager
@onready var debug_panel: DebugPanel = $CanvasLayer/DebugPanel
@onready var completion_panel: CompletionPanel = $CanvasLayer/CompletionPanel

func _ready() -> void:
	level_manager.selection_changed.connect(debug_panel.update_selection)
	level_manager.completion_changed.connect(debug_panel.update_completion)
	level_manager.completion_changed.connect(completion_panel.update_completion)
	completion_panel.save_requested.connect(level_manager.save_game)
	completion_panel.reset_requested.connect(level_manager.reset_demo)
