extends Control

var root_scene_map = {
	Constants.SceneId.StartMenu: preload("res://scenes/StartMenu/StartMenu.tscn"),
	Constants.SceneId.World3D: preload("res://scenes/World/World.tscn"),
	Constants.SceneId.PlanetSurface: preload("res://scenes/PlanetSurface/PlanetSurface.tscn"),
}

func _input(event) -> void:
	if event.is_action_pressed("ui_cancel"):
		$MainMenu.get_node("MainMenuPanel/ButtonContainer/NewGame").visible = (
			GameState.scene != Constants.SceneId.StartMenu
		)
		
		$MainMenu.visible = !$MainMenu.visible

# Called when the node enters the scene tree for the first time.
func _ready():
	assert(GameState.connect("change_scene_to_file",Callable(self,"_change_scene")) == 0)
	assert(get_tree().get_root().connect("size_changed",Callable(self,"_size_changed_game")) == 0)
	GameState.scene = Constants.SceneId.StartMenu
	_size_changed_game()

func _change_scene(sceneId):

	if(root_scene_map.has(sceneId)):
		var children_to_remove = $Content.get_children()
		$Content.add_child(root_scene_map[sceneId].instantiate())
		for n in children_to_remove:
			$Content.remove_child(n)
			n.queue_free()

func _size_changed_game():
	$MainMenu.get_node("MainMenuPanel/ButtonContainer/FullScreen").text = (
		'Exit' if DisplayServer.window_get_mode(0) == 3 else 'Enter'
	) + ' Fullscreen'

	


func _on_Close_Menu_pressed():
	$MainMenu.visible = false


func _on_Quit_pressed():
	get_tree().quit()


func _on_FullScreen_pressed():
	if DisplayServer.window_get_mode(0) == 3:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	


func _on_NewGame_pressed():
	GameState.scene = Constants.SceneId.World3D
	$MainMenu.visible = false
