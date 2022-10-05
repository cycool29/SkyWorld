extends KinematicBody2D
#const Settings = preload("res://LoadSettings.gd")

onready var number_texture = $TextureRect
onready var explosion_timer = $ExplosionTimer
export var moving = true
var velocity = Vector2()
var direction = 1
export var explode_time = 0.5
export(String, "Timer", "Collide") var moving_way = "Collide"
onready var initial_y = position.y
onready var initial_x = position.x

func _ready():
	pass

func _on_Area2D_body_entered(body):
	if body.name == Settings.sprite:
		number_texture.visible = true
		explosion_timer.start(explode_time/3)
	

func _physics_process(delta):
	if moving:
		velocity.x = 50 * direction # get negative if times with -1 and get positive if times with 1 
		move_and_slide(velocity, Vector2.UP)
		
		if moving_way == 'Collide':
			for index in get_slide_count():
				var collision := get_slide_collision(index)
				var body := collision.collider
				if body.name == 'TileMapSolid':
					direction *= -1
		position.y = initial_y



func _on_ExplosionTimer_timeout():
	if number_texture.texture == load('res://assets/HUD/hud_3.png'):
		number_texture.texture = load('res://assets/HUD/hud_2.png')
		explosion_timer.start()
	elif number_texture.texture == load('res://assets/HUD/hud_2.png'):
		number_texture.texture = load('res://assets/HUD/hud_1.png')
		explosion_timer.start()
	elif number_texture.texture == load('res://assets/HUD/hud_1.png'):
		if not get_node('/root/GameScene/' + Settings.sprite + '').immune:
			get_node('/root/GameScene/' + Settings.sprite + '').alive = false
			get_node('/root/GameScene/' + Settings.sprite + '').visible = false
		$ExplosionFlash.visible = true
		$ExplosionFlash.play('default')
		$ExplodeSound.play()
		yield(get_tree().create_timer(1), "timeout")
#		get_node('/root/GameScene/ExplosionFlash').visible = false
#		get_node('/root/GameScene/TileMapSolid').set_cellv(location, -1)
		if not get_node('/root/GameScene/' + Settings.sprite + '').immune:
			print('not immune')
			get_node('/root/GameScene/' + Settings.sprite + '').visible = true
			get_node('/root/GameScene/' + Settings.sprite + '').dead('burned')
		$ExplosionFlash.visible = false
		
		

#
#func _on_ExplosionArea_body_exited(body):
#	get_node('/root/GameScene/TileMapDanger/ExplosionArea/ExplosionTimer').stop()
#	get_node('/root/GameScene/TileMapDanger/ExplosionArea/TextureRect').visible = false
#

func _on_Area2D_body_exited(body):
	if body.name == Settings.sprite:
		explosion_timer.stop()
		number_texture.visible = false

