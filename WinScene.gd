extends Control
#const Settings = preload("res://LoadSettings.gd")

var configs = ConfigFile.new()	
var err = configs.load("user://skyworld.cfg")

func _ready():
	$Background.play()
	$WinAudio.play()
	$WinApplause.play()
	if not configs.get_value('high_score', Cache.playing_level):
		configs.set_value('high_score', Cache.playing_level, str(0))
		configs.save("user://skyworld.cfg")
	if Cache.win_time < int(configs.get_value('high_score', Cache.playing_level)) or int(configs.get_value('high_score', Cache.playing_level)) == 0:
		configs.set_value('high_score', Cache.playing_level, str(Cache.win_time))
		configs.save("user://skyworld.cfg")
		if Cache.win_time < 60:
			$FastestTime.text = 'New Fastest Record: ' + str(Cache.win_time) + ' seconds!'
		else:
			$FastestTime.text = 'New Fastest Record: ' + Time.get_offset_string_from_offset_minutes(Cache.win_time).lstrip('+') + ' minutes!'
func _process(delta):
	if not $Background.is_playing():
		$Background.play()
	print($Timer.time_left)
	var value = int($Timer.time_left)
	if value <= 9 and value > 1:
		$GoingBackToHomeScreenIn.visible = true
		$SecondsNumber.visible = true
		$SecondsText.visible = true
		$SecondsNumber.texture = load('res://assets/HUD/hud_' + str(value) + '.png')
	elif value <= 1:
		$GoingBackToHomeScreenIn.visible = true
		$SecondsNumber.visible = true
		$SecondsText.visible = true
		$SecondsText.texture = load('res://assets/Backgrounds/second.png')
		$SecondsNumber.texture = load('res://assets/HUD/hud_' + str(value) + '.png')
	elif value == 0:
		get_tree().change_scene("res://MainMenu.tscn")
		
		
func _on_Home_pressed():
	$ButtonClickedSound.play()
	yield(get_tree().create_timer(0.3), "timeout")
	get_tree().change_scene("res://MainMenu.tscn")

func _on_Quit_pressed():
	$ButtonClickedSound.play()
	yield(get_tree().create_timer(0.3), "timeout")
	get_tree().quit()

func _on_Timer_timeout():
	get_tree().change_scene("res://MainMenu.tscn")
	
func _on_ProgressBar_value_changed(value):
	if value <= 9 and value > 1:
		$GoingBackToHomeScreenIn.visible = true
		$SecondsNumber.visible = true
		$SecondsText.visible = true
		$SecondsNumber.texture = load('res://assets/HUD/hud_' + str(int(value)) + '.png')
	elif value <= 1:
		$GoingBackToHomeScreenIn.visible = true
		$SecondsNumber.visible = true
		$SecondsText.visible = true
		$SecondsText.texture = load('res://assets/Backgrounds/second.png')
		$SecondsNumber.texture = load('res://assets/HUD/hud_' + str(int(value)) + '.png')
	elif value == 0:
		get_tree().change_scene("res://MainMenu.tscn")


func _on_NextLevel_pressed():
	get_tree().change_scene('res://GameScene' + str(int(Cache.playing_level) + 1) + '.tscn')
