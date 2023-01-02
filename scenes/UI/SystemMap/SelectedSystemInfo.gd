extends VBoxContainer

export var label = 'System Name'
export var values: PoolStringArray = ['Solaria']

func _ready():
	$Label.text = label
	$Value.text = values.join('\n')
