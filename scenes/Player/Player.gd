extends KinematicBody2D

var acceleration: int = 250
var max_speed: int = 500
var rotation_speed: int = 150
var direction: Vector2
var velocity: Vector2 = Vector2.ZERO
onready var ship_nose: Node2D = $Sprite/Ship_Nose
onready var flame_exhaust: Node2D = $AnimatedSprite

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
		
	velocity = move_and_slide(velocity)
	

func _on_AnimatedSprite_animation_finished() -> void:
	flame_exhaust.animation = "max-speed"

