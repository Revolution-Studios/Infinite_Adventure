extends KinematicBody2D

var hull_health = 100
var acceleration: int = 250
var max_speed: int = 500
var rotation_speed: int = 150
var inertia = 25
var direction: Vector2
var velocity: Vector2 = Vector2.ZERO
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
		
	velocity = move_and_slide(velocity, Vector2(0, 0), false, 4, 0.785, false)
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		print("Collided with ", collision.collider.name)
		if collision.collider.name.begins_with("Asteroid"):
			collision.collider.apply_central_impulse(-collision.normal * inertia)
			if hull_health > 0:
				hull_health = hull_health -10
			else:
				print("health is 0")
				visible = false

func _on_AnimatedSprite_animation_finished() -> void:
	flame_exhaust.animation = "max-speed"

