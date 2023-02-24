extends Control

onready var Surface_start = $CanvasLayer/PlanetPanel/surfacelocations/Bar
var planet_data = null

func _ready() -> void:
	Surface_start.grab_focus()
	$CanvasLayer/PlanetPanel/RichTextLabel.text = planet_data.name
	if "background_image" in planet_data:
		var texture = ImageTexture.new()
		var image = Image.new()
		image.load(planet_data.background_image)
		texture.create_from_image(image)
		$Backroundimage.texture = texture

func _on_Leave_pressed():
	GameState.scene = Constants.SceneId.World
	GameState.player.planet_id = null
	

func _input(event):
	if event.is_action_pressed("ui_select"):
		if $CanvasLayer/PlanetPanel/surfacelocations/Bar.has_focus():
			$CanvasLayer/PlanetPanel/surfacelocations/Bar.release_focus()
		else:
			$CanvasLayer/PlanetPanel/surfacelocations/Bar.grab_focus()
	if event.is_action_pressed("take_off"):
		GameState.scene = Constants.SceneId.World
		GameState.player.planet_id = null

func _on_Bar_pressed():
	$CanvasLayer/PlanetPanel/RichTextLabel.text = planet_data.name
	if "bar_image" in planet_data:
		var texture = ImageTexture.new()
		var image = Image.new()
		image.load(planet_data.background_image)
		texture.create_from_image(image)
		$Backroundimage.texture = texture

func _on_Missions_pressed():
	$CanvasLayer/PlanetPanel/RichTextLabel.text = planet_data.name
	if "jobboard_image" in planet_data:
		var texture = ImageTexture.new()
		var image = Image.new()
		image.load(planet_data.background_image)
		texture.create_from_image(image)
		$Backroundimage.texture = texture


func _on_Trade_Center_pressed():
	$CanvasLayer/PlanetPanel/RichTextLabel.text = planet_data.name
	if "storefront_image" in planet_data:
		var texture = ImageTexture.new()
		var image = Image.new()
		image.load(planet_data.background_image)
		texture.create_from_image(image)
		$Backroundimage.texture = texture


func _on_Outfitter_pressed():
	$CanvasLayer/PlanetPanel/RichTextLabel.text = planet_data.name
	if "shipparts_image" in planet_data:
		var texture = ImageTexture.new()
		var image = Image.new()
		image.load(planet_data.background_image)
		texture.create_from_image(image)
		$Backroundimage.texture = texture


func _on_Refuel_pressed():
	$CanvasLayer/PlanetPanel/RichTextLabel.text = planet_data.name
	if "background_image" in planet_data:
		var texture = ImageTexture.new()
		var image = Image.new()
		image.load(planet_data.background_image)
		texture.create_from_image(image)
		$Backroundimage.texture = texture
