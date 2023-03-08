extends RigidBody2D

@onready var animated_sprite = $AnimatedSprite2D
@onready var asteroid_type = $AnimatedSprite2D.sprite_frames.get_animation_names()
var damage = 10

func _ready() -> void:
	randomize()
	animated_sprite.play(asteroid_type[randi() % asteroid_type.size()])
	animated_sprite.frame = randf_range(0,22)
	
