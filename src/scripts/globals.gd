extends Node

var default_life := 4.0
var life := default_life
var dialog := ""
var mouse_sensi = 0.07
var justDied = false

func _ready():
	randomize()

func restart_game():
	life = default_life
	dialog = ""
	goto_scene("MainMenu")

func goto_scene(new_scene_name : String):
	if new_scene_name == "Game":
		justDied = false
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://src/scenes/" + new_scene_name + ".tscn")
