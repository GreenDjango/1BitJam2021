extends Control

onready var _battery := $BatteryControl/Battery
onready var _pause := $PauseDialog
onready var _end := $EndControl

onready var _mouse := $PauseDialog/MouseSensitivity
onready var _volume := $PauseDialog/GlobalVolume

func _ready():
	_pause.hide()
	_end.hide()
	_mouse.value = Globals.mouse_sensi
	_mouse.tick_count = int((_mouse.max_value - _mouse.min_value) / _mouse.step)
	_volume.tick_count = int((_volume.max_value - _volume.min_value) / _volume.step)


func _process(_delta):
	_battery.frame = int(ceil(Globals.life))


func _input(_event):
	if Globals.justDied == true:
		return
	
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			_pause.hide()
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			_pause.show()


func _on_End():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	_pause.hide()
	_end.show()


func _on_MouseSensitivity_value_changed(value : float):
	Globals.mouse_sensi = value


func _on_GlobalVolume_value_changed(value : float):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value)


func _on_MusicSwitch_toggled(button_pressed : bool):
	var mute = !button_pressed
	AudioServer.set_bus_mute(AudioServer.get_bus_index("music"), mute)


func _on_SoundSwitch_toggled(button_pressed : bool):
	var mute = !button_pressed
	AudioServer.set_bus_mute(AudioServer.get_bus_index("fx"), mute)
