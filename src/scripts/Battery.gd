extends Area

func _ready():
	pass

func _on_Battery_body_entered(body):
	if body.is_in_group("Player"):
		Globals.life += 1
		queue_free()
