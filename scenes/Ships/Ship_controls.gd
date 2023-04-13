extends CharacterBody2D

signal begin_jump
signal pre_complete_jump
signal complete_jump

var acceleration: int = 250
var max_speed: int = 500
var rotation_speed: int = 150
var inertia = 50
var direction: Vector2
var player_character = null
var last_damage = 0
var _accelerating = false
var _jump_timer: Timer = Timer.new()
var _last_asteroid_collision = 0

@onready var flame_exhaust: Node2D = $Ship_Exhaust


func _ready() -> void:
	velocity = Vector2.ZERO
	flame_exhaust.hide()
	_jump_timer.one_shot = true
	_jump_timer.timeout.connect(_complete_jump)
	add_child(_jump_timer)


func _physics_process(delta: float) -> void:
	if !_jump_timer.is_stopped():
		return
		
	if Input.is_action_pressed("move_forward"):
		_start_accelerating()
	
	if Input.is_action_just_released("move_forward"):
		_stop_accelerating()
	
	if Input.is_action_pressed("flip_maneuver") && velocity.length() > 0:
		_do_flip(delta)
	elif Input.is_action_pressed("rotate_left"):
		rotation_degrees -= rotation_speed * delta
	elif Input.is_action_pressed("rotate_right"):
		rotation_degrees += rotation_speed * delta
	
	if Input.is_action_pressed("jump"):
		var warning = _jump_warning()
		if warning == '':
			if velocity.length() > 0:
				var flip_complete = _do_flip(delta)
				print("flip_complete ", flip_complete)
				if flip_complete:
					if velocity.length() > acceleration * delta:
						print("_start_accelerating")
						_start_accelerating()
					else:
						_stop_accelerating()
						velocity = Vector2.ZERO
			else:
				var path_direction = GameState.player.systems.get_path_direction(GameState.player.system_id, GameState.player.nav_route[0])
				var rotate_complete = _rotate_to(path_direction.rotated(PI / -2), delta)
				if rotate_complete:
					_begin_jump(path_direction)

		elif Input.is_action_just_pressed("jump"):
			GameState.show_message(warning)
	elif Input.is_action_just_released("jump"):
		if !Input.is_action_pressed("move_forward"):
			_stop_accelerating()

	if _accelerating:
		velocity = velocity.move_toward(Vector2(1, 0).rotated(rotation + PI / 2) * max_speed, acceleration * delta)
	
	if GameState.player.hull_health <= 0: 
		queue_free()

	GameState.player.position = self.position
	
	set_velocity(velocity)
	var collision = move_and_collide(velocity * delta)
	if collision != null:
		_handle_collision(collision)

func _handle_collision(collision: KinematicCollision2D):
	var collider = collision.get_collider()
	if collider is Asteroid and Time.get_unix_time_from_system() - _last_asteroid_collision > 0.5:
		var offset = collider.global_position - collision.get_position()
		collider.apply_impulse(velocity*1.5, offset)
		GameState.player.hull_health = GameState.player.hull_health - collider.damage
#		collider.set_position(collider.position + velocity.normalized()*50)
		_last_asteroid_collision = Time.get_unix_time_from_system()
		print("collide")
	elif collider is Planet:
		move_and_slide()

func _rotate_to(vec: Vector2, delta):
	var rotation_vec = Vector2(1, 0).rotated(rotation)
	var total_degrees_to_rotate = rad_to_deg(rotation_vec.angle_to(vec))
	var frame_degrees_to_rotate = rotation_speed * delta
	if frame_degrees_to_rotate >= abs(total_degrees_to_rotate):
		rotation = vec.angle()
		return true
	else:
		var rotation_direction = total_degrees_to_rotate / abs(total_degrees_to_rotate)
		rotation_degrees += rotation_direction * frame_degrees_to_rotate
		return false
	
func _do_flip(delta):
	return _rotate_to(velocity.rotated(PI/2), delta)
		
func _begin_jump(dir: Vector2):
	if _jump_timer.is_stopped():
		print("begin jump")
		_jump_timer.start(Constants.JumpTime)
		emit_signal("begin_jump", dir)

func _complete_jump():
	print("complete_jump")
	GameState.player.system_id = GameState.player.nav_route.pop_front()
	emit_signal("complete_jump")

func _start_accelerating():
	if !_accelerating:
		_accelerating = true
		flame_exhaust.show()
		flame_exhaust.play()
	
func _stop_accelerating():
	if _accelerating:
		_accelerating = false
		flame_exhaust.stop()
		flame_exhaust.frame = 0
		flame_exhaust.hide()
		flame_exhaust.animation = "acceleration"


func _on_AnimatedSprite_animation_finished() -> void:
	flame_exhaust.animation = "max-speed"


func _get_closest_planet():
	var planets = get_tree().get_nodes_in_group("Planets")
	if !planets.size():
		return null
	var closest_planet = planets[0]
	
	for planet in planets:
		var planetsize = planet.get_node("Selection").get_node_size()
		var closestplanetsize = closest_planet.get_node("Selection").get_node_size()
		if planet.global_position.distance_to(global_position) - planetsize < closest_planet.global_position.distance_to(global_position) - closestplanetsize:
			closest_planet = planet
	
	return closest_planet

func handle_landing_request():
	var closest_planet = _get_closest_planet()
	var speed_check = velocity.length()

	if GameState.player.selection != null:
		GameState.player.selection.get_node("Selection").visible = false
	
	GameState.player.selection = closest_planet
	GameState.player.selection.get_node("Selection").visible = true
	
	if speed_check > 50:
		GameState.show_message("Moving too fast, slow down")
	else:
		var planetsize = closest_planet.get_node("Selection").get_node_size()
		var distance_check = closest_planet.global_position.distance_to(global_position) - planetsize
		print ("distance to planet ", distance_check)
		if distance_check > 150:
			GameState.show_message("You have to get closer if you're trying to land")
		else:
			GameState.show_message("Landing sequence initiated")
			GameState.player.planet_id = closest_planet.planet_data.id
			GameState.scene = Constants.SceneId.PlanetSurface

func _jump_warning() -> String:
	if GameState.player.nav_route.size() == 0:
		var x = InputMap.action_get_events("toggle_system_map")
		return 'Press "'+OS.get_keycode_string(x[0].keycode)+'" to open the map to set where you would like to jump'
	var closest_planet = _get_closest_planet()
	if closest_planet != null and global_position.distance_to(closest_planet.global_position) < 700:
		return "You are too close to the system center. Move away from planets before jumping."
	return ''

func _unhandled_key_input(event):
	if event.is_action_pressed("select_planet"):
		handle_landing_request()
#	if event.is_action_pressed("jump"):
#		handle_jump_request()


	
