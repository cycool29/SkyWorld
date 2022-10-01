extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var coins = 0
var speed = 300
var jump_speed = 750
var gravity = 30
var velocity = Vector2()
var alive = true
var immune = false

onready var animated_sprite = get_node("AnimatedSprite")


func _physics_process(_delta):
	velocity.x = 0 
	
	if alive:
		# Stop animation if key is released 
		if Input.is_action_just_released("right") or Input.is_action_just_released("left"):
			animated_sprite.stop()
			animated_sprite.frame = 0

		# Basic player movements
		if Input.is_action_pressed("right"):
			velocity.x = speed
			animated_sprite.scale.x = 1
			animated_sprite.play('walk')
			
		elif Input.is_action_pressed("left"):
			velocity.x = -speed
			animated_sprite.scale.x = -1
			animated_sprite.play("walk")
			
		elif is_on_floor():
			animated_sprite.play("idle")
		
		elif not is_on_floor():
			animated_sprite.play("jump")
		

		
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = -jump_speed

	velocity.y += gravity
	velocity = move_and_slide(velocity, Vector2.UP)
#	print(immune)



# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func bounce_up():
	velocity.y = -jump_speed * 0.5
	

func hurt():
	if not immune:
		print('body hurted')
	#	var death_reason = 'hurt'
		alive = false
		$AnimatedSprite.play("dead")
		modulate = Color(255, 1, 1, 0.6)
		velocity.y = -jump_speed * 0.65
	#	velocity = move_and_slide(velocity, Vector2.UP)
		Input.action_release("right")
		Input.action_release("left")
		
		$DeathTimer.start(1)
	
	
func add_coin(number):
	coins += number
	get_node("/root/GameScene/CoinsCounter/TotalCoins").text = str(coins)


func _on_FallZone_body_entered(_body): #fall down cliffs
	if not immune:
		print('body entered fallzone')
	#	var death_reason = 'drop'
		$DeathTimer.start(1)
	else:
		position.x = 12
		position.y = 2

	
func get_immune(seconds=5):
	immune = true
	set_collision_mask_bit(4, false)
	$AnimatedSprite.modulate = Color(1, 1, -255, 0.6)
	for node in get_node('/root/GameScene/Enemies').get_children():
		node.set_collision_mask_bit(0, false)
		node.get_node('PlayerSidesChecker').set_collision_mask_bit(0, false)
		node.get_node('PlayerTopChecker').set_collision_mask_bit(0, false)
	$ImmunityTimer.start(seconds)
	get_node('/root/GameScene/ProgressBar').visible = true
	get_node('/root/GameScene/ProgressBar/Rounded').tint_progress = Color(0, 255, 0, 1)
	get_node('/root/GameScene/ProgressBar').start_progress(seconds)
	print('started immune timer')
	
	


func _on_DeathTimer_timeout():
	get_node('/root/GameScene/CoinsCounter').visible = false
#	get_node('.').self_modulate = Color(0.59, 0.66, 0.78, 1.0)
#	get_node('/root/GameScene/Player/Camera/Shade').rect_position.x = -512
#	get_node('/root/GameScene/Player/Camera/Shade').rect_position.y = -300
	print('Camera position: ', $Camera.global_position)
#	print('Shade position: ', $Camera/Shade.rect_global_position)
	get_node('/root/GameScene/CanvasLayer/Shade').rect_position.x = 0
	get_node('/root/GameScene/CanvasLayer/Shade').rect_position.y = 0
	get_node('/root/GameScene/CanvasLayer/Shade').visible = true
	get_viewport().set_clear_mode(Viewport.CLEAR_MODE_ONLY_NEXT_FRAME)
	# Wait until the frame has finished before getting the texture.
	yield(VisualServer, "frame_post_draw")
	var image = get_viewport().get_texture().get_data()
	image.flip_y()
	image.set_pixel(1,1,Color(255,1,1,1))
	image.save_png("user://lose_scene.png")
	
	get_tree().change_scene('LoseScene.tscn')


func _on_ImmunityTimer_timeout():
	print('immunity timer timeout')
	get_node('/root/GameScene/ProgressBar').visible = false
	get_node('/root/GameScene/ProgressBar/Rounded').value = 0
	set_collision_mask_bit(4, true)
	$AnimatedSprite.modulate = Color(1, 1, 1, 1)
	for node in get_node('/root/GameScene/Enemies').get_children():
		node.set_collision_mask_bit(0, true)
		node.get_node('PlayerSidesChecker').set_collision_mask_bit(0, true)
		node.get_node('PlayerTopChecker').set_collision_mask_bit(0, true)
	immune = false
	print(immune)
