extends KinematicBody2D

onready var player_position = int(Cache.player_position)

func _physics_process(delta):
	if player_position == 1:
		$Sprite.flip_h = true
		$Sprite2.flip_h = true
		$Sprite3.flip_h = true
	position.x += 10 * player_position
