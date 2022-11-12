extends Area2D


func _ready():
	$AnimatedSprite.play("shake")


func _on_TimeFreezePotion_body_entered(body):
	body.time_freeze(5)
	queue_free()
