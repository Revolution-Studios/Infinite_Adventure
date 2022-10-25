extends ParallaxBackground


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():

	var my_material = load("scenes/Background/Background.tres")
	$ShaderToImage.generate_image(my_material, Vector2(1920, 1080)) # Start generating the image
	yield($ShaderToImage, "generated") # Wait the image to be rendered, it take 3 frams
	var my_image = $ShaderToImage.get_image()
	var tex = ImageTexture.new()
	tex.create_from_image(my_image)

	$StarLayer/TextureRect.texture = tex



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
