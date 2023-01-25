extends Node

class_name PlayerState

signal hull_health_changed
signal system_id_changed
var position = Vector2.ZERO
var hull_health = 100 setget _set_hull_health
var selection = null
var character = null
var ship_type = null
var system_id = 1
var system_id = 1 setget _set_system_id
var nav_route = []

func _set_hull_health(val):
	hull_health = val
	emit_signal("hull_health_changed", hull_health)

func _set_system_id(val):
	var previous_system_id = system_id
	system_id = val
	emit_signal("system_id_changed", system_id, previous_system_id)

func toJSON():
	return {
		'position_x': position.x,
		'position_y': position.y,
		'hull_health': hull_health,
		'character': character,
		'ship_type': ship_type
	}

func fromJSON(json):
	position = Vector2(json.position_x, json.position_y)
	_set_hull_health(json.hull_health)
	character = json.character
	ship_type = json.ship_type
