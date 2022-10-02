extends Area2D

func _ready():
	$AnimatedSprite.play("shake")


func _on_PowerPotion_body_entered(body):
	body.get_powered()
	queue_free()
