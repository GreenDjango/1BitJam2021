extends Control

onready var _battery := $BatteryControl/Battery
onready var _pause := $PauseDialog

onready var _mouse := $PauseDialog/MouseSensitivity
onready var _volume := $PauseDialog/GlobalVolume

func _ready():
	_pause.hide()
	_mouse.value = Globals.mouse_sensi
	_mouse.tick_count = int((_mouse.max_value - _mouse.min_value) / _mouse.step)
	_volume.tick_count = int((_volume.max_value - _volume.min_value) / _volume.step)


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


func _on_MouseSensitivity_value_changed(value : float):
	Globals.mouse_sensi = value


func _on_GlobalVolume_value_changed(value : float):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value)


func _on_MusicSwitch_toggled(button_pressed : bool):
	AudioServer.set_bus_mute(AudioServer.get_bus_index("music"), button_pressed)


func _on_SoundSwitch_toggled(button_pressed : bool):
	AudioServer.set_bus_mute(AudioServer.get_bus_index("footstep"), button_pressed)
