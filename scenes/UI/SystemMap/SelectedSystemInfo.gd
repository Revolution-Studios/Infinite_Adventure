extends VBoxContainer

export var label = 'System Name' setget _set_label
export var values: PoolStringArray = ['Solaria'] setget _set_values

func _ready():
	_render()
	
func _render():
	$Label.text = label
	$Value.text = values.join('\n')

func _set_label(val):
	label = val
	_render()

func _set_values(val):
	values = val
	_render()
