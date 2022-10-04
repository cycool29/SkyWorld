extends TileMap

onready var body = get_node('/root/GameScene/Player')
var exploding = false

func _ready():
	pass

func _process(delta):
#	if get_node('/root/GameScene/Player').collider == $".":
#		get_node('/root/GameScene/TileMapDanger/ExplosionArea/TextureRect').visible = true
#		get_node('/root/GameScene/TileMapDanger/ExplosionArea/ExplosionTimer').start()
	for index in body.get_slide_count():
		var collision = body.get_slide_collision(index)
		if collision.collider.name == 'TileMapDanger':
			$TextureRect.visible = true
			$ExplosionTimer.start()
			exploding = true
		else:
			$TextureRect.visible = false
			$ExplosionTimer.stop()
		
#
#
#func _on_ExplosionArea_body_entered(body):
#	get_node('/root/GameScene/TileMapDanger/ExplosionArea/TextureRect').visible = true
#	get_node('/root/GameScene/TileMapDanger/ExplosionArea/ExplosionTimer').start()
#	print($CollisionShape)
#

func _on_ExplosionTimer_timeout():
	if get_node('/root/GameScene/TileMapDanger/TextureRect').texture == load('res://assets/HUD/hud_3.png'):
		get_node('/root/GameScene/TileMapDanger/TextureRect').texture = load('res://assets/HUD/hud_2.png')
		get_node('/root/GameScene/TileMapDanger/ExplosionTimer').start()
	elif get_node('/root/GameScene/TileMapDanger/TextureRect').texture == load('res://assets/HUD/hud_2.png'):
		get_node('/root/GameScene/TileMapDanger/TextureRect').texture = load('res://assets/HUD/hud_1.png')
		get_node('/root/GameScene/TileMapDanger/ExplosionTimer').start()
	elif get_node('/root/GameScene/TileMapDanger/TextureRect').texture == load('res://assets/HUD/hud_1.png'):
		get_node('/root/GameScene/ExplosionFlash').visible = true
		get_node('/root/GameScene/ExplosionFlash').play('default')
		yield(get_tree().create_timer(1), "timeout")
#		get_node('/root/GameScene/ExplosionFlash').visible = false
#		get_node('/root/GameScene/TileMapSolid').set_cellv(location, -1)
		if not get_node('/root/GameScene/Player').immune:
			get_node('/root/GameScene/Player').dead()
		get_node('/root/GameScene/ExplosionFlash').visible = false
		exploding = false
		
#
#
#func _on_ExplosionArea_body_exited(body):
#	get_node('/root/GameScene/TileMapDanger/ExplosionArea/ExplosionTimer').stop()
#	get_node('/root/GameScene/TileMapDanger/ExplosionArea/TextureRect').visible = false
