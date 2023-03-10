extends Control

var systems = null
@onready var Menu = $MainMenu/MainMenuPanel/ButtonContainer/NewGame

var root_scene_map = {
	Constants.SceneId.StartMenu: preload("res://scenes/StartMenu/StartMenu.tscn"),
	Constants.SceneId.World: preload("res://scenes/World/World.tscn"),
	Constants.SceneId.PlanetSurface: preload("res://scenes/PlanetSurface/PlanetSurface.tscn"),
}

func _unhandled_input(event) -> void:
	if event.is_action_pressed("ui_cancel"):
		$MainMenu.get_node("MainMenuPanel/ButtonContainer/NewGame").visible = (
			GameState.scene != Constants.SceneId.StartMenu
		)

		$MainMenu.visible = !$MainMenu.visible
		Menu.grab_focus()

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().set_auto_accept_quit(false)
	systems = load("res://lib/data/Systems.gd").new()
	assert(GameState.connect("change_scene_to_file",Callable(self,"_change_scene")) == 0)
	assert(get_tree().get_root().connect("size_changed",Callable(self,"_size_changed_game")) == 0)
	GameState.load_from_save()
	_size_changed_game()

func _change_scene(sceneId):
	if(root_scene_map.has(sceneId)):
		print("StartMenu=", Constants.SceneId.StartMenu)
		print("World=", Constants.SceneId.World)
		print("PlanetSurface=", Constants.SceneId.PlanetSurface)
		print("change_scene", sceneId)
		var children_to_remove = $Content.get_children()
		var new_scene = root_scene_map[sceneId].instantiate();
		if sceneId == Constants.SceneId.World:
			new_scene.systems = systems
		elif sceneId == Constants.SceneId.PlanetSurface:
			var current_system = systems.get_by_id(GameState.player.system_id)
			for planet in current_system.planets:
				if planet.id == GameState.player.planet_id:
					new_scene.planet_data = planet
		$Content.add_child(new_scene)
		for n in children_to_remove:
			$Content.remove_child(n)
			n.queue_free()

		GameState.player.selection = null

func _size_changed_game():
	$MainMenu.get_node("MainMenuPanel/ButtonContainer/FullScreen").text = (
		'Exit' if ((get_window().mode == Window.MODE_EXCLUSIVE_FULLSCREEN) or (get_window().mode == Window.MODE_FULLSCREEN)) else 'Enter'
	) + ' Fullscreen'

func _on_Close_Menu_pressed():
	$MainMenu.visible = false

func _on_Quit_pressed():
	GameState.save()
	get_tree().get_root().propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)


func _on_FullScreen_pressed():
	get_window().mode = Window.MODE_EXCLUSIVE_FULLSCREEN if (!((get_window().mode == Window.MODE_EXCLUSIVE_FULLSCREEN) or (get_window().mode == Window.MODE_FULLSCREEN))) else Window.MODE_WINDOWED

func _on_NewGame_pressed():
	GameState.player.queue_free()
	GameState.player = PlayerState.new()
	GameState.scene = Constants.SceneId.World
	$MainMenu.visible = false
