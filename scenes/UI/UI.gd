extends CanvasLayer

func _ready():
	GameState.player.connect("hull_health_changed",Callable(self,"_update_health"))
	_update_health(GameState.player.hull_health)

func _update_health(val):
	$ProgressBar.value = val
	
func _unhandled_key_input(event):
	if event.is_action_pressed("toggle_system_map"):
		$HBoxContainer/SystemMap.shown = !$HBoxContainer/SystemMap.shown
