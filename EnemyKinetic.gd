extends Area2D
#
#
## Declare member variables here. Examples:
## var a = 2
## var b = "text"
#
#var speed = 300
#var distance = 1000
#var velocity = Vector2()
##var gravity = 600
#onready var start = position.x
#onready var target = 10
#
#func move(amt, cur, dist):
#	if cur < dist:
#		cur += amt
#		if cur > dist:
#			cur = dist
#	else:
#		cur -= amt
#		if cur < dist:
#			cur = dist
#	return cur
#
#func _process(delta):
#	velocity = move(speed*delta, velocity.x, distance)
##	position.x = move(speed * delta, position.x, target)
#	if position.x == target:
#		if target == start:
#			target = position.x + distance
#		else:
#			target = start
#
## Called when the node enters the scene tree for the first time.
#func _ready():
#	pass # Replace with function body.
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
##func _process(delta):
##	pass
