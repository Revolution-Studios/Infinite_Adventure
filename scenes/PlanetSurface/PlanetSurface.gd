extends Control

@onready var Surface_start = $CanvasLayer/PlanetPanel/surfacelocations/Bar

func _ready() -> void:
	var planet_data = GameState.player.current_planet()
	if planet_data == null:
		return
	Surface_start.grab_focus()
	if "shipyard_description" in planet_data:
			$CanvasLayer/PlanetPanel/RichTextLabel.text = planet_data.shipyard_description
	if "shipyard_image" in planet_data:
		$Backroundimage.texture = load(planet_data.shipyard_image)

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
		print("take off")
		get_viewport().set_input_as_handled()
		GameState.scene = Constants.SceneId.World
		GameState.player.planet_id = null

func _on_Bar_pressed():
	var planet_data = GameState.player.current_planet()
	if planet_data == null:
		return
	if "bar_description" in planet_data:
		$CanvasLayer/PlanetPanel/RichTextLabel.text = planet_data.bar_description
	if "bar_image" in planet_data:
		$Backroundimage.texture = load(planet_data.bar_image)

func _on_Missions_pressed():
	var planet_data = GameState.player.current_planet()
	if planet_data == null:
		return
	if "missions_description" in planet_data:
		$CanvasLayer/PlanetPanel/RichTextLabel.text = planet_data.missions_description
	if "missions_image" in planet_data:
		$Backroundimage.texture = load(planet_data.missions_image)


func _on_Trade_Center_pressed():
	var planet_data = GameState.player.current_planet()
	if planet_data == null:
		return
	if "trade_center_description" in planet_data:
		$CanvasLayer/PlanetPanel/RichTextLabel.text = planet_data.trade_center_description
	if "trade_center_image" in planet_data:
		$Backroundimage.texture = load(planet_data.trade_center_image)


func _on_Outfitter_pressed():
	var planet_data = GameState.player.current_planet()
	if planet_data == null:
		return
	if "outfitter_description" in planet_data:
		$CanvasLayer/PlanetPanel/RichTextLabel.text = planet_data.outfitter_description
	if "outfitter_image" in planet_data:
		$Backroundimage.texture = load(planet_data.outfitter_image)


func _on_Refuel_pressed():
	var planet_data = GameState.player.current_planet()
	if planet_data == null:
		return
	if "shipyard_description" in planet_data:
		$CanvasLayer/PlanetPanel/RichTextLabel.text = planet_data.shipyard_description
	if "shipyard_image" in planet_data:
		$Backroundimage.texture = load(planet_data.shipyard_image)
