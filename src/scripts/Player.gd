extends KinematicBody2D

var velocity := Vector2.ZERO
const speed_max := 70.0
var acceleration := 0.1
const acceleration_step := 0.02
const friction := 0.9
var player_sprite: AnimatedSprite = null
var particles: CPUParticles2D = null

func _ready():
	player_sprite = $AnimatedSprite
	particles = $DeathParticles

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
	if input != Vector2.ZERO:
		if acceleration < 1:
			acceleration += acceleration_step
		player_sprite.play("run")
	else:
		if acceleration > 0.1:
			acceleration -= acceleration_step*2
		player_sprite.play("idle")

	if input.x != 0:
		velocity.x = input.x * speed_max * acceleration
		if velocity.x > 0:
			player_sprite.flip_h = false
		elif velocity.x < 0:
			player_sprite.flip_h = true
	else:
		velocity.x = move_toward(velocity.x, 0, friction)

	if input.y != 0:
		velocity.y = input.y * speed_max * acceleration
	else:
		velocity.y = move_toward(velocity.y, 0, friction)

	# warning-ignore:return_value_discarded
	move_and_slide(velocity)
	#var collide = move_and_collide(velocity, true, true, true)
	#if collide:
	#	print(collide.collider_id)

func hurt(degat: float):
	if Globals.life <= 0:
		return
	Globals.life -= degat
	if Globals.life <= 0:
		Globals.life = 0
		killPlayer()

func killPlayer():
	set_physics_process(false)
	player_sprite.play("death")
	Globals.dialog = "Defeat..."

func victory():
	get_tree().call_group("egg", "hide")
	var nest_node = get_tree().get_nodes_in_group("nest")[0]
	if nest_node:
		position = nest_node.position
	set_physics_process(false)
	player_sprite.play("victory")
	Globals.life = 0.0
	Globals.dialog = "Victory !"

func _on_animation_finished():
	if player_sprite.animation == "victory":
		player_sprite.stop()
		player_sprite.frame = player_sprite.frames.get_frame_count("victory")
	if player_sprite.animation == "death":
		player_sprite.stop()
		particles.emitting = true
		player_sprite.visible = false
