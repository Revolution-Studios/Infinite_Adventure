extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	PlayerState.connect("hull_health_changed",self, "update_health")
func update_health(_val):
	$ProgressBar.value = PlayerState.hull_health

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#
	
