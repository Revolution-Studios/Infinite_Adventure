extends ReferenceRect

const MAX_ZOOM_LEVEL = 0.5
const MIN_ZOOM_LEVEL = 4.0
const ZOOM_INCREMENT = 0.05
const TOGGLE_ANIMATION_TIME = 0.2

var systems = null setget _set_systems 
var shown = false setget _set_shown 
var scale = 1
var SystemClass = load("res://scenes/UI/SystemMap/System.tscn")
var _drag = false
var _current_zoom_level = 1
var _drag_start_position = Vector2.ZERO
var _mouse_over_map = false
var _selected_system_id = null
var _system_nodes = {}
onready var center_container = $Row.get_node("Center")
onready var map_control = center_container.get_node("MarginContainer/Control")
onready var system_container = map_control.get_node("SystemContainer")
onready var system_info = $Row.get_node("Left/MarginContainer/ScrollContainer/VBoxContainer")

func _ready():
	assert(center_container.connect("resized", self, "_map_area_resized") == 0)
	assert($CloseButton.connect("pressed", self, "_close") == 0)
#	assert(map_control.connect("mouse_entered", self, "_mouse_entered_map") == 0)
#	assert(map_control.connect("mouse_exited", self, "_mouse_exited_map") == 0)
	_map_area_resized()
	self.modulate.a = 0;
#	assert($Buttons.get_node("CenterButton").connect("pressed", self, "_center") == 0)

func _set_shown(val):
	var final_opacity = 0
	var parent_height = get_viewport().get_visible_rect().size.y
	var final_pos_y = parent_height - rect_size.y
	if val:
		final_opacity = 1
		final_pos_y = parent_height - rect_size.y - 50
	else:
		final_opacity = 0
		final_pos_y = parent_height - rect_size.y + 50
	
	$Tween.interpolate_property(
		self,
		"modulate:a",
		modulate.a,
		final_opacity,
		TOGGLE_ANIMATION_TIME,
		Tween.TRANS_LINEAR
	)
	$Tween.interpolate_property(
		self,
		"rect_position:y",
		rect_position.y,
		final_pos_y,
		TOGGLE_ANIMATION_TIME,
		Tween.TRANS_LINEAR
	)
	$Tween.start()
	shown = val
	_system_selected(GameState.player.system_id)

func _mouse_entered_map():
	_mouse_over_map = true
	
func _mouse_exited_map():
	_mouse_over_map = false
	
func _map_area_resized():
	system_container.position = center_container.rect_size / 2;
	
func _close():
	_set_shown(false)
	
func _center(pos: Vector2):
	var current_system = systems.getById(GameState.player.system_id)
	system_container.position = Vector2(current_system.position[0], current_system.position[1])
	
func _update_zoom(incr, zoom_anchor):
	var old_zoom = _current_zoom_level
	_current_zoom_level += incr
	if _current_zoom_level < MAX_ZOOM_LEVEL:
		_current_zoom_level = MAX_ZOOM_LEVEL
	elif _current_zoom_level > MIN_ZOOM_LEVEL:
		_current_zoom_level = MIN_ZOOM_LEVEL
	if old_zoom == _current_zoom_level:
		return
		
	var zoom_center = zoom_anchor - system_container.position
	var ratio = 1-_current_zoom_level/old_zoom
	system_container.position += zoom_center*ratio
	
	system_container.scale = Vector2(_current_zoom_level, _current_zoom_level)
	

func _set_systems(val):
	systems = val
	for child in system_container.get_children():
		remove_child(child)
		child.queue_free()
	_system_nodes = {}

	if !systems:
		return
	for connection in systems.data.connections:
		var line = Line2D.new();
		line.width = 2
		line.end_cap_mode = Line2D.LINE_CAP_NONE
		var system1 = systems.getById(connection[0])
		var system2 = systems.getById(connection[1])
		var point1 = Vector2(system1.position[0], system1.position[1])
		var point2 = Vector2(system2.position[0], system2.position[1])
		
		# We want to shorten each line on both ends by a fixed amount
		# so that it doesn't overlap the node
		var direction = (point1 - point2).normalized()
		line.add_point(point1 - direction * 11)
		line.add_point(point2 + direction * 11)
		system_container.add_child(line)
	for systemData in systems.data.systems:
		var system = SystemClass.instance()
		system.fromJSON(systemData)
		system_container.add_child(system)
		system.connect("selected", self, "_system_selected")
		_system_nodes[str(systemData.id)] = system
	
func _system_selected(id):
	if id == _selected_system_id:
		return
	if _selected_system_id != null:
		_system_nodes[str(_selected_system_id)].selected = false
	_system_nodes[str(id)].selected = true
	_selected_system_id = id
	var data = systems.getById(_selected_system_id)
	print("data ", data)
	if data:
		if data.relationship != "unexplored":
			var goods = systems.getGoodsTraded(data)
			var services = systems.getServices(data)
			system_info.get_node("Name").values = PoolStringArray([data.name])
			system_info.get_node("Government").values = PoolStringArray([data.government])
			system_info.get_node("LegalStatus").values = PoolStringArray([data.relationship])
			system_info.get_node("GoodsTraded").values = goods if goods.size() else PoolStringArray(["none"])
			system_info.get_node("Services").values = services if services.size() else PoolStringArray(["none"])
		else:
			system_info.get_node("Name").values = PoolStringArray(["unknown"])
			system_info.get_node("Government").values = PoolStringArray(["unknown"])
			system_info.get_node("LegalStatus").values = PoolStringArray(["unknown"])
			system_info.get_node("GoodsTraded").values = PoolStringArray(["unknown"])
			system_info.get_node("Services").values = PoolStringArray(["unknown"])

func _input(event):
	if event.is_action_pressed("system_map_cam_drag"):
		_drag = true
		_drag_start_position = event.position - system_container.position
	elif event.is_action_released("system_map_cam_drag"):
		print("released")
		_drag = false
	elif event is InputEventMouseMotion && _drag:
		system_container.position = (event.position - _drag_start_position) * _current_zoom_level
	elif event.is_action("cam_zoom_in"):
		if _mouse_over_map:
			_update_zoom(ZOOM_INCREMENT, event.position)
			print("zoom in")
	elif event.is_action("cam_zoom_out"):
		if _mouse_over_map:
			_update_zoom(-1 * ZOOM_INCREMENT, event.position)
			print("zoom out")
	
