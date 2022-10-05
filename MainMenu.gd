extends Control
#const Settings = preload("res://LoadSettings.gd")

var configs = ConfigFile.new()
var err = configs.load("user://skyworld.cfg")

func _ready():
	if err != OK:
		print('failed')
		# Set default values
		configs.set_value("config", "sprite", 'marcus')
		configs.set_value("config", "level", "1")
		configs.set_value("config", "volume", "100")

		# Save it to a file (overwrite if already exists).
		configs.save("user://skyworld.cfg")
	
	if ! configs.get_value("config", "level"):
		configs.set_value("config", "level", "1")
		
	Settings.update_settings()
	

func _process(delta):

	if not $VideoPlayer.is_playing():
		$VideoPlayer.play()
	if not $BackgroundMusic.playing:
		$BackgroundMusic.play()

func _input(event):
	if Input.is_key_pressed(KEY_SPACE) or Input.is_key_pressed(KEY_ENTER):
		get_tree().change_scene('res://GameScene.tscn')

func _on_StartButton_pressed():
	$ButtonClickedSound.play()
	yield(get_tree().create_timer(0.3), "timeout")
	get_tree().change_scene('res://GameScene.tscn')


func _on_HelpButton_pressed():
	$ButtonClickedSound.play()
	yield(get_tree().create_timer(0.3), "timeout")
	get_tree().change_scene('res://HelpMenu.tscn')


func _on_QuitButton_pressed():
	$ButtonClickedSound.play()
	yield(get_tree().create_timer(0.3), "timeout")
	get_tree().quit()


func _on_LevelsButton_pressed():
	$ButtonClickedSound.play()
	yield(get_tree().create_timer(0.3), "timeout")
	get_tree().change_scene("res://LevelSelections.tscn")


func _on_SettingsButton_pressed():
	$ButtonClickedSound.play()
	yield(get_tree().create_timer(0.3), "timeout")
	get_tree().change_scene("res://SettingsMenu.tscn")
