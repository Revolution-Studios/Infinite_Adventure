extends StaticBody2D

var planet_data = null



func _ready():
	if "planet_image" in planet_data:
		var image = Image.new()
		image.load(planet_data.planet_image)
		$Sprite2D.texture = ImageTexture.create_from_image(image)
