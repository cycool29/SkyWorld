extends KinematicBody2D

var velocity = Vector2()
var direction = -1
var hitted_player = false

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

	if not $FloorChecker.is_colliding():
		direction = direction * -1
		$AnimatedSprite.flip_h = not $AnimatedSprite.flip_h
#		$CollisionShape2D.scale.x = $CollisionShape2D.scale.x * -1
		$FloorChecker.position.x = $CollisionShape2D.shape.get_extents().x * direction
#	velocity.y += 20 # gravity, not really needed for enemies
	if not hitted_player:
		velocity.x = 50 * direction # get negative if times with -1 and get positive if times with 1 
		move_and_slide(velocity, Vector2.UP)



func _on_PlayerTopChecker_body_entered(body):
	$AnimatedSprite.play("dead")
	body.bounce_up()
	queue_free()


func _on_PlayerSidesChecker_body_entered(body):
	var enemy_position = round($AnimatedSprite.get_global_transform_with_canvas().origin.x)
	var player_position = round(get_node('/root/GameScene/Player/AnimatedSprite').get_global_transform_with_canvas().origin.x)
	print('Enemy position: ', enemy_position)
	print('Player position: ', player_position)
	if player_position > enemy_position:
		$AnimatedSprite.scale.x = 1
	elif player_position < enemy_position:
		$AnimatedSprite.scale.x = -1
	hitted_player = true
	$PlayerSidesChecker.set_collision_mask_bit(4, false)
	$PlayerSidesChecker.set_collision_mask_bit(0, false)
	$PlayerTopChecker.set_collision_mask_bit(0, false)
	$PlayerTopChecker.set_collision_mask_bit(4, false)
	set_collision_mask_bit(0, false)
	set_collision_mask_bit(4, false)
	body.set_collision_mask_bit(4, false)
	body.hurt()

func _on_PlayerBottomChecker_body_entered(body):
	pass
