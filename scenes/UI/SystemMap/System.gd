extends Node2D

signal selected

var _system_data = null
var selected = false setget _set_selected

func _ready():
	$TextureRect.connect("gui_input", self, "_input_event")
#	$SelectionArea.connect("input_event", self, "_input_event")
	
func _input_event(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.is_pressed():
		var id = -1
		if _system_data and _system_data.id:
			id = _system_data.id
		emit_signal("selected", id)
		
func _set_selected(val):
	print("set selected ", val)
	$Selection.visible = val
	selected = val

func fromJSON(system_data):
	$Name.text = system_data.name
	$Name.visible = system_data.relationship != "unexplored"
		
	position = Vector2(system_data.position[0], system_data.position[1])
	_system_data = system_data
#	$Node.animation = systemData.relationship + (
#		'_current' if GameState.player.system_id == systemData.id
#		else ''
#	)
