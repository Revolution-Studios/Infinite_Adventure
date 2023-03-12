extends Node

var _audio: AudioStreamPlayer = null

var _JumpBegin: AudioStream = preload("res://art/SoundEffects/jump/jump_start.wav")
var _JumpComplete: AudioStream = preload("res://art/SoundEffects/jump/mixkit-bomb-explosion-in-battle-2800.wav")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func play(s: Constants.Sound) -> AudioStreamPlayer:
	if _audio != null:
		_finished()
	_audio = AudioStreamPlayer.new()
	if s == Constants.Sound.JumpBegin:
		_audio.stream = _JumpBegin
	elif s == Constants.Sound.JumpComplete:
		_audio.stream = _JumpComplete

	get_tree().get_root().add_child(_audio)
	_audio.play()
	_audio.finished.connect(_finished)
	return _audio

func _finished():
	get_tree().get_root().remove_child(_audio)
	_audio = null
