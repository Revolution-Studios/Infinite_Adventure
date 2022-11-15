extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false

func get_size():
	return (rect_size.x)/2
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
