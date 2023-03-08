extends StaticBody2D

var planet_data = null



func _ready():
	if "planet_image" in planet_data:
		$Sprite2D.texture = load(planet_data.planet_image)
