extends Control

onready var Surface_start = $CanvasLayer/PlanetPanel/surfacelocations/Bar

func _ready() -> void:
	Surface_start.grab_focus()

func _physics_process(delta):
	if Input.is_action_just_pressed("ui_select"):
		if $CanvasLayer/PlanetPanel/surfacelocations/Bar.has_focus():
			$CanvasLayer/PlanetPanel/surfacelocations/Bar.release_focus()
		else:
			$CanvasLayer/PlanetPanel/surfacelocations/Bar.grab_focus()


func _on_Leave_pressed():
	GameState.scene = Constants.SceneId.World

func _input(event):
	if event.is_action_pressed("take_off"):
		GameState.scene = Constants.SceneId.World
