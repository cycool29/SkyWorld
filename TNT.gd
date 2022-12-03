extends Node2D
#const Settings = preload("res://LoadSettings.gd")

onready var number_texture = $KinematicBody2D/TextureRect
onready var explosion_timer = $ExplosionTimer
export var moving = true
#var velocity = Vector2()
#var direction = 1
export var explode_time = 0.5
#export(String, "Timer", "Collide") var moving_way = "Collide"
#onready var initial_y = position.y
#onready var initial_x = position.x
var is_bombing = false
export var idle_duration = 0.3
export var move_to = Vector2.RIGHT * 192
export var speed = 3.0
var going_to_kill_player = false

func _ready():
	if moving:
		_init_tween()

func _on_Area2D_body_entered(body):
	if body.name == Settings.sprite:
		number_texture.visible = true
		explosion_timer.start(explode_time/3)
	

func _init_tween():
	var duration = move_to.length() / float(speed * 64)
	$Tween.interpolate_property($KinematicBody2D, "position", Vector2.ZERO, move_to, duration, Tween.TRANS_LINEAR, Tween.EASE_IN, idle_duration)
	$Tween.interpolate_property($KinematicBody2D, "position", move_to, Vector2.ZERO, duration, Tween.TRANS_LINEAR, Tween.EASE_IN, duration + idle_duration * 2)
	$Tween.start()
	print('started')

func _on_ExplosionTimer_timeout():
	if number_texture.texture == load('res://assets/HUD/hud_3.png'):
		number_texture.texture = load('res://assets/HUD/hud_2.png')
		explosion_timer.start()
	elif number_texture.texture == load('res://assets/HUD/hud_2.png'):
		number_texture.texture = load('res://assets/HUD/hud_1.png')
		explosion_timer.start()
	elif number_texture.texture == load('res://assets/HUD/hud_1.png'):
		
			
		if not is_bombing:
			if not get_node('/root/GameScene/' + Settings.sprite + '').immune:
				going_to_kill_player = true
				get_node('/root/GameScene/' + Settings.sprite + '').alive = false
				get_node('/root/GameScene/' + Settings.sprite + '').visible = false
			is_bombing = true
			get_node('/root/GameScene/' + Settings.sprite + '').gravity = 0
			$KinematicBody2D/ExplosionFlash.visible = true
			$KinematicBody2D/ExplosionFlash.play('default')
			$ExplodeSound.play()
			yield(get_tree().create_timer(1), "timeout")
	#		get_node('/root/GameScene/ExplosionFlash').visible = false
	#		get_node('/root/GameScene/TileMapSolid').set_cellv(location, -1)
			get_node('/root/GameScene/' + Settings.sprite + '').gravity = 30
			get_node('/root/GameScene/' + Settings.sprite + '').visible = true
			if going_to_kill_player:
				get_node('/root/GameScene/' + Settings.sprite + '').dead('burn')
			$KinematicBody2D/ExplosionFlash.visible = false
		
		

#
#func _on_ExplosionArea_body_exited(body):
#	get_node('/root/GameScene/TileMapDanger/ExplosionArea/ExplosionTimer').stop()
#	get_node('/root/GameScene/TileMapDanger/ExplosionArea/TextureRect').visible = false
#

func _on_Area2D_body_exited(body):
	if body.name == Settings.sprite:
		explosion_timer.stop()
		number_texture.visible = false

