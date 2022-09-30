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

onready var animated_sprite = get_node("AnimatedSprite")


func _physics_process(delta):
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



# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func bounce_up():
	velocity.y = -jump_speed * 0.5
	

func hurt():
	print('body hurted')
#	var death_reason = 'hurt'
	alive = false
	$AnimatedSprite.play("dead")
	modulate = Color(255, 1, 1, 0.6)
	velocity.y = -jump_speed * 0.65
#	velocity = move_and_slide(velocity, Vector2.UP)
	Input.action_release("right")
	Input.action_release("left")
	
	$Timer.start(1)
	
	
func add_coin(number):
	coins += number
	get_node("/root/GameScene/CoinsCounter/TotalCoins").text = str(coins)


func _on_FallZone_body_entered(body): #fall down cliffs
	print('body entered fallzone')
#	var death_reason = 'drop'
	$Timer.start(1)

#Color: #977601

func _on_Timer_timeout(): # game over
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
