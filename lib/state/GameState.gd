extends Node

var scene: Constants.SceneId = Constants.SceneId.StartMenu : set = _set_scene
var player: PlayerState = PlayerState.new()
var save_filename = "user://save_game.save"

signal change_scene_to_file

func _set_scene(next_scene):
	scene = next_scene
	emit_signal("change_scene_to_file", next_scene) 
	
func toJSON():
	return {
		'scene': scene,
		'player': player.toJSON()
	}

func save():
	var save_file = FileAccess.open(save_filename, FileAccess
.WRITE)
	save_file.store_line(JSON.stringify(toJSON()))
	save_file.close()

func load_from_save():
	var save_file = FileAccess.open(save_filename, FileAccess.READ)
	
	var test_json_conv = JSON.new()
	test_json_conv.parse(save_file.get_as_text())
	var save_data = test_json_conv.get_data()
	fromJSON(save_data)

	save_file.close()

func fromJSON(json):
	player.fromJSON(json.player)
	_set_scene(int(json.scene))

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		save()
		get_tree().quit()
