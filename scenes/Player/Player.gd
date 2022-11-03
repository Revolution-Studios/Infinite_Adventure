extends KinematicBody2D

var acceleration: int = 250
var max_speed: int = 500
var rotation_speed: int = 150
var inertia = 50
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
