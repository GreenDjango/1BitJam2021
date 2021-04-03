extends Spatial

func _ready():
	pass

func _physics_process(_delta):
	if Globals.life > 0:
		Globals.life -= _delta / 5.0
		if Globals.life < 0:
			Globals.life = 0
