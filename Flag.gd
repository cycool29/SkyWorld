extends Area2D


func _ready():
	pass


func _on_Flag_body_entered(body):
	
	print('you win')
	body.win()
#	get_node('/root/GameScene/' + Settings.sprite + '/AnimatedSprite').play('win')

#	get_tree().change_scene("res://WinScene.tscn")
#	emit_signal("level_changed")

