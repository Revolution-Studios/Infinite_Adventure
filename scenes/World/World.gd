extends Node2D

onready var pilot = $Pilot
var player_ship = null
var ship_name = null

func _ready() -> void:
	if GameState.player.character == null:
		var new_dialog = Dialogic.start("Tutorial")
		add_child(new_dialog)
		new_dialog.connect("dialogic_signal", self, "_on_Dialog_dialogic_signal")
		new_dialog.connect("timeline_end", self, "_on_Dialog_timeline_end")
		new_dialog.set_pause_mode(2)
		get_tree().paused = true
	else: 
		pilot.add_child(GameState.player.ship.instance())
		pilot.global_position = Vector2(640,520)

func _on_Dialog_timeline_end(_timeline_name) -> void:
	get_tree().paused = false


func _on_Dialog_dialogic_signal(value) -> void:
	if value == "Yam":
		var harrier = load("res://scenes/Ships/Harrier/Harrier.tscn")
		GameState.player.ship = harrier
		player_ship = harrier.instance()
		ship_name = "Harrier"
	else:
		var falcon = load("res://scenes/Ships/Falcon/Falcon.tscn")
		GameState.player.ship = falcon
		player_ship = falcon.instance()
		ship_name = "Falcon"
	
	pilot.add_child(player_ship)
	pilot.global_position = Vector2(640,520)
	GameState.player.character = value
	GameState.player.ship_type = ship_name
	
