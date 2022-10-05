extends Control
#const Settings = preload("res://LoadSettings.gd")
#var death_reason = ''

func _ready():
#	var death_reason = get_node('/root/GameScene/Player').death_reason
	var image = Image.new()
	var err = image.load("user://lose_scene.png")
	if err != OK:
		pass
	else:
		$Background.texture = ImageTexture.new()
		$Background.texture.create_from_image(image, 0)
#
#	if death_reason == 'drop':
#		$GameOverDescription.texture = ImageTexture.new()
#		$GameOverDescription.texture.create_from_image(Image.new().load("res://drop_lose.png"))


func _on_PlayAgain_pressed():
	$ButtonClickedSound.play()
	yield(get_tree().create_timer(0.3), "timeout")
	get_tree().change_scene("res://GameScene.tscn")
	


func _on_Home_pressed():
	$ButtonClickedSound.play()
	yield(get_tree().create_timer(0.3), "timeout")
	get_tree().change_scene("res://MainMenu.tscn")


func _on_Quit_pressed():
	$ButtonClickedSound.play()
	yield(get_tree().create_timer(0.3), "timeout")
	get_tree().quit()
