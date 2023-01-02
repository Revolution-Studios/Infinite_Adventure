extends CanvasLayer

var systems = null setget _set_systems 

func _ready():
	GameState.player.connect("hull_health_changed",self, "_update_health")
	_update_health(GameState.player.hull_health)

func _update_health(val):
	$ProgressBar.value = val
	
func _input(event):
	if event.is_action_pressed("toggle_system_map"):
		$SystemMap.shown = !$SystemMap.shown

func _set_systems(val):
	systems = val
	$SystemMap.systems = val
