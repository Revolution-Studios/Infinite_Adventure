extends Control

onready var Surface_start = $CanvasLayer/PlanetPanel/surfacelocations/Bar
var planet_data = null

func _ready() -> void:
	Surface_start.grab_focus()
	$CanvasLayer/PlanetPanel/RichTextLabel.text = planet_data.shipyard_description
	if "shipyard_image" in planet_data:
		var texture = ImageTexture.new()
		var image = Image.new()
		image.load(planet_data.shipyard_image)
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
	$CanvasLayer/PlanetPanel/RichTextLabel.text = planet_data.bar_description
	if "bar_image" in planet_data:
		var texture = ImageTexture.new()
		var image = Image.new()
		image.load(planet_data.bar_image)
		texture.create_from_image(image)
		$Backroundimage.texture = texture

func _on_Missions_pressed():
	$CanvasLayer/PlanetPanel/RichTextLabel.text = planet_data.missions_description
	if "missions_image" in planet_data:
		var texture = ImageTexture.new()
		var image = Image.new()
		image.load(planet_data.missions_image)
		texture.create_from_image(image)
		$Backroundimage.texture = texture


func _on_Trade_Center_pressed():
	$CanvasLayer/PlanetPanel/RichTextLabel.text = planet_data.trade_center_description
	if "trade_center_image" in planet_data:
		var texture = ImageTexture.new()
		var image = Image.new()
		image.load(planet_data.trade_center_image)
		texture.create_from_image(image)
		$Backroundimage.texture = texture


func _on_Outfitter_pressed():
	$CanvasLayer/PlanetPanel/RichTextLabel.text = planet_data.outfitter_description
	if "outfitter_image" in planet_data:
		var texture = ImageTexture.new()
		var image = Image.new()
		image.load(planet_data.outfitter_image)
		texture.create_from_image(image)
		$Backroundimage.texture = texture


func _on_Refuel_pressed():
	$CanvasLayer/PlanetPanel/RichTextLabel.text = planet_data.shipyard_description
	if "shipyard_image" in planet_data:
		var texture = ImageTexture.new()
		var image = Image.new()
		image.load(planet_data.shipyard_image)
		texture.create_from_image(image)
		$Backroundimage.texture = texture
