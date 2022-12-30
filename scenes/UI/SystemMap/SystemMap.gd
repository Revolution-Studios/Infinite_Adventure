extends Panel

var systems = null setget _set_systems 
var scale = 1
var SystemClass = load("res://scenes/UI/SystemMap/System.tscn")
var _drag = false
var _current_zoom_level = 1
var _drag_start_position = Vector2.ZERO
var system_container = $MapArea.get_node("SystemContainer")

func _ready():
	system_container.position = rect_size / 2;
	assert($CloseButton.connect("pressed", self, "_close") == 0)
	
func _close():
	visible = false

func _set_systems(val):
	systems = val
	if !systems:
		return
	for systemData in systems.data.systems:
		var system = SystemClass.instance()
		system.fromJSON(systemData)
		system_container.add_child(system)

func _input(event):
	if event.is_action_pressed("system_map_cam_drag"):
		_drag = true
		_drag_start_position = event.position - system_container.position
	elif event.is_action_released("system_map_cam_drag"):
		_drag = false
	elif event is InputEventMouseMotion && _drag:
		system_container.position = (event.position - _drag_start_position) * _current_zoom_level
	
