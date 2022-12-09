extends Control

onready var start_game = $VBoxContainer/Start

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_game.grab_focus()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_Start_pressed() -> void:
	GameState.scene = Constants.SceneId.World


func _on_Quit_pressed() -> void:
	get_tree().quit()
