extends Node2D

var player_ship = null

func _ready() -> void:
	get_tree().paused = true


func _input(event) -> void:
	if event.is_action_pressed("Toggle_full_screen"): 
		OS.window_fullscreen = !OS.window_fullscreen


func _on_Dialog_timeline_end(_timeline_name) -> void:
	get_tree().paused = false


func _on_Dialog_dialogic_signal(value) -> void:
	if value == "Amadou":
		var harrier = load("res://scenes/Pilot/Harrier/Harrier.tscn")
		player_ship = harrier.instance()
	else:
		var falcon = load("res://scenes/Pilot/Falcon/Falcon.tscn")
		player_ship = falcon.instance()

	player_ship.global_position = Vector2(308,374)
	add_child(player_ship) 
