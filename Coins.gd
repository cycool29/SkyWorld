extends Area2D



func _on_Coins_body_entered(body):
	body.add_coin(1)
	$CollisionShape2D.queue_free()
	$AnimationPlayer.play("bounce")

func _on_AnimationPlayer_animation_finished(_anim_name):
	queue_free()
