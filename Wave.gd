extends KinematicBody2D

onready var player_position = int(Cache.player_position)

func _ready():
	$AnimatedSprite.play("default")

func _physics_process(delta):
	if player_position == -1:
		$AnimatedSprite.flip_h = true
	position.x += 7 * player_position
