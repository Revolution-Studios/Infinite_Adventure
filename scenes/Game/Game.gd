extends Control

var root_scene_map = {
	Constants.SceneId.StartMenu: preload("res://scenes/StartMenu/StartMenu.tscn"),
	Constants.SceneId.World: preload("res://scenes/World/World.tscn"),
}

func _input(event) -> void:
	if event.is_action_pressed("ui_cancel"):
		$MainMenu.get_node("MainMenuPanel/ButtonContainer/NewGame").visible = (
			GameState.scene != Constants.SceneId.StartMenu
		)
		
		$MainMenu.visible = !$MainMenu.visible

# Called when the node enters the scene tree for the first time.
func _ready():
	GameState.connect("change_scene",self, "_change_scene")
	get_tree().get_root().connect("size_changed", self, "_size_changed")
	GameState.scene = Constants.SceneId.StartMenu
	_size_changed()

func _change_scene(sceneId):
	print('_change_scene', root_scene_map, sceneId, root_scene_map.has(sceneId))
	if(root_scene_map.has(sceneId)):
		var children_to_remove = $Content.get_children()
		$Content.add_child(root_scene_map[sceneId].instance())
		for n in children_to_remove:
			$Content.remove_child(n)
			n.queue_free()

func _size_changed():
	$MainMenu.get_node("MainMenuPanel/ButtonContainer/FullScreen").text = (
		'Exit' if OS.window_fullscreen else 'Enter'
	) + ' Fullscreen'

	


func _on_Close_Menu_pressed():
	$MainMenu.visible = false


func _on_Quit_pressed():
	get_tree().quit()


func _on_FullScreen_pressed():
	OS.window_fullscreen = !OS.window_fullscreen
	


func _on_NewGame_pressed():
	GameState.scene = Constants.SceneId.World
	$MainMenu.visible = false
