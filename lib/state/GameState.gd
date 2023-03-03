extends Node

var scene = Constants.SceneId.StartMenu : set = _set_scene
var player = PlayerState.new()
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
	var save_file = File.new()
	save_file.open(save_filename, File.WRITE)
	save_file.store_line(JSON.new().stringify(toJSON()))
	save_file.close()

func load_from_save():
	var save_file = File.new()
	if not save_file.file_exists(save_filename):
		return

	save_file.open(save_filename,File.READ)
	
	var test_json_conv = JSON.new()
	test_json_conv.parse(save_file.get_as_text())
	var save_data = test_json_conv.get_data()
	fromJSON(save_data)

	save_file.close()

func fromJSON(json):
	player.fromJSON(json.player)
	_set_scene(int(json.scene))

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_QUIT_REQUEST:
		save()
