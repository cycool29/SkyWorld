extends Area2D
const Settings = preload("res://LoadSettings.gd")

func _ready():
	$AnimatedSprite.play("shake")


func _on_PowerPotion_body_entered(body):
	if not body.immune:
		$AudioStreamPlayer.play()
		body.get_powered()
		queue_free()
