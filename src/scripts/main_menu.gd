extends Control

func _ready():
	$Control/Path2D/PathFollow2D/Pingu.play("fly")

func _input(event):
	if event is InputEventKey:
		if event.pressed:
			Globals.goto_scene("game")

