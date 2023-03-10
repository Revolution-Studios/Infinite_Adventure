extends CanvasLayer

var systems = null : set = _set_systems

func _ready():
	GameState.player.connect("hull_health_changed",Callable(self,"_update_health"))
	_update_health(GameState.player.hull_health)

func _update_health(val):
	$ProgressBar.value = val
	
func _input(event):
	print("input UI ", event)
	if event.is_action_pressed("toggle_system_map"):
		print("toggle system map")
		$SystemMap.shown = !$SystemMap.shown

func _set_systems(val):
	systems = val
	$SystemMap.systems = val
