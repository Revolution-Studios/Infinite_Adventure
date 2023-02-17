extends StaticBody2D

var planet_data = null
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	if "planet_image" in planet_data:
		var texture = ImageTexture.new()
		var image = Image.new()
		image.load(planet_data.planet_image)
		texture.create_from_image(image)
		$Sprite.texture = texture


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
