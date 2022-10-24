extends RigidBody2D

onready var animated_sprite = $AnimatedSprite
onready var asteroid_type = $AnimatedSprite.frames.get_animation_names()

func _ready() -> void:
	randomize()
	animated_sprite.frame = rand_range(0,22)
	animated_sprite.play(asteroid_type[randi() % asteroid_type.size()])
