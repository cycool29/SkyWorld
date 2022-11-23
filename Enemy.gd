extends KinematicBody2D


var velocity = Vector2()
var direction = -1
var dead = false
export var speed = 50
export var drop_coins = true
#var hitted_player = false
const coins_scene = preload("res://Coins.tscn")

# right => 1
# left => -1

func _ready():
	if direction == 1:
		$AnimatedSprite.flip_h = true
	elif direction == -1:
		$AnimatedSprite.flip_h = false
#	$CollisionShape2D.scale.x = -direction
	$FloorChecker.position.x = $CollisionShape2D.shape.get_extents().x * direction
#	$AnimatedSprite.play("walk")


func _physics_process(delta):
	for i in get_slide_count():
			var collision = get_slide_collision(i)
			if collision.collider.is_in_group('player'):
				_on_PlayerTopChecker_body_entered(collision.collider)
	if (not $FloorChecker.is_colliding() or $WallCheckerLeft.is_colliding() or $WallCheckerRight.is_colliding()) and not dead:
		direction = direction * -1
		$AnimatedSprite.flip_h = not $AnimatedSprite.flip_h
#		$CollisionShape2D.scale.x = $CollisionShape2D.scale.x * -1
		$FloorChecker.position.x = $CollisionShape2D.shape.get_extents().x * direction
#	velocity.y += 20 # gravity, not really needed for enemies
#	if not hitted_player:
	velocity.x = speed * direction # get negative if times with -1 and get positive if times with 1 
	move_and_slide(velocity, Vector2.UP)



func _on_PlayerTopChecker_body_entered(body):
	if (body.is_in_group('player') or body.is_in_group('wave')) and not dead:
		dead = true
		speed = 0
		$CollisionShape2D.queue_free()
		$PlayerSidesChecker.queue_free()
		$DeathSound.play()
		$AnimatedSprite.play("dead")
		if drop_coins:
			var coins_instance = coins_scene.instance()
			coins_instance.name = 'Coins'
			get_node("../../Coins").add_child(coins_instance)
			coins_instance.position = position
		if body.is_in_group('player'):
			body.bounce_up()
		yield(get_tree().create_timer(0.5), "timeout")
		queue_free()
		


func _on_PlayerSidesChecker_body_entered(body):
	if body.name == Settings.sprite and not body.immune and not body.powered:
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
		body.hurt(20)
	elif body.is_in_group('player') and body.powered:
		body.get_node('AnimatedSprite').play('kick')
		body.ignore_idle = true
		velocity.y -= 300
		Input.action_release("left")
		Input.action_release("right")
		yield(get_tree().create_timer(0.5), "timeout")
		queue_free()
		body.ignore_idle = false
		body.get_node('AnimatedSprite').play('idle')
	elif body.is_in_group('wave'):
		_on_PlayerTopChecker_body_entered(body)

#
#func _on_PlayerSidesChecker_body_exited(body):
#	if body.name == Settings.sprite and body.stun:
#		body._on_StunTimer_timeout()
