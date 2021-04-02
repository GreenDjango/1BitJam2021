extends Node2D

func _ready():
	pass

func _switch_blizzard(active: bool):
	var animator_group : Array = get_tree().get_nodes_in_group("animator")
	if !animator_group || animator_group.empty():
		return
	var animator_node : AnimationPlayer = animator_group[0]
	if active:
		animator_node.play("blizzard")
	else:
		animator_node.play_backwards("blizzard")

func _is_player(body : Node ) -> bool: 
	return body is KinematicBody2D && body.is_in_group("player")

func _on_BlizzardArea_body_entered(body):
	if _is_player(body):
		_switch_blizzard(true)

func _on_BlizzardArea_body_exited(body):
	if _is_player(body):
		_switch_blizzard(false)
