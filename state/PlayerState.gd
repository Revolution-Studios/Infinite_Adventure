extends Node

class_name PlayerState

signal hull_health_changed
var position = Vector2(50, 50)
var hull_health = 100 setget set_hull_health
var selection = null

func set_hull_health(val):
	hull_health = val
	emit_signal("hull_health_changed", hull_health) 
