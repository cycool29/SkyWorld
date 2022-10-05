extends Area2D


func _ready():
	$AnimatedSprite.play("shake")


func _on_ImmunePotion_body_entered(body):
#	get_node('/root/Enemy').set_collision_mask_bit(0, false)
#	body.set_collision_mask_bit(5, false)
	body.get_node('Life/LifeProgressBar').value += 20
	$AudioStreamPlayer.play()
	queue_free()
