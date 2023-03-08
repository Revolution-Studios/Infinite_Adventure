extends Control

@onready var start_game = $VBoxContainer/Start

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_game.grab_focus()
	
func _input(event):
	if event.is_action_pressed("ui_select"):
		if $VBoxContainer/Start.has_focus():
			$VBoxContainer/Start.release_focus()
		else:
			$VBoxContainer/Start.grab_focus()

func _on_Start_pressed() -> void:
	GameState.player.queue_free()
	GameState.player = PlayerState.new()
	GameState.scene = Constants.SceneId.World


func _on_Quit_pressed() -> void:
	get_tree().get_root().propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
