extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	GameState.player.connect("hull_health_changed",self, "update_health")
	update_health(GameState.player.hull_health)

func update_health(val):
	$ProgressBar.value = val

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#
	
