extends Node

signal hull_health_changed
var position = Vector2(50, 50)
var hull_health = 100 setget set_hull_health

func set_hull_health(val):
	hull_health = val
	emit_signal("hull_health_changed", hull_health) 


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
