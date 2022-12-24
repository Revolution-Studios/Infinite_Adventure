extends Node2D

onready var pilot = $Pilot
var player_ship = null
var ship_name = null

func _ready() -> void:
	print("world scene ready")
	if GameState.play_tutorial:
		get_tree().paused = true
		var new_dialog = Dialogic.start('Tutorial')
		add_child(new_dialog)
		new_dialog.connect("dialogic_signal",self, "_on_Dialog_dialogic_signal")
	else:
		var ship = load("res://scenes/Ships/"+GameState.player.ship_name+"/"+GameState.player.ship_name+".tscn")
		player_ship = ship.instance()
		pilot.global_position = Vector2(308,374)
		pilot.add_child(player_ship)
		

func _on_Dialog_dialogic_signal(value) -> void:
	if value == "unpause":
		get_tree().paused = false
		GameState.play_tutorial = false
	else:
		if value == "Yam":
			var harrier = load("res://scenes/Ships/Harrier/Harrier.tscn")
			player_ship = harrier.instance()
			GameState.player.ship_name = "Harrier"
		elif value == "Amadou":
			var falcon = load("res://scenes/Ships/Falcon/Falcon.tscn")
			player_ship = falcon.instance()
			GameState.player.ship_name = "Falcon"
		pilot.global_position = Vector2(308,374)
		pilot.add_child(player_ship)
		GameState.player.player_name = value

