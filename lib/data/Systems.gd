extends Node

var data = null;

func _init():
	var systems_filename = "res://lib/data/systems.json";
	var systems_file = File.new()
	if not systems_file.file_exists(systems_filename):
		return

	systems_file.open(systems_filename, File.READ)
	
	data = parse_json(systems_file.get_as_text())
	systems_file.close()
