extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var _temp
var stun = false
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
var able_to_shoot_wave = false
var on_ladder = false
var on_ladder_ignore_idle = false
var in_lava = false
var status_timer
var jump_streak = 0

onready var wave = preload("res://Wave.tscn")
onready var animated_sprite = get_node("AnimatedSprite")

signal next_level(level)

func _physics_process(_delta):
	velocity.x = 0 
	
	if get_node("/root/GameScene/GameTimer").time_left == 0 and alive:
		dead('timeout')
	
	if not powered and not immune and not able_to_shoot_wave:
		$ProgressBar/Rounded.value = 100
	
	if alive:
		for i in get_slide_count():
			var collision = get_slide_collision(i)
			var spikes = get_parent().get_node("Spikes")
			var spinner = get_parent().get_node("Spinner")
			var water = get_parent().get_node("TileMapWater")
			var lava = get_parent().get_node("TileMapLava")
			if collision.collider == spikes:
				hurt(0.5, false, false, false)
			if collision.collider == spinner:
				hurt(1, false, false, false)
			if collision.collider == water:
				speed = 100
				hurt(0.1, false, false, false)
			elif collision.collider != water:
				speed = 300
			if collision.collider == lava:
				in_lava = true
				hurt(1.2, false, false, true)
			elif collision.collider != lava:
				in_lava = false
				modulate = Color(1, 1, 1, 1)
	else:
		$AnimatedSprite.play("dead")
	
	if alive and not win and not stun:
		# Stop animation if key is released 
		if Input.is_action_just_released("right") or Input.is_action_just_released("left") or Input.is_action_just_released("down") or (Input.is_action_just_released("jump") and not is_on_floor()):
			animated_sprite.stop()
			animated_sprite.frame = 0

		# Basic player movements
		if Input.is_action_pressed("right") or $Camera/RightTouch.is_pressed():
			Cache.player_position = 1
			velocity.x = speed
			animated_sprite.flip_h = false
			if is_on_floor():
				animated_sprite.play('walk')
#			if not $AudioStreamPlayer.playing:
#				$AudioStreamPlayer.play()

		elif Input.is_action_pressed("left") or $Camera/LeftTouch.is_pressed():
			Cache.player_position = -1
			velocity.x = -speed
			animated_sprite.flip_h = true
			if is_on_floor():
				animated_sprite.play("walk")
#			if not $AudioStreamPlayer.playing:
#				$AudioStreamPlayer.play()
			
		elif is_on_floor() and not ignore_idle and not on_ladder_ignore_idle:
			animated_sprite.play("idle")
		
		elif not is_on_floor() and not on_ladder:
			animated_sprite.play("jump")
		
		if Input.is_action_just_pressed("jump") and is_on_floor() and not on_ladder:
			if jump_streak < 3:
#				jump_streak += 1
#				get_node('../JumpStreakStatus').deduct_streak(1)
#				$JumpStreakTimer.stop()
#				$JumpStreakTimer.start(1.5)
#				$JumpSound.play()
				velocity.y = -jump_speed
#			else:
#				if $JumpStreakTimer.time_left == 0:
#					print('starte')
#					$JumpStreakTimer.start(1)
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
		
		if on_ladder:
			if not is_on_floor():
				on_ladder_ignore_idle = true
				$AnimatedSprite.play("climb")
			
			if Input.is_action_pressed("down") or Input.is_action_pressed("jump"):
				on_ladder_ignore_idle = true
				$AnimatedSprite.play("climb")
			elif is_on_floor():
				on_ladder_ignore_idle = false
			
			if not Input.is_action_pressed("down") and not Input.is_action_pressed("jump") and not is_on_floor():
				$AnimatedSprite.stop()
			
			if Input.is_action_pressed("jump"):
				velocity.y = -150
			elif Input.is_action_pressed("down"):
				if not is_on_floor():
					velocity.y = 150
				else:
					on_ladder_ignore_idle = false
			else:
				velocity.y = lerp(velocity.y, 0, 0.3)
		else:
			on_ladder_ignore_idle = false
			
	
	if not on_ladder_ignore_idle:
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
	

func hurt(value, bump=true, _stun=true, _modulate=true):
	if not immune and alive:
	#	var death_reason = 'hurt'
		if _stun:
#			stun = true
			$HurtSound.play()
			$AnimatedSprite.modulate = Color(255, 1, 1, 0.6)
			$Life/LifeProgressBar.value -= value
			$AnimatedSprite.play("idle")
#			if bump:
#				velocity.y = -jump_speed * 0.65
#			speed = 0
			Input.action_release("right")
			Input.action_release("left")
			Input.action_release("jump")
			speed = 1700
			velocity.x = speed * Cache.bounce_direction # get negative if times with -1 and get positive if times with 1 
			velocity.y = -jump_speed * 0.55
			move_and_slide(velocity, Vector2.UP)
			speed = 300
			$StunTimer.start(0.5)
		else:
			$Life/LifeProgressBar.value -= value
			if _modulate:
				modulate = Color(255, 1, 1, 0.6)
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


func status(text, background_color, secs):
	get_node('../StatusBar').visible = true
	get_node('../StatusBar/Label').text = text
	var stylebox = get_node('../StatusBar/Panel').get_stylebox("panel").duplicate()
	stylebox.bg_color = background_color
	get_node('../StatusBar/Panel').add_stylebox_override("panel", stylebox)
	if status_timer != null:
		status_timer.stop()
	status_timer = yield(get_tree().create_timer(secs), "timeout")
	get_node('../StatusBar/Label').text = ''
	stylebox = get_node('../StatusBar/Panel').get_stylebox("panel").duplicate()
	stylebox.bg_color = Color8(255, 255, 255)
	get_node('../StatusBar/Panel').add_stylebox_override("panel", stylebox)
	get_node('../StatusBar').visible = false
	
	
func get_powered():
	print($ProgressBar/Rounded.value)
	if not powered:
		$PotionSound.play()
		status('You just get powered, run and kick!', Color8(251, 105, 0), 2)
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
		$PotionSound.play()
		status('You are immuned to all damages!', Color8(0, 255, 0), 2)
		immune = true
		set_collision_mask_bit(4, false)
		$ProgressBar/Rounded.value = 100
		$TextureRect.modulate = Color8(0, 255, 0)
		$TextureRect.visible = true
		for node in get_node('../Enemies').get_children():
			node.set_collision_mask_bit(0, false)
			if node.get_node('PlayerSidesChecker'):
				node.get_node('PlayerSidesChecker').set_collision_mask_bit(0, false)
				node.get_node('PlayerTopChecker').set_collision_mask_bit(0, false)
			print(node)
		
		if get_node('../BigEnemies'):
			for node in get_node('/root/GameScene/BigEnemies').get_children():
				node.set_collision_mask_bit(0, false)
				if node.get_node('PlayerSidesChecker'):
					node.get_node('PlayerSidesChecker').set_collision_mask_bit(0, false)
					node.get_node('PlayerTopChecker').set_collision_mask_bit(0, false)
		$ImmunityTimer.start()
		$ProgressBar.visible = true
		$ProgressBar/Rounded.tint_progress = Color(0, 255, 0, 1)
		$ProgressBar.start_progress($ImmunityTimer.wait_time)
		print('started immune timer')
	

func get_wave():
	if not able_to_shoot_wave:
		able_to_shoot_wave = true
		$PotionSound.play()
		status('Use your waves to kill the enemies!', Color8(71, 0, 197), 2)
		$WaveTimer.start()
		$ProgressBar.visible = true
		$ProgressBar/Rounded.tint_progress = Color(0, 0, 255, 1)
		$ProgressBar.start_progress($WaveTimer.wait_time)


func time_freeze(sec):
	$PotionSound.play()
	status('Time freezed!', Color8(135, 206, 235), 2)
	get_node('../GameTimer').paused = true
	var stylebox = get_node('../LeftGameTime/Panel').get_stylebox("panel").duplicate()
	stylebox.texture = load("res://assets/HUD/HDStockImages_premium_f4zTge.png")
	get_node('../LeftGameTime/Panel').add_stylebox_override("panel", stylebox)
	yield(get_tree().create_timer(sec), "timeout")
	stylebox = get_node('../LeftGameTime/Panel').get_stylebox("panel").duplicate()
	stylebox.texture = load("res://assets/HUD/grey_background.png")
	get_node('../LeftGameTime/Panel').add_stylebox_override("panel", stylebox)
	get_node('../GameTimer').paused = false
	
		
func dead(reason=''):
	alive = false
	if powered:
		_on_PowerTimer_timeout()
	if stun:
		_on_StunTimer_timeout()
	if able_to_shoot_wave:
		_on_WaveTimer_timeout()
	if immune:
		_on_ImmunityTimer_timeout()
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
	$ProgressBar/Rounded.visible = false
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
		if not node.dead:
			node.get_node('PlayerSidesChecker').set_collision_mask_bit(0, true)
			node.get_node('PlayerTopChecker').set_collision_mask_bit(0, true)
	if get_node('/root/GameScene/BigEnemies'):
		for node in get_node('/root/GameScene/BigEnemies').get_children():
			node.set_collision_mask_bit(0, true)
			if not node.dead:
				node.get_node('PlayerSidesChecker').set_collision_mask_bit(0, true)
				node.get_node('PlayerTopChecker').set_collision_mask_bit(0, true)
	$TextureRect.visible = false
	$TextureRect.modulate = Color8(0,0,0)
	immune = false
	print(immune)



func _on_LifeProgressBar_value_changed(value):
	if value == 0:
		if in_lava:
			dead('burn')
		else:
			dead('life')
		


func _on_StunTimer_timeout():
	if alive:
		$AnimatedSprite.modulate = Color(1,1,1,1)
	speed = 300
	stun = false
	for node in get_node('/root/GameScene/Enemies').get_children():
		node.set_collision_mask_bit(0, true)
		if not node.dead:
			_temp = node.get_node('PlayerSidesChecker').set_collision_mask_bit(0, true)
			_temp = node.get_node('PlayerTopChecker').set_collision_mask_bit(0, true)
	if get_node('/root/GameScene/BigEnemies'):
		for node in get_node('/root/GameScene/BigEnemies').get_children():
			node.set_collision_mask_bit(0, true)
			if not node.dead:
				_temp = node.get_node('PlayerSidesChecker').set_collision_mask_bit(0, true)
				_temp = node.get_node('PlayerTopChecker').set_collision_mask_bit(0, true)
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


func _on_WaveTimer_timeout():
	able_to_shoot_wave = false
	$ProgressBar.visible = false
	print($ProgressBar/Rounded.value)
	$ProgressBar/Rounded.value = 100
	$TextureRect.visible = false
	$TextureRect.modulate = Color8(0,0,0)

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
	Cache.win_time = 120 - int(get_node('../GameTimer').time_left)





func _on_LadderChecker_body_entered(body):
	on_ladder = true


func _on_LadderChecker_body_exited(body):
	on_ladder = false


func _on_JumpStreakTimer_timeout():
	jump_streak = 0
	get_node('../JumpStreakStatus').reset_streak()
