extends Control

func _ready():
	pass

func _process(delta):
	if not $VideoPlayer.is_playing():
		$VideoPlayer.play()
	if not $AudioStreamPlayer2D.playing:
		$AudioStreamPlayer2D.play()

func _input(event):
	if Input.is_key_pressed(KEY_SPACE) or Input.is_key_pressed(KEY_ENTER):
		get_tree().change_scene('res://GameScene.tscn')

func _on_StartButton_pressed():
	 get_tree().change_scene('res://GameScene.tscn')


func _on_HelpButton_pressed():
	 get_tree().change_scene('res://HelpMenu.tscn')


func _on_QuitButton_pressed():
	get_tree().quit()


