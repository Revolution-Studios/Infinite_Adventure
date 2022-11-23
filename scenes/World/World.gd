extends Node2D

const harrier = preload("res://scenes/Player/Player_harrier/Player_harrier.tscn")
const falcon = preload("res://scenes/Player/Player_falcon/Player_falcon.tscn")
var player_ship = null


func _ready() -> void:
	get_tree().paused = true


func _input(event) -> void:
	if event.is_action_pressed("Toggle_full_screen"): 
		OS.window_fullscreen = !OS.window_fullscreen


func _on_Dialog_timeline_end(_timeline_name) -> void:
	get_tree().paused = !get_tree().paused


func _on_Dialog_dialogic_signal(value) -> void:
	if value == "Amadou":
		player_ship = harrier.instance()
	else:
		player_ship = falcon.instance()

	player_ship.global_position = Vector2(308,374)
	add_child(player_ship) 
