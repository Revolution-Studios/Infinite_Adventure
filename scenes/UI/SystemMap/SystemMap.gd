extends ReferenceRect

const MAX_ZOOM_LEVEL = 0.5
const MIN_ZOOM_LEVEL = 4.0
const ZOOM_INCREMENT = 0.05
const TOGGLE_ANIMATION_TIME = 0.2

var systems = null : set = _set_systems
var shown = false : set = _set_shown
var SystemClass = load("res://scenes/UI/SystemMap/System.tscn")
var _drag = false
var _editing_nav = false
var _current_zoom_level = 1
var _drag_start_position = Vector2.ZERO
var _mouse_over_map = false
var _selected_system_id = null
var _system_nodes = {}
var _system_edges = {}
@onready var center_container = $Row.get_node("Center")
@onready var map_control = center_container.get_node("MarginContainer/Control")
@onready var system_container = map_control.get_node("SystemContainer")
@onready var system_info = $Row.get_node("Left/MarginContainer/ScrollContainer/VBoxContainer")
@onready var button_container = $Row.get_node("Right/MarginContainer/VBoxContainer")
@onready var clear_route_button = button_container.get_node("ClearRouteButton")

func _ready():
	assert(center_container.connect("resized",Callable(self,"_center")) == 0)
	assert($CloseButton.connect("pressed",Callable(self,"_close")) == 0)
	assert(button_container.get_node("CenterButton").connect("pressed",Callable(self,"_center")) == 0)
	assert(button_container.get_node("CloseMapButton").connect("pressed",Callable(self,"_close")) == 0)
	assert(clear_route_button.connect("pressed",Callable(self,"_clear_route")) == 0)
	assert(map_control.connect("mouse_entered",Callable(self,"_mouse_entered_map")) == 0)
	assert(map_control.connect("mouse_exited",Callable(self,"_mouse_exited_map")) == 0)
	assert(GameState.player.connect("system_id_changed",Callable(self,"_system_id_changed")) == 0)
	self.modulate.a = 0;

func _set_shown(val):
	print("set shown ", val)
	_center()
	var final_opacity = 0
	var parent_height = get_viewport().get_visible_rect().size.y
	var final_pos_y = parent_height - size.y
	if val:
		final_opacity = 1
		final_pos_y = parent_height - size.y - 50
	else:
		final_opacity = 0
		final_pos_y = parent_height - size.y + 50
		
	create_tween().tween_property(self, "modulate:a", final_opacity, TOGGLE_ANIMATION_TIME).set_trans(Tween.TRANS_LINEAR);
	create_tween().tween_property(self, "position:y", final_pos_y, TOGGLE_ANIMATION_TIME).set_trans(Tween.TRANS_LINEAR);
	shown = val
	_system_selected(GameState.player.system_id)

func _mouse_entered_map():
	_mouse_over_map = true
	
func _mouse_exited_map():
	_mouse_over_map = false

func _close():
	_set_shown(false)
	
func _center():
	var current_system = systems.get_by_id(GameState.player.system_id)
	system_container.position = Vector2(current_system.position[0], current_system.position[1]) + map_control.size / 2
	system_container.scale = Vector2(1, 1)

func _clear_route():
	_update_nav_route(GameState.player.system_id)
	
func _update_zoom(incr, mouse_pos):
	var old_zoom = _current_zoom_level
	_current_zoom_level += incr
	if _current_zoom_level < MAX_ZOOM_LEVEL:
		_current_zoom_level = MAX_ZOOM_LEVEL
	elif _current_zoom_level > MIN_ZOOM_LEVEL:
		_current_zoom_level = MIN_ZOOM_LEVEL
	if old_zoom == _current_zoom_level:
		return
	
	var map_center = map_control.global_position +  map_control.size / 2
	var mouse_offset = mouse_pos - map_center
	var ratio = 1 - _current_zoom_level/old_zoom
	system_container.position += mouse_offset * ratio
	
	system_container.scale = Vector2(_current_zoom_level, _current_zoom_level)

func _system_id_changed(_current_system_id, _previous_system_id):
	call_deferred("_render_systems")

func _render_systems():
	for child in system_container.get_children():
		system_container.remove_child(child)
		child.queue_free()
	_system_nodes = {}
	_system_edges = {}

	if !systems:
		return

	# Add map route lines
	for connection in systems.data.connections:
		var line = Line2D.new();
		line.default_color = Color("979797")
		line.width = 2
		line.end_cap_mode = Line2D.LINE_CAP_NONE
		var system1 = systems.get_by_id(connection[0])
		var system2 = systems.get_by_id(connection[1])
		var point1 = Vector2(system1.position[0], system1.position[1])
		var point2 = Vector2(system2.position[0], system2.position[1])

		# We want to shorten each line on both ends by a fixed amount
		# so that it doesn't overlap the node
		var direction = (point1 - point2).normalized()
		line.add_point(point1 - direction * 11)
		line.add_point(point2 + direction * 11)
		system_container.add_child(line)
		var id1 = connection[0]
		var id2 = connection[1]
		if !_system_edges.has(id1):
			_system_edges[id1] = {}
		if !_system_edges.has(id2):
			_system_edges[id2] = {}

		_system_edges[id1][id2] = line
		_system_edges[id2][id1] = line

	# Color the route lines that are part of the current nav route
	var last_id = GameState.player.system_id
	for path_id in GameState.player.nav_route:
		_system_edges[last_id][path_id].default_color = Color("10C800")
		last_id = path_id

	# Add map systems
	for systemData in systems.data.systems:
		var system = SystemClass.instantiate()
		print(system)
		system.fromJSON(systemData)
		system_container.add_child(system)
		system.connect("system_selected",Callable(self,"_system_selected"))
		_system_nodes[systemData.id] = system

func _set_systems(val):
	systems = val
	_render_systems()
	_center()

func _system_selected(id):
	var data = systems.get_by_id(id)
	if data == null:
		return
	if id != _selected_system_id:
		if _selected_system_id != null:
			_system_nodes[_selected_system_id].selected = false
		_system_nodes[id].selected = true
		_selected_system_id = id
		if data.relationship != "unexplored":
			var goods = systems.get_goods_traded(data)
			var services = systems.get_services(data)
			system_info.get_node("Name").values = PackedStringArray([data.name])
			system_info.get_node("Government").values = PackedStringArray([data.government])
			system_info.get_node("LegalStatus").values = PackedStringArray([data.relationship])
			system_info.get_node("GoodsTraded").values = goods if goods.size() else PackedStringArray(["none"])
			system_info.get_node("Services").values = services if services.size() else PackedStringArray(["none"])
		else:
			system_info.get_node("Name").values = PackedStringArray(["unknown"])
			system_info.get_node("Government").values = PackedStringArray(["unknown"])
			system_info.get_node("LegalStatus").values = PackedStringArray(["unknown"])
			system_info.get_node("GoodsTraded").values = PackedStringArray(["unknown"])
			system_info.get_node("Services").values = PackedStringArray(["unknown"])

	if _editing_nav:
		_update_nav_route(id)

func _update_nav_route(id):
	var path = [GameState.player.system_id]
	path.append_array(GameState.player.nav_route)
	
	for i in range(1, path.size()):
		var last_id = path[i-1]
		_system_edges[last_id][path[i]].default_color = Color("979797")
	
	var path_resolved = [GameState.player.system_id]
	if id != GameState.player.system_id:
		for i in range(1, path.size()):
			var last_id = path[i-1]
			var nav_id = path[i]
			if !_system_edges[last_id].has(nav_id):
				break
			if nav_id == id:
				break
			path_resolved.push_back(nav_id)

	var last_id = path_resolved.back()
	if path_resolved.size() == 2 and !_system_edges[last_id].has(id) and _system_edges[path_resolved.front()].has(id):
		path_resolved.pop_back()
		last_id = path_resolved.back()
	if _system_edges[last_id].has(id):
		path_resolved.push_back(id)
		
	path_resolved.pop_front()
	
	last_id = GameState.player.system_id
	for path_id in path_resolved:
		_system_edges[last_id][path_id].default_color = Color("10C800")
		last_id = path_id
	
	GameState.player.nav_route = path_resolved
	clear_route_button.disabled = (path_resolved.size() == 0)

func _unhandled_input(event):
	if event.is_action_pressed("system_map_cam_drag"):
		if _mouse_over_map:
			_drag = true
			_drag_start_position = (event.position - system_container.position)
	elif event.is_action_released("system_map_cam_drag"):
		_drag = false
	elif event is InputEventMouseMotion && _drag:
		system_container.position = event.position - _drag_start_position
	elif event.is_action("cam_zoom_in"):
		if _mouse_over_map:
			_update_zoom(ZOOM_INCREMENT, event.position)
	elif event.is_action("cam_zoom_out"):
		if _mouse_over_map:
			_update_zoom(-1 * ZOOM_INCREMENT, event.position)
	elif event.is_action_pressed("nav_multi"):
		_editing_nav = true
	elif event.is_action_released("nav_multi"):
		_editing_nav = false
	elif event is InputEventMagnifyGesture:
		if _mouse_over_map:
			_update_zoom(event.factor - 1, event.position)
	
