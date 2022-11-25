extends Node2D

onready var pilot = $Pilot
var player_ship = null
var ship_name = null

func _ready() -> void:
	get_tree().paused = true


func _input(event) -> void:
	if event.is_action_pressed("Toggle_full_screen"): 
		OS.window_fullscreen = !OS.window_fullscreen


func _on_Dialog_timeline_end(_timeline_name) -> void:
	get_tree().paused = false


func _on_Dialog_dialogic_signal(value) -> void:
	if value == "Yam":
		var harrier = load("res://scenes/Ships/Harrier/Harrier.tscn")
		player_ship = harrier.instance()
		ship_name = "Harrier"
	else:
		var falcon = load("res://scenes/Ships/Falcon/Falcon.tscn")
		player_ship = falcon.instance()
		ship_name = "Falcon"
	
	
	pilot.global_position = Vector2(308,374)
	pilot.add_child(player_ship)
	pilot.player_character = value
	pilot.ship_type = ship_name
	pilot.ship = pilot.get_node(ship_name)
