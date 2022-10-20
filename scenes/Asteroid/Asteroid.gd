extends RigidBody2D

onready var animated_sprite = $AnimatedSprite

func _ready() -> void:
	animated_sprite.frame = rand_range(0,22)
	animated_sprite.play("Asteroid1")
