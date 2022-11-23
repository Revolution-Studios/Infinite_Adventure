extends Node2D

onready var player = $Player
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.hide()
	get_tree().paused = true


func _input(event) -> void:
	if event.is_action_pressed("Toggle_full_screen"): 
		OS.window_fullscreen = !OS.window_fullscreen


func _on_Dialog_timeline_end(_timeline_name) -> void:
	get_tree().paused = !get_tree().paused
	player.show() 
