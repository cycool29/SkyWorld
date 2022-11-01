extends Node2D

export var idle_duration = 0.3
export var move_to = Vector2.RIGHT * 192
export var speed = 3.0

func _ready():
	_init_tween()
	
	
func _init_tween():
	var duration = move_to.length() / float(speed * 64)
	$Tween.interpolate_property($KinematicBody2D, "position", Vector2.ZERO, move_to, duration, Tween.TRANS_LINEAR, Tween.EASE_IN, idle_duration)
	$Tween.interpolate_property($KinematicBody2D, "position", move_to, Vector2.ZERO, duration, Tween.TRANS_LINEAR, Tween.EASE_IN, duration + idle_duration * 2)
	$Tween.start()
	print('started')
