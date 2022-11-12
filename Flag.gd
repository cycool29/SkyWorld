extends KinematicBody2D


func _ready():
	$AnimatedSprite.play("default")


func _on_Area2D_body_entered(body):
	print('you win')
	$AnimatedSprite.play("pressed")
	body.win()
