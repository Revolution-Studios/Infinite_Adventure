extends Node2D

func fromJSON(systemData):
	$Name.text = systemData.name
	$Name.visible = systemData.relationship != "unexplored"
		
	position = Vector2(systemData.position[0], systemData.position[1])
	$Node.animation = systemData.relationship + (
		'_current' if GameState.player.system_id == systemData.id
		else ''
	)
