extends KinematicBody2D
const Settings = preload("res://LoadSettings.gd")


var velocity = Vector2()
var direction = -1
export var speed = 50
var hitted_times = 0
	#var hitted_player = false

# right => 1
# left => -1

func _ready():
	if direction == 1:
		$AnimatedSprite.flip_h = true
	elif direction == -1:
		$AnimatedSprite.flip_h = false
#	$CollisionShape2D.scale.x = -direction
	$FloorChecker.position.x = $CollisionShape2D.shape.get_extents().x * direction
	$AnimatedSprite.play("walk")


func _physics_process(delta):

	if not $FloorChecker.is_colliding() or $WallCheckerLeft.is_colliding() or $WallCheckerRight.is_colliding():
		direction = direction * -1
		$AnimatedSprite.flip_h = not $AnimatedSprite.flip_h
#		$CollisionShape2D.scale.x = $CollisionShape2D.scale.x * -1
		$FloorChecker.position.x = $CollisionShape2D.shape.get_extents().x * direction
#	velocity.y += 20 # gravity, not really needed for enemies
#	if not hitted_player:
	velocity.x = speed * direction # get negative if times with -1 and get positive if times with 1 
	move_and_slide(velocity, Vector2.UP)



func _on_PlayerTopChecker_body_entered(body):
	if body.get_class() == 'KinematicBody2D':
		if hitted_times < 2:
			hitted_times += 1
			body.bounce_up()
			modulate = Color(255, 1, 1, 0.6)
		else:
			$AnimatedSprite.play("dead")
			body.bounce_up()
			speed = 0
			yield(get_tree().create_timer(0.5), "timeout")
			queue_free()


func _on_PlayerSidesChecker_body_entered(body):
	if body.get_class() == 'KinematicBody2D' and not body.immune and not body.powered:
		print('body entered')
		var enemy_position = round($AnimatedSprite.get_global_transform_with_canvas().origin.x)
		var player_position = round(get_node('/root/GameScene/' + Settings.sprite + '/AnimatedSprite').get_global_transform_with_canvas().origin.x)
		print('Enemy position: ', enemy_position)
		print('Player position: ', player_position)
#		hitted_player = true
		$PlayerSidesChecker.set_collision_mask_bit(4, false)
		$PlayerSidesChecker.set_collision_mask_bit(0, false)
		$PlayerTopChecker.set_collision_mask_bit(0, false)
		$PlayerTopChecker.set_collision_mask_bit(4, false)
		set_collision_mask_bit(0, false)
		set_collision_mask_bit(4, false)
		body.set_collision_mask_bit(4, false)
		body.hurt(50)
	elif body.get_class() == 'KinematicBody2D' and body.powered:
		body.get_node('AnimatedSprite').play('kick')
		body.ignore_idle = true
		velocity.y -= 300
		Input.action_release("left")
		Input.action_release("right")
		yield(get_tree().create_timer(0.5), "timeout")
		queue_free()
		body.ignore_idle = false
		body.get_node('AnimatedSprite').play('idle')


func _on_PlayerBottomChecker_body_entered(body):
	pass


