extends Node

class_name PlayerState

signal hull_health_changed
signal system_id_changed
var position = Vector2.ZERO
var hull_health = 100 : set = _set_hull_health
var selection = null
var character = "yam"
var ship_type = "Harrier"
var planet_id = 1
var system_id = 1 : set = _set_system_id
var nav_route = []
var systems = null

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
		'ship_type': ship_type,
		'planet_id': planet_id,
		'system_id': system_id
	}

func fromJSON(json):
	position = Vector2(json.position_x, json.position_y)
	_set_hull_health(json.hull_health)
	character = json.character
	ship_type = json.ship_type
	if "planet_id" in json:
		if json.planet_id != null:
			planet_id = int(json.planet_id)
		else:
			planet_id = null
	if "system_id" in json:
		system_id = int(json.system_id)
		
func current_system():
	if systems == null:
		return null
	return systems.get_by_id(system_id)
	
func current_planet():
	var current_system = current_system()
	if current_system == null:
		return null;
	for planet in current_system.planets:
		if planet.id == planet_id:
			return planet
	return null
	
