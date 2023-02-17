extends StaticBody2D

var planet_data = null



func _ready():
	if "planet_image" in planet_data:
		var texture = ImageTexture.new()
		var image = Image.new()
		image.load(planet_data.planet_image)
		texture.create_from_image(image)
		$Sprite.texture = texture
