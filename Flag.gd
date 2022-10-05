extends Area2D

func _ready():
	pass


func _on_Flag_body_entered(body):
	
	print('you win')
	body.win = true
	get_node('/root/GameScene/' + Settings.sprite + '/AnimatedSprite').play('win')
	yield(get_tree().create_timer(2), "timeout")
	get_tree().change_scene("res://WinScene.tscn")

