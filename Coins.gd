extends Area2D
const Settings = preload("res://LoadSettings.gd")


func _on_Coins_body_entered(body):
	body.add_coin(1)
	$CollisionShape2D.queue_free()
	$AnimationPlayer.play("bounce")
	$AudioStreamPlayer2D.play()

func _on_AnimationPlayer_animation_finished(_anim_name):
	queue_free()
