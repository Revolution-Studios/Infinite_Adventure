extends KinematicBody2D

var acceleration: int = 250
var max_speed: int = 500
var rotation_speed: int = 150
var inertia = 50
var direction: Vector2
var velocity: Vector2 = Vector2.ZERO
var player_character = null

onready var ship_nose: Node2D = $Sprite/Ship_Nose
onready var flame_exhaust: Node2D = $Ship_Exhaust


func _ready() -> void:
	flame_exhaust.hide()


func _physics_process(delta: float) -> void:
	direction = (ship_nose.global_position - global_position).normalized()
	
	if Input.is_action_pressed("move_forward"):
		velocity = velocity.move_toward(direction * max_speed, acceleration * delta)
		flame_exhaust.show()
		flame_exhaust.play()
	
	if Input.is_action_just_released("move_forward"):
		flame_exhaust.stop()
		flame_exhaust.frame = 0
		flame_exhaust.hide()
		flame_exhaust.animation = "acceleration"
	
	if Input.is_action_just_released("flip_maneuver"):
		rotation_degrees+= direction.angle_to(velocity) *180/PI +180
	
	if Input.is_action_pressed("rotate_left"):
		rotation_degrees-= rotation_speed * delta
	
	if Input.is_action_pressed("rotate_right"):
		rotation_degrees+= rotation_speed * delta
	
	if _apply_collision_knockback_damage():
		velocity = velocity * -1
	
	if PlayerState.hull_health <= 0: 
		queue_free()
	
	PlayerState.position = self.position
	
	velocity = move_and_slide(velocity, Vector2(0, 0), false, 4, PI/4, false)


func _on_AnimatedSprite_animation_finished() -> void:
	flame_exhaust.animation = "max-speed"


func _apply_collision_knockback_damage()-> bool:
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		
		if collision.collider is RigidBody2D: 
			collision.collider.apply_central_impulse(-collision.normal * inertia)
		
			if i > 0 and collision.collider_id == get_slide_collision(i -1).collider_id:  
				continue
		
			PlayerState.hull_health = PlayerState.hull_health - collision.collider.damage
			return true
		
	return false

func handle_landing_request():
	var planets = get_tree().get_nodes_in_group("Planets")
	var closest_planet = planets[0]
	var speed_check = velocity.length()
	
	for planet in planets:
		var planetsize = planet.get_node("Selection").get_size()
		var closestplanetsize = closest_planet.get_node("Selection").get_size()
		if planet.global_position.distance_to(global_position) - planetsize < closest_planet.global_position.distance_to(global_position) - closestplanetsize:
			closest_planet = planet
	if PlayerState.selection != null:
		PlayerState.selection.get_node("Selection").visible = false
	
	PlayerState.selection = closest_planet
	PlayerState.selection.get_node("Selection").visible = true
	
	print ("Speed = ",speed_check)
	if speed_check > 50:
		print ("Moving too fast, slow down")
	else:
		var planetsize = closest_planet.get_node("Selection").get_size()
		var distance_check = closest_planet.global_position.distance_to(global_position) - planetsize
		print ("distance to planet ", distance_check)
		if distance_check > 150:
			print ("You have to get closer if you're trying to land")
		else:
			print ("Landing sequence initiated")

func _input(select_planet):
	if Input.is_action_pressed("select_planet"):
		handle_landing_request()


	
