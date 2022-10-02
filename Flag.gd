extends Area2D


func _ready():
	pass


func _on_Flag_body_entered(body):
	print('you win')
	body.win = true
	get_node('/root/GameScene/Player/AnimatedSprite').play('win')
