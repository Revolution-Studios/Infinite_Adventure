extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().paused = true


func _process(_delta: float) -> void:
	if Input.is_action_just_released("Toggle_full_screen"):
		OS.window_fullscreen = !OS.window_fullscreen


func _on_Dialog_timeline_end(_timeline_name) -> void:
	get_tree().paused = not get_tree().paused 
