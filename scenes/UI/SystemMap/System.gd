extends Node2D

signal selected

var _system_data = null
var selected = false setget _set_selected

var textures = {
	"unexplored": preload("res://scenes/UI/SystemMap/art/unexploredSystemMapNode.png"),
	"unaffiliated": preload("res://scenes/UI/SystemMap/art/unaffiliatedSystemMapNode.png"),
	"friendly": preload("res://scenes/UI/SystemMap/art/friendlySystemMapNode.png"),
	"neutral": preload("res://scenes/UI/SystemMap/art/neutralSystemMapNode.png"),
	"enemy": preload("res://scenes/UI/SystemMap/art/enemySystemMapNode.png"),
	"unaffiliated_current": preload("res://scenes/UI/SystemMap/art/unaffiliated_currentSystemMapNode.png"),
	"friendly_current": preload("res://scenes/UI/SystemMap/art/friendly_currentSystemMapNode.png"),
	"neutral_current": preload("res://scenes/UI/SystemMap/art/neutral_currentSystemMapNode.png"),
	"enemy_current": preload("res://scenes/UI/SystemMap/art/enemy_currentSystemMapNode.png"),
}

func _ready():
	assert($TextureRect.connect("gui_input", self, "_input_event") == 0)
	
func _input_event(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.is_pressed():
		var id = -1
		if _system_data and _system_data.id:
			id = _system_data.id
		emit_signal("selected", id)
		
func _set_selected(val):
	$Selection.visible = val
	selected = val

func fromJSON(system_data):
	$Name.text = system_data.name
	$Name.visible = system_data.relationship != "unexplored"
		
	position = Vector2(system_data.position[0], system_data.position[1])
	_system_data = system_data
	var texture_key = system_data.relationship
	if system_data.id == GameState.player.system_id:
		texture_key += '_current'
	$TextureRect.texture = textures[texture_key]
