extends PanelContainer

const TOGGLE_ANIMATION_TIME = 0.5

var _message_visible_timer: Timer = Timer.new()

@onready var _latest_message_text = $MarginContainer/Text


# Called when the node enters the scene tree for the first time.
func _ready():
	modulate.a = 0
	_message_visible_timer.one_shot = true
	_message_visible_timer.timeout.connect(_message_visible_timeout)
	add_child(_message_visible_timer)
	GameState.connect("new_message", _new_message)

func _new_message(message: String):
	_latest_message_text.clear()
	_latest_message_text.add_text(message)
	SoundEffect.play(Constants.Sound.Message)
	_show()
	
func _show():
	_message_visible_timer.start(5)
	create_tween().tween_property(self, "modulate:a", 1, TOGGLE_ANIMATION_TIME).set_trans(Tween.TRANS_LINEAR);

func _message_visible_timeout():
	create_tween().tween_property(self, "modulate:a", 0, TOGGLE_ANIMATION_TIME).set_trans(Tween.TRANS_LINEAR);
