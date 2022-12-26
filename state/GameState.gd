extends Node

var scene = null setget _set_scene
var player = PlayerState.new()

signal change_scene

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _set_scene(next_scene):
	scene = next_scene
	emit_signal("change_scene", next_scene) 
	
