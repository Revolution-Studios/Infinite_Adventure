extends KinematicBody2D

var acceleration: int = 250
var max_speed: int = 500
var rotation_speed: int = 150
var direction: Vector2
var velocity: Vector2 = Vector2.ZERO
onready var ship_nose: Node2D = $Sprite/Ship_Nose

func _physics_process(delta: float) -> void:
	direction = (ship_nose.global_position - global_position).normalized()
	
	
	if Input.is_action_pressed("move_forward"):
		velocity = velocity.move_toward(direction * max_speed, acceleration * delta)
	
	if Input.is_action_just_released("flip_maneuver"):
		rotation_degrees+=180; 
	
	if Input.is_action_pressed("rotate_left"):
		rotation_degrees-= rotation_speed * delta
	
	if Input.is_action_pressed("rotate_right"):
		rotation_degrees+= rotation_speed * delta
		
	velocity = move_and_slide(velocity)

