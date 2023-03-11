extends CanvasLayer

var blur = Vector2(0, 0) : set = _set_blur;

func _ready():
	process_mode = Node.PROCESS_MODE_DISABLED

func _set_blur(b: Vector2):
	blur = b
	if process_mode == Node.PROCESS_MODE_DISABLED and b.length():
		process_mode = Node.PROCESS_MODE_INHERIT


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print("blur process")
	$ColorRect.material.set_shader_parameter('blur', blur)
