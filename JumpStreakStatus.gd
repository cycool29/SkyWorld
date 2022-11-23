extends Node2D


func _ready():
	pass



func deduct_streak(num):
	for child in $CanvasLayer.get_children():
		if child.value != 0:
#			for i in range(100):
#				child.value -= 10
#				yield(get_tree().create_timer(0.001), "timeout")
			child.value = 0
			break

func reset_streak():
	for child in $CanvasLayer.get_children():
		for i in range(100):
			if child.value != 100:
#				child.value += 50
#				yield(get_tree().create_timer(0.01), 'timeout')
				child.value = 100
