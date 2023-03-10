extends CharacterBody2D

var acceleration: int = 250
var max_speed: int = 500
var rotation_speed: int = 150
var inertia = 50
var direction: Vector2
var player_character = null
var last_damage = 0

@onready var flame_exhaust: Node2D = $Ship_Exhaust


func _ready() -> void:
	velocity = Vector2.ZERO
	flame_exhaust.hide()


func _physics_process(delta: float) -> void:
	direction = Vector2(cos(self.rotation + PI/2), sin(self.rotation + PI/2))
	if Input.is_action_pressed("move_forward"):
		velocity = velocity.move_toward(direction * max_speed, acceleration * delta)
		flame_exhaust.show()
		flame_exhaust.play()
	
	if Input.is_action_just_released("move_forward"):
		flame_exhaust.stop()
		flame_exhaust.frame = 0
		flame_exhaust.hide()
		flame_exhaust.animation = "acceleration"
	
	if Input.is_action_pressed("flip_maneuver") && velocity.length() > 0:
		var total_radians_to_rotate = direction.angle_to(velocity.rotated(PI))
		var frame_degrees_to_rotate = rotation_speed * delta
		if frame_degrees_to_rotate >= abs(rad_to_deg(total_radians_to_rotate)):
			rotation_degrees += total_radians_to_rotate
		else:
			var rotation_direction = total_radians_to_rotate / abs(total_radians_to_rotate)
			rotation_degrees += rotation_direction * frame_degrees_to_rotate
	elif Input.is_action_pressed("rotate_left"):
		rotation_degrees -= rotation_speed * delta
	elif Input.is_action_pressed("rotate_right"):
		rotation_degrees += rotation_speed * delta
	
	if _apply_collision_knockback_damage():
		velocity = velocity * -1
	
	if GameState.player.hull_health <= 0: 
		queue_free()

	GameState.player.position = self.position
	
	set_velocity(velocity)
	direction = Vector2(0, 0)
	set_floor_stop_on_slope_enabled(false)
	set_max_slides(4)
	set_floor_max_angle(PI/4)
	# TODOConverter40 infinite_inertia were removed in Godot 4.0 - previous value `false`
	move_and_slide()
	velocity = velocity


func _on_AnimatedSprite_animation_finished() -> void:
	flame_exhaust.animation = "max-speed"


func _apply_collision_knockback_damage()-> bool:
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		
		print("collision ", collider)
		
		if collider is RigidBody2D:
			collider.apply_central_impulse(-collision.get_normal() * inertia)
		
			if i > 0 and collision.get_collider_id() == get_slide_collision(i -1).get_collider_id():  
				continue
		
			if Time.get_ticks_msec() - last_damage > 250:
				print(collider, " ", collider.damage)
				GameState.player.hull_health = GameState.player.hull_health - collider.damage
				last_damage = Time.get_ticks_msec()
				
			return true
		
	return false

func handle_landing_request():
	var planets = get_tree().get_nodes_in_group("Planets")
	var closest_planet = planets[0]
	var speed_check = velocity.length()

	
	for planet in planets:
		var planetsize = planet.get_node("Selection").get_node_size()
		var closestplanetsize = closest_planet.get_node("Selection").get_node_size()
		print(planet.global_position.distance_to(global_position), " ", planetsize, " ", closest_planet.global_position.distance_to(global_position), " ", closestplanetsize)
		if planet.global_position.distance_to(global_position) - planetsize < closest_planet.global_position.distance_to(global_position) - closestplanetsize:
			closest_planet = planet
	if GameState.player.selection != null:
		GameState.player.selection.get_node("Selection").visible = false
	
	GameState.player.selection = closest_planet
	GameState.player.selection.get_node("Selection").visible = true
	
	if speed_check > 50:
		print ("Moving too fast, slow down")
	else:
		var planetsize = closest_planet.get_node("Selection").get_node_size()
		var distance_check = closest_planet.global_position.distance_to(global_position) - planetsize
		print ("distance to planet ", distance_check)
		if distance_check > 150:
			print ("You have to get closer if you're trying to land")
		else:
			print ("Landing sequence initiated")
			GameState.player.planet_id = closest_planet.planet_data.id
			GameState.scene = Constants.SceneId.PlanetSurface

func handle_jump_request():
	print('Jump request')
	if(GameState.player.nav_route.size() == 0):
		print('Open the map to set where you would like to jump')
	else:
		GameState.player.system_id = GameState.player.nav_route.pop_front()
		print("Jumped to ", GameState.player.system_id, " nav_route = ", GameState.player.nav_route)

func _unhandled_key_input(event):
	if event.is_action_pressed("select_planet"):
		handle_landing_request()
	if event.is_action_pressed("jump"):
		handle_jump_request()


	
