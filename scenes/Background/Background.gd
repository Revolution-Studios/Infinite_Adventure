extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	assert(get_tree().get_root().connect("size_changed",Callable(self,"_size_changed")) == 0)
	_load_background()
	
func _load_background():
	var size = get_viewport().get_visible_rect().size
	$Stars/ColorRect.set_size(size)
	
func _size_changed():
	_load_background()

func _process(_delta):
	$Stars/ColorRect.material.set_shader_parameter('offset', GameState.player.position)
