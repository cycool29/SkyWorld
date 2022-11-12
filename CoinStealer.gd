extends KinematicBody2D



var velocity = Vector2()
var direction = -1
export var speed = 120
export var drop_coins = true
var hitted_times = 0
var dead = false

# right => 1
# left => -1

func _ready():
	if direction == 1:
		$AnimatedSprite.flip_h = false
	elif direction == -1:
		$AnimatedSprite.flip_h = true
#	$CollisionShape2D.scale.x = -direction
	$FloorChecker.position.x = $CollisionShape2D.shape.get_extents().x * direction
	$AnimatedSprite.play("walk")


func _physics_process(delta):
	
	velocity.x = 0
	if not $FloorChecker.is_colliding() or $WallCheckerLeft.is_colliding() or $WallCheckerRight.is_colliding():
		direction = direction * -1
		$AnimatedSprite.flip_h = not $AnimatedSprite.flip_h
#		$CollisionShape2D.scale.x = $CollisionShape2D.scale.x * -1
		$FloorChecker.position.x = $CollisionShape2D.shape.get_extents().x * direction
#	velocity.y += 20 # gravity, not really needed for enemies
#	if not hitted_player:
	velocity.x = speed * direction # get negative if times with -1 and get positive if times with 1 
#	velocity.y += 30
	move_and_slide(velocity, Vector2.UP)



func _on_PlayerSidesChecker_body_entered(body):
	if body.is_in_group('player') and body.coins > 0:
		$AnimatedSprite.modulate = Color8(255, 228, 82)
		$AnimatedSprite.play("happy")
		body.deduct_coin(body.coins)
		speed = 0
		$SpeedupTimer.start(1.5)
	elif body.is_in_group('wave'):
		$AnimatedSprite.play("pushed")
		speed = -100
#		move_and_slide(velocity, Vector2.UP)
		yield(get_tree().create_timer(0.7), "timeout")
		speed = 120
		$AnimatedSprite.play("walk")

func _on_SpeedupTimer_timeout():
	$AnimatedSprite.modulate = Color(1,1,1,1)
	$AnimatedSprite.play("walk")
	speed = 120
