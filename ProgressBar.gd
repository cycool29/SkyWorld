extends CanvasLayer
const Settings = preload("res://LoadSettings.gd")

func _ready():
	pass

func start_progress(seconds):
	print(seconds)
	$Timer.start(float(seconds)/100)


func _on_Timer_timeout():
	$Rounded.value += 1
#	$Rounded.tint_progress = Color(0, 255, 0, 1)
	
