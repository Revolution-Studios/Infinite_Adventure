extends Node2D

func fromJSON(systemData):
	$Name.text = systemData.name
	position = Vector2(systemData.position[0], systemData.position[1])
