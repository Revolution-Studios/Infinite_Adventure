extends Control

var systems = null

var root_scene_map = {
	Constants.SceneId.StartMenu: preload("res://scenes/StartMenu/StartMenu.tscn"),
	Constants.SceneId.World: preload("res://scenes/World/World.tscn"),
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
	systems = load("res://lib/data/Systems.gd").new()
	assert(GameState.connect("change_scene",self, "_change_scene") == 0)
	assert(get_tree().get_root().connect("size_changed", self, "_size_changed_game") == 0)
	GameState.load_from_save()
	_size_changed_game()

func _change_scene(sceneId):
	if(root_scene_map.has(sceneId)):

		var children_to_remove = $Content.get_children()
		var new_scene = root_scene_map[sceneId].instance();
		if sceneId == Constants.SceneId.World:
			new_scene.systems = systems
		$Content.add_child(new_scene)
		for n in children_to_remove:
			$Content.remove_child(n)
			n.queue_free()
			
		GameState.player.selection = null

func _size_changed_game():
	$MainMenu.get_node("MainMenuPanel/ButtonContainer/FullScreen").text = (
		'Exit' if OS.window_fullscreen else 'Enter'
	) + ' Fullscreen'

	


func _on_Close_Menu_pressed():
	$MainMenu.visible = false


func _on_Quit_pressed():
	GameState.save()
	get_tree().notification(MainLoop.NOTIFICATION_WM_QUIT_REQUEST)


func _on_FullScreen_pressed():
	OS.window_fullscreen = !OS.window_fullscreen
	


func _on_NewGame_pressed():
	GameState.player.queue_free()
	GameState.player = PlayerState.new()
	GameState.scene = Constants.SceneId.World
	$MainMenu.visible = false
