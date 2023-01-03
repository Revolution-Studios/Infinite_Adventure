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
		system.id = int(system.id)
		_systems_by_id[system.id] = system
	for conn in data.connections:
		conn[0] = int(conn[0])
		conn[1] = int(conn[1])
	systems_file.close()

func get_by_id(id):
	return _systems_by_id[id]
	
func get_goods_traded(system):
	if !system.has('planets'):
		return []
	var goods = {}
	for planet in system.planets:
		if planet.has('goods_traded'):
			for good in planet.goods_traded:
				goods[good] = true
	return goods.keys()
	
func get_services(system):
	if !system.has('planets'):
		return []
	var goods = {}
	for planet in system.planets:
		if planet.has('services'):
			for good in planet.services:
				goods[good] = true
	return goods.keys()
