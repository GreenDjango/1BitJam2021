extends Control

onready var _battery = $BatteryControl/Battery
onready var _pause = $PauseDialog

func _ready():
	_pause.hide()

func _process(_delta):
	_battery.frame = int(ceil(Globals.life))


func _input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			_pause.hide()
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			_pause.show()


	if false && Globals.life <= 0 && event is InputEventKey:
		if event.pressed:
			Globals.restart_game()


func _on_MuteButton_toggled(button_pressed):
	if button_pressed:
		get_tree().call_group("music", "stop")
	else:
		get_tree().call_group("music", "play")
