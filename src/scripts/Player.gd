extends KinematicBody
class_name Player

const GRAVITY = -20
var vel = Vector3()
const MAX_SPEED = 4
const JUMP_SPEED = 8
const ACCEL = 2

var dir = Vector3()

const DEACCEL= 16
const MAX_SLOPE_ANGLE = 40

var camera = null
var cameraAnimation: AnimationPlayer
var rotation_helper = null

onready var audio_footstep1 := $Footstep
onready var audio_footstep2 := $Footstep2
onready var audio_footstep3 := $Footstep3
onready var audio_flashlight := $Flashlight_click
onready var audio_death := $Death

const MAX_SPRINT_SPEED = 6
const SPRINT_ACCEL = 4
var is_sprinting = false

var arm = null
onready var flashlight := $Rotation_Helper/Model/arm/Flashlight
var _isFlashlight = true

var isEnemyInProxyArea = false
var bodyInProxyArea = null
var armAnimation: AnimationPlayer

func _ready():
	armAnimation = $Rotation_Helper/Model/arm/AnimationPlayer
	arm = $Rotation_Helper/Model/arm
	camera = $Rotation_Helper/Camera
	cameraAnimation = $Rotation_Helper/CameraAnimation
	rotation_helper = $Rotation_Helper

	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(_delta):
	flashlight.light_energy =  ceil(Globals.life) / Globals.default_life

func _physics_process(delta):
	process_input(delta)
	process_movement(delta)

func process_input(_delta):
	if Globals.justDied == true:
		return
	
	# ----------------------------------
	# Walking
	dir = Vector3()
	var cam_xform = camera.get_global_transform()

	var input_movement_vector = Vector2()

	if Input.is_action_pressed("up"):
		input_movement_vector.y += 1
	if Input.is_action_pressed("down"):
		input_movement_vector.y -= 1
	if Input.is_action_pressed("left"):
		input_movement_vector.x -= 1
	if Input.is_action_pressed("right"):
		input_movement_vector.x += 1

	input_movement_vector = input_movement_vector.normalized()

	# Basis vectors are already normalized.
	dir += -cam_xform.basis.z * input_movement_vector.y
	dir += cam_xform.basis.x * input_movement_vector.x
	# ----------------------------------

	if Input.is_action_pressed("rotate_left"):
		rotate_y(1.2 * _delta)
		
	if Input.is_action_pressed("rotate_right"):
		rotate_y(-1.2 * _delta)

	# ----------------------------------
	# Jumping
	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			vel.y = JUMP_SPEED
	# ----------------------------------
	# ----------------------------------
	# Sprinting
	if Input.is_action_pressed("sprint"):
		is_sprinting = true
	else:
		is_sprinting = false
	# ----------------------------------
	
	# ----------------------------------
	# Turning the flashlight on/off
	if Input.is_action_just_pressed("flashlight") && !armAnimation.is_playing():
		if flashlight.is_visible_in_tree():
			flashlight.hide()
			_isFlashlight = false
			playButtonAnimation()
			flashlight_click()
		else:
			flashlight.show()
			_isFlashlight = true
			playButtonAnimation()
			flashlight_click()
	# ----------------------------------
	
	# -----------------------------------
	# Death condition
	if isEnemyInProxyArea && (!isFlashlight() || !isEnemyVisible()):
		death()

func process_movement(delta):
	if Globals.justDied == true:
		return
	
	dir.y = 0
	dir = dir.normalized()

	vel.y += delta * GRAVITY

	var hvel = vel
	hvel.y = 0

	var target = dir
	if is_sprinting:
		target *= MAX_SPRINT_SPEED
	else:
		target *= MAX_SPEED
	
	var accel
	if dir.dot(hvel) > 0:
		accel = ACCEL
		cameraAnimation.play("CameraBalancing")
	else:
		accel = DEACCEL
		cameraAnimation.stop(true)

	hvel = hvel.linear_interpolate(target, accel * delta)
	vel.x = hvel.x
	vel.z = hvel.z
	vel = move_and_slide(vel, Vector3(0, 1, 0), 0.05, 4, deg2rad(MAX_SLOPE_ANGLE))

func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		var MOUSE_SENSITIVITY = Globals.mouse_sensi
		rotation_helper.rotate_x(deg2rad(event.relative.y * MOUSE_SENSITIVITY * -1))
		self.rotate_y(deg2rad(event.relative.x * MOUSE_SENSITIVITY * -1))

		var camera_rot = rotation_helper.rotation_degrees
		camera_rot.x = clamp(camera_rot.x, -70, 70)
		camera.rotation_degrees = camera_rot

func isFlashlight():
	return _isFlashlight && Globals.life > 0

func death():
	if bodyInProxyArea:
		audio_death.play()
		bodyInProxyArea.displayScreamer()
		Globals.justDied = true
		self.hide()

func _on_EnemyAgroArea_body_entered(body):
	if body.is_in_group("Enemies"):
		body.setIsInPlayerArea(true)
		bodyInProxyArea = body
		body.setTarget(self)
	else:
		return

func _on_EnemyAgroArea_body_exited(body):
	if body.is_in_group("Enemies"):
		body.setIsInPlayerArea(false)
	else:
		return

func foot_step3():
	audio_footstep3.pitch_scale = rand_range(0.9, 1.1)
	audio_footstep3.play()

func foot_step2():
	audio_footstep2.pitch_scale = rand_range(1, 1.1)
	audio_footstep2.volume_db = 0.6
	audio_footstep2.play()

func foot_step1():
	audio_footstep1.pitch_scale = rand_range(1, 1.1)
	audio_footstep1.volume_db = 0.7
	audio_footstep1.play()

func flashlight_click():
	audio_flashlight.volume_db = 0.5
	audio_flashlight.play()

func main_foot_step():
	if !is_on_floor():
		return
	var tmp_rand = rand_range(0, 2)
	if tmp_rand < 0.7:
		foot_step1()
	elif tmp_rand < 1.3:
		foot_step2()
	else:
		foot_step3()

func isEnemyVisible():
	if !bodyInProxyArea:
		return false
	var fowardDirectionVector = -transform.basis.z
	var playerToEnemyVector = (bodyInProxyArea.translation - translation).normalized()
	
	if acos(fowardDirectionVector.dot(playerToEnemyVector)) <= deg2rad(60) :
		return true
	else:
		return false

func _on_ProxyArea_body_entered(body):
	if body.is_in_group("Enemies"):
		isEnemyInProxyArea = true
	else:
		return


func _on_ProxyArea_body_exited(body):
	if body.is_in_group("Enemies"):
		isEnemyInProxyArea = false
	else:
		return

func _on_ProxyArea_area_entered(area):
	if area.get_parent().is_in_group("Collectible"):
		Globals.is_treasure_found = true
		area.get_parent().pickUp()

func playButtonAnimation():
	armAnimation.play("ArmatureAction")



