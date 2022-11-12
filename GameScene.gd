extends Node2D

func _ready():
	Settings.update_settings()
	get_node(Settings.sprite).visible = true
	print(Settings.sprite)
	if Settings.sprite == 'Jessie':
		get_node("Marcus").queue_free()
		get_node("Jessie/Camera").current = true
	elif Settings.sprite == 'Marcus':
		get_node("Jessie").queue_free()
		get_node("Marcus/Camera").current = true
	Cache.playing_level =  str(get_tree().current_scene.filename[15])
	$LevelName/Label.text = "Level " + str(get_tree().current_scene.filename[15])
	var stylebox = $LeftGameTime/Panel.get_stylebox("panel").duplicate()
	stylebox.texture = load("res://assets/HUD/grey_background.png")
	$LeftGameTime/Panel.add_stylebox_override("panel", stylebox)
	$GameTimer.start(2*60)
	
	
func _process(delta):
	$LeftGameTime/Label.text = Time.get_offset_string_from_offset_minutes($GameTimer.time_left).lstrip('+')
