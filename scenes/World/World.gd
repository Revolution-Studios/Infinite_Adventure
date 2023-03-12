extends Node2D

@onready var pilot = $Pilot
var _blur_progress: float = 0
var _blur_direction: Vector2 = Vector2.ZERO

func _ready() -> void:
	print("world ready")
	GameState.player.connect("system_id_changed",Callable(self,"_on_system_id_changed"))
	_render_planets()
	if GameState.player.character != null:
		_spawn_ship()
		
func _process(_delta):
	if $Blur.visible:
		_blur_progress += _delta
		print("blur progress ", _blur_progress / Constants.JumpTime)
		$Blur/ColorRect.material.set_shader_parameter('blur', _blur_direction * _blur_progress / Constants.JumpTime * 200)


func _get_ship_class_from_name(ship_name_string):
	if ship_name_string == "Harrier":
		return load("res://scenes/Ships/Harrier/Harrier.tscn")
	elif ship_name_string == "Falcon":
		return load("res://scenes/Ships/Falcon/Falcon.tscn")
	return null
	
func _spawn_ship():
	var ship_class = _get_ship_class_from_name(GameState.player.ship_type)
	if ship_class:
		var ship_instance = ship_class.instantiate()
		ship_instance.connect("begin_jump", _on_begin_jump)
		ship_instance.connect("complete_jump", _on_complete_jump)
		pilot.add_child(ship_instance)
		ship_instance.position = GameState.player.position
	

func _on_begin_jump(dir: Vector2):
	print("world begin_jump")
	_blur_direction = dir
	_blur_progress = 0
	$Blur.visible = true
	
func _on_complete_jump():
	print("world complete_jump")
	_blur_progress = 0
	$Blur.visible = false

func _render_planets():
	var planets = get_tree().get_nodes_in_group("Planets")
	for planet in planets:
		planet.remove_from_group("Planets")
		$Bodies.remove_child(planet)
		planet.queue_free()
	var planet_class = load("res://scenes/Planet/Planet.tscn")
	var current_system = GameState.player.current_system()
	for planet in current_system.planets:
		if "position" in planet:
			var planet_instance = planet_class.instantiate()
			planet_instance.position = Vector2(planet.position[0],planet.position[1])
			planet_instance.add_to_group("Planets")
			planet_instance.planet_data = planet
			$Bodies.add_child(planet_instance)

func _on_system_id_changed(_new_system_id, _old_system_id):
	_render_planets()
