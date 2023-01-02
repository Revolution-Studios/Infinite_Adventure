extends Node

var data = null;
var _systems_by_id = {}

func _init():
	var systems_filename = "res://lib/data/systems.json";
	var systems_file = File.new()
	if not systems_file.file_exists(systems_filename):
		return

	systems_file.open(systems_filename, File.READ)
	
	data = parse_json(systems_file.get_as_text())
	for system in data.systems:
		_systems_by_id[str(system.id)] = system
	systems_file.close()

func getById(id):
	return _systems_by_id[str(id)]
