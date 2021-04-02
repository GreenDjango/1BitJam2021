extends Control

func _ready():
	$DialogBox.visible = false

func _process(_delta):
	$Heart1.self_modulate.a = min(Globals.life, 1.0)
	$Heart2.self_modulate.a = min(max(Globals.life - 1.0, 0), 1.0)
	$Heart3.self_modulate.a = min(max(Globals.life - 2.0, 0), 1.0)
	if Globals.dialog != "":
		displayDialog(Globals.dialog)
	else:
		undisplayDialog()
	
	

func _input(event):
	if Globals.life <= 0 && event is InputEventKey:
		if event.pressed:
			Globals.restart_game()

func displayDialog(text: String):
	$DialogBox.setText(text)
	$DialogBox.visible = true

func undisplayDialog():
	$DialogBox.visible = false
	Globals.dialog = ""


func _on_MuteButton_toggled(button_pressed):
	if button_pressed:
		get_tree().call_group("music", "stop")
	else:
		get_tree().call_group("music", "play")
