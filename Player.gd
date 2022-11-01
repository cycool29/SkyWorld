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
var powered = false
var ignore_idle = false
var win = false
var configs = ConfigFile.new()
var err = configs.load("user://skyworld.cfg")
var able_to_shoot_wave = true

onready var wave = preload("res://Wave.tscn")
onready var animated_sprite = get_node("AnimatedSprite")

signal next_level(level)

func _physics_process(_delta):
	velocity.x = 0 
	
	if get_node("/root/GameScene/GameTimer").time_left == 0 and alive:
		dead('timeout')
	
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		var spikes = get_parent().get_node("Spikes")
		var spinner = get_parent().get_node("Spinner")
		if collision.collider == spikes:
			hurt(0.5, false)
		if collision.collider == spinner:
			hurt(1, false)
	
	if alive and not win:
		# Stop animation if key is released 
		if Input.is_action_just_released("right") or Input.is_action_just_released("left"):
			animated_sprite.stop()
			animated_sprite.frame = 0

		# Basic player movements
		if Input.is_action_pressed("right") or $Camera/RightTouch.is_pressed():
			Cache.player_position = 1
			velocity.x = speed
			animated_sprite.flip_h = false
			animated_sprite.play('walk')
#			if not $AudioStreamPlayer.playing:
#				$AudioStreamPlayer.play()

		elif Input.is_action_pressed("left") or $Camera/LeftTouch.is_pressed():
			Cache.player_position = -1
			velocity.x = -speed
			animated_sprite.flip_h = true
			animated_sprite.play("walk")
#			if not $AudioStreamPlayer.playing:
#				$AudioStreamPlayer.play()
			
		elif is_on_floor() and not ignore_idle:
			animated_sprite.play("idle")
		
		elif not is_on_floor():
			animated_sprite.play("jump")
		
		if Input.is_action_just_pressed("jump") and is_on_floor():
			$JumpSound.play()
			velocity.y = -jump_speed
			
		if Input.is_action_just_pressed("wave"):
			if able_to_shoot_wave:
				ignore_idle = true
				$AnimatedSprite.play("wave")
				var w = wave.instance()
				get_parent().add_child(w)
				w.global_position = $WaveOut.global_position
				$AnimatedSprite.play('wave')
				ignore_idle = true
				Input.action_release("left")
				Input.action_release("right")
				yield(get_tree().create_timer(0.5), "timeout")
				ignore_idle = false
				$AnimatedSprite.play('idle')

	velocity.y += gravity
	velocity = move_and_slide(velocity, Vector2.UP)
#	print(immune)



func _ready():
#	var configs = ConfigFile.new()
#	var err = configs.load("user://skyworld.cfg")
#	print(configs.get_value('config', 'sprite'))
	get_node("../" + Settings.sprite).visible = true
	Settings.current_level = get_tree().current_scene.filename[15]
	print(get_tree().current_scene.filename[15])
	
func bounce_up():
	velocity.y = -jump_speed * 0.5
	

func hurt(value, bump=true):
	if not immune:
	#	var death_reason = 'hurt'
		$HurtSound.play()
		modulate = Color(255, 1, 1, 0.6)
		$Life/LifeProgressBar.value -= value
		if bump:
			velocity.y = -jump_speed * 0.65
		$StunTimer.start(2)
	#	velocity = move_and_slide(velocity, Vector2.UP)		
#		$DeathTimer.start(1)
	
	
func add_coin(number):
	coins += number
	get_node("/root/GameScene/CoinsCounter/TotalCoins").text = str(coins)

func deduct_coin(number):
	coins -= number
	get_node("/root/GameScene/CoinsCounter/TotalCoins").text = str(coins)


func _on_FallZone_body_entered(body): #fall down cliffs
	print('some one here')
	if not body.immune:
		print('body entered fallzone')
#		$ScreamSound.play()
#		yield(get_tree().create_timer(1.5), "timeout")
	#	var death_reason = 'drop'
		body.dead('cliff')
		$ScreamSound.play(0.45)
	else:
		position.x = 12
		position.y = 2

	
func get_powered():
	print($ProgressBar/Rounded.value)
	if not powered:
		powered = true
		speed = 450
		$ProgressBar/Rounded.value = 100
		$TextureRect.modulate = Color8(255, 255, 0)
		$TextureRect.visible = true
		$ProgressBar.visible = true
		$ProgressBar/Rounded.tint_progress = Color(255, 255, 0, 1)
		$ProgressBar.start_progress($PowerTimer.wait_time)
		$PowerTimer.start()
		print('started power timer')
	
	
func get_immune():
	if not immune:
		immune = true
		set_collision_mask_bit(4, false)
		$ProgressBar/Rounded.value = 100
		$TextureRect.modulate = Color8(0, 255, 0)
		$TextureRect.visible = true
		for node in get_node('../Enemies').get_children():
			node.set_collision_mask_bit(0, false)
			node.get_node('PlayerSidesChecker').set_collision_mask_bit(0, false)
			node.get_node('PlayerTopChecker').set_collision_mask_bit(0, false)
			print(node)
		
		if get_node('../BigEnemies'):
			for node in get_node('/root/GameScene/BigEnemies').get_children():
				node.set_collision_mask_bit(0, false)
				node.get_node('PlayerSidesChecker').set_collision_mask_bit(0, false)
				node.get_node('PlayerTopChecker').set_collision_mask_bit(0, false)
		$ImmunityTimer.start()
		$ProgressBar.visible = true
		$ProgressBar/Rounded.tint_progress = Color(0, 255, 0, 1)
		$ProgressBar.start_progress($ImmunityTimer.wait_time)
		print('started immune timer')
	
	
func dead(reason=''):
	alive = false
	if powered:
		_on_PowerTimer_timeout()
	$AnimatedSprite.play("dead")
	if reason == 'burn':
		modulate = Color(0,0,0)
	if get_node("CollisionShape"):
		$CollisionShape.queue_free()
	Input.action_release("right")
	Input.action_release("left")
	Input.action_release("jump")
	get_node('/root/GameScene/CoinsCounter').visible = false
	get_node('/root/GameScene/' + Settings.sprite + '/Life').visible = false
	get_node('/root/GameScene/Shop').visible = false
#	get_node('/root/GameScene/LevelName').visible = false
	yield(get_tree().create_timer(1.5), "timeout")
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
	Cache.dead_reason = reason
	get_tree().change_scene('res://LoseScene.tscn')


func _on_ImmunityTimer_timeout():
	print('immunity timer timeout')
	$ProgressBar.visible = false
	$ProgressBar/Rounded.value = 100
	set_collision_mask_bit(4, true)
	$AnimatedSprite.modulate = Color(1, 1, 1, 1)
	for node in get_node('/root/GameScene/Enemies').get_children():
		node.set_collision_mask_bit(0, true)
		node.get_node('PlayerSidesChecker').set_collision_mask_bit(0, true)
		node.get_node('PlayerTopChecker').set_collision_mask_bit(0, true)
	if get_node('/root/GameScene/BigEnemies'):
		for node in get_node('/root/GameScene/BigEnemies').get_children():
			node.set_collision_mask_bit(0, true)
			node.get_node('PlayerSidesChecker').set_collision_mask_bit(0, true)
			node.get_node('PlayerTopChecker').set_collision_mask_bit(0, true)
	$TextureRect.visible = false
	$TextureRect.modulate = Color8(0,0,0)
	immune = false
	print(immune)



func _on_LifeProgressBar_value_changed(value):
	if value == 0:
		dead('life')
		


func _on_StunTimer_timeout():
	modulate = Color(1,1,1,1)
	for node in get_node('/root/GameScene/Enemies').get_children():
		node.set_collision_mask_bit(0, true)
		node.get_node('PlayerSidesChecker').set_collision_mask_bit(0, true)
		node.get_node('PlayerTopChecker').set_collision_mask_bit(0, true)
	if get_node('/root/GameScene/BigEnemies'):
		for node in get_node('/root/GameScene/BigEnemies').get_children():
			node.set_collision_mask_bit(0, true)
			node.get_node('PlayerSidesChecker').set_collision_mask_bit(0, true)
			node.get_node('PlayerTopChecker').set_collision_mask_bit(0, true)
	set_collision_mask_bit(4, false)


func _on_PowerTimer_timeout():
	print('power timeout')
	speed = 300
	$ProgressBar.visible = false
	print($ProgressBar/Rounded.value)
	$ProgressBar/Rounded.value = 100
	$TextureRect.visible = false
	$TextureRect.modulate = Color8(0,0,0)
	powered = false

func win():
	win = true
	set_collision_mask_bit(3, false)
	set_collision_mask_bit(4, false)
	set_collision_mask_bit(5, false)
	set_collision_mask_bit(7, false)
	Input.action_release("right")
	Input.action_release("left")
	Input.action_release("jump")
	animated_sprite.play("win")
	yield(get_tree().create_timer(2), "timeout")
	get_tree().change_scene("res://WinScene.tscn")
	configs.set_value("config", "level", int(Settings.current_level) + 1)
	configs.save("user://skyworld.cfg")
	Settings.update_settings()
