extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event) -> void:
	if event.is_action_pressed("take_off"):
		GameState.scene = Constants.SceneId.World
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
