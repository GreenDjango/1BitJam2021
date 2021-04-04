extends Spatial

var isEnd := false

onready var gameUI := $CanvasLayer/GameUI
onready var player : Player = get_tree().get_nodes_in_group("Player")[0]

func _ready():
	pass

func _process(delta):
	if Globals.life > 0 && player.isFlashlight():
		Globals.life -= delta * 0.05
		if Globals.life < 0:
			Globals.life = 0
			
	if !isEnd && Globals.justDied:
		isEnd = true
		gameUI._on_End()

func _input(_event):
	if isEnd && Input.is_action_just_pressed("ui_accept"):
		Globals.restart_game()
