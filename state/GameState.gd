extends Node

var scene = null : set = _set_scene
var player = PlayerState.new()

signal change_scene_to_file

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _set_scene(next_scene):
	scene = next_scene
	if scene == Constants.SceneId.World3D:
		player.queue_free()
		player = PlayerState.new()
	emit_signal("change_scene_to_file", next_scene) 
	
