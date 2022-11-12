extends Area2D
#const Settings = preload("res://LoadSettings.gd")

func _ready():
	$AnimatedSprite.play("shake")


func _on_WavePotion_body_entered(body):
	if not body.immune and not body.powered:
		body.get_wave()
		queue_free()
