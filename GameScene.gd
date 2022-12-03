extends Node2D

func _ready():
	$CanvasLayer/AnimationPlayer.play("fade")
	Settings.update_settings()
	get_node(Settings.sprite).visible = true
	print(Settings.sprite)
	if Settings.sprite == 'Jessie':
		get_node("Marcus").queue_free()
		get_node("Bruno").queue_free()
		get_node("Jessie/Camera").current = true
	elif Settings.sprite == 'Marcus':
		get_node("Jessie").queue_free()
		get_node("Bruno").queue_free()
		get_node("Marcus/Camera").current = true
	elif Settings.sprite == 'Bruno':
		get_node("Marcus").queue_free()
		get_node("Jessie").queue_free()
		get_node("Bruno/Camera").current = true
	Cache.playing_level =  str(get_tree().current_scene.filename[15])
	$LevelName/Label.text = "Level " + str(get_tree().current_scene.filename[15])
	var stylebox = $LeftGameTime/Panel.get_stylebox("panel").duplicate()
	stylebox.texture = load("res://assets/HUD/grey_background.png")
	print(get_node("Marcus/JumpStreakTimer").time_left)
	#	get_node("Jessie/JumpStreakTimer").stop()
	$LeftGameTime/Panel.add_stylebox_override("panel", stylebox)
	$GameTimer.start(2*60)
	
	
func _process(delta):
	if not $CanvasLayer/AnimationPlayer.is_playing() and get_node("ColorRect"):
		$CanvasLayer/ColorRect.queue_free()
	$LeftGameTime/Label.text = Time.get_offset_string_from_offset_minutes($GameTimer.time_left).lstrip('+')


func _on_ExitButton_pressed():
	$ButtonClickedSound.play()
	yield(get_tree().create_timer(0.3), "timeout")
	get_tree().change_scene("res://MainMenu.tscn")


func _on_FallZone_body_entered(body):
	pass # Replace with function body.
