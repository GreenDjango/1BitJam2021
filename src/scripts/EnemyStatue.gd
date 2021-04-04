extends KinematicBody
class_name EnemyStatue

const SPEED = 1.5
var isFollowing = false
var isInPlayerArea = false
var isFlashlight = true

var statue: MeshInstance

var target: Spatial

func _ready():
	statue = $Statue

func _process(_delta):
	if target == null:
		return
	
	isFlashlight = (target as Player).isFlashlight()
	
	if !target || isVisibleByPlayer(target) || !isInPlayerArea:
		isFollowing = false
	else:
		isFollowing =  true
	
	if !isFollowing && isInPlayerArea && !isFlashlight:
		isFollowing = true
	
	if isFollowing:
		var target_pos = target.global_transform.origin
		var direction_to_target = (target_pos - global_transform.origin).normalized()
# warning-ignore:return_value_discarded
		move_and_slide(direction_to_target * SPEED)

func setIsInPlayerArea(isInArea: bool):
	isInPlayerArea = isInArea

func setTarget(player: Spatial):
	if !target:
		target = player

# Où est appelé cette fonction ?
func follow():
	var target_pos = target.global_transform.origin
	var direction_to_target = (target_pos - global_transform.origin).normalized()
# warning-ignore:return_value_discarded
	move_and_slide(direction_to_target * SPEED)

func isVisibleByPlayer(player): 
	var fowardDirectionVector = -player.transform.basis.z
	var playerToEnemyVector = (translation - player.translation).normalized()
	
	if acos(fowardDirectionVector.dot(playerToEnemyVector)) <= deg2rad(60) :
		return true
	else:
		return false
