extends KinematicBody2D

func _process(delta):
	$Sprite.rotate(delta * deg2rad(300))
