extends KinematicBody2D
const Settings = preload("res://LoadSettings.gd")

onready var number_texture = $TextureRect
onready var explosion_timer = $ExplosionTimer

func _ready():
	pass

func _on_Area2D_body_entered(body):
	if body.name == Settings.sprite:
		number_texture.visible = true
		explosion_timer.start(0.5/3)
	

#
#func _on_ExplosionArea_body_entered(body):
#	get_node('/root/GameScene/TileMapDanger/ExplosionArea/TextureRect').visible = true
#	get_node('/root/GameScene/TileMapDanger/ExplosionArea/ExplosionTimer').start()
#	print($CollisionShape)
#

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

