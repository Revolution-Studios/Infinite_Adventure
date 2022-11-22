extends Node2D

var new_dialog = Dialogic.start('Tutorial')


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_child(new_dialog)


func _process(delta: float) -> void:
	if Input.is_action_just_released("Toggle_full_screen"):
		OS.window_fullscreen = !OS.window_fullscreen
