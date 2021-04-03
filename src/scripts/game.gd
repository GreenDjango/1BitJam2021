extends Spatial

onready var _viewport : Viewport = $ViewportContainer/Viewport
onready var _camera : Camera = $ViewportContainer/Viewport/Camera

func _ready():
	_viewport.size = get_viewport().size

func _physics_process(_delta : float):
	var input := Vector2.ZERO
	if Input.is_action_pressed("right"):
		input.x += 1
	if Input.is_action_pressed("left"):
		input.x -= 1
	if Input.is_action_pressed("down"):
		input.y += 1
	if Input.is_action_pressed("up"):
		input.y -= 1
	_move_player(input.normalized())

func _move_player(input: Vector2):
	_camera.rotate_y(input.x * -0.02)
	if input.y < 0:
		# var camera_vec = _camera.global_transform.basis.z.normalized()
		# _camera.translate(camera_vec)
		var cam_xform = _camera.get_global_transform()
		var dir = Vector3()
		dir += -cam_xform.basis.z * input.y
		dir += cam_xform.basis.x * input.x
		dir.y = 0
		dir = dir.normalized()
		_camera.translate(dir * 0.1)

