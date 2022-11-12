extends Area2D
#const Settings = preload("res://LoadSettings.gd")

func _ready():
	$AnimatedSprite.play("shake")


func _on_PowerPotion_body_entered(body):
	if not body.immune and not body.able_to_shoot_wave:
		body.get_powered()
		queue_free()
