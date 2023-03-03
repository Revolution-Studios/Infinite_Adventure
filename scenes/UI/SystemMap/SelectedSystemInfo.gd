extends VBoxContainer

@export var label = 'System Name' : set = _set_label
@export var values: PackedStringArray = ['Solaria'] : set = _set_values

func _ready():
	_render()
	
func _render():
	$Label.text = label
	$Value.text = '\n'.join(values)

func _set_label(val):
	label = val
	_render()

func _set_values(val):
	values = val
	_render()
