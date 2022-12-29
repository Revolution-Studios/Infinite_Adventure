extends Node2D

onready var pilot = $Pilot

func _ready() -> void:
	if GameState.player.character == null:
		var new_dialog = Dialogic.start("Tutorial")
		add_child(new_dialog)
		new_dialog.connect("dialogic_signal", self, "_on_Dialog_dialogic_signal")
		new_dialog.connect("timeline_end", self, "_on_Dialog_timeline_end")
		new_dialog.set_pause_mode(2)
		get_tree().paused = true
	else: 
		_spawn_ship()

func _on_Dialog_timeline_end(_timeline_name) -> void:
	get_tree().paused = false


func _on_Dialog_dialogic_signal(value) -> void:
	if value == "Yam":
		GameState.player.ship_type = "Harrier"
	else:
		GameState.player.ship_type = "Falcon"
	
	GameState.player.character = value
	GameState.player.position = Vector2(-400, 0)
	_spawn_ship()

func _get_ship_class_from_name(ship_name):
	if ship_name == "Harrier":
		return load("res://scenes/Ships/Harrier/Harrier.tscn")
	elif ship_name == "Falcon":
		return load("res://scenes/Ships/Falcon/Falcon.tscn")
	return null
	
func _spawn_ship():
	var ship_class = _get_ship_class_from_name(GameState.player.ship_type)
	if ship_class:
		var ship_instance = ship_class.instance()
		pilot.add_child(ship_instance)
		ship_instance.position = GameState.player.position
