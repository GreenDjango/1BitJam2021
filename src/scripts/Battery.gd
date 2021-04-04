extends StaticBody

var isInPlayerArea := false

func _ready():
	pass

func setIsInPlayerArea(isInArea: bool):
	isInPlayerArea = isInArea
	if isInArea == true:
		Globals.life += 1
