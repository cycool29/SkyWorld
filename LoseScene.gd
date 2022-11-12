extends Control
#const Settings = preload("res://LoadSettings.gd")
#var death_reason = ''

var cliff_desc = ['Watch your steps...', "I'm Scared Of Heights...", 'I Should Have Learned How To Fly.', 'OMAHaaaaaaaaaa!', 'You Fell To Your Death.']
var life_desc = ['That wasn’t supposed to happen...', 'That didn’t work out.', 'That’s… bad…', 'Please don’t smash your monitor.', 'Aaaaand that’s a wrap.']
var burn_desc = ['Smells Like Toast.', 'Do I Smell Smoke?', 'Went up in flames.', 'Arghhhh... burned to crisp.', 'Having A Bad Hair Day.']
var timeout_desc = ['Too slow, man.', 'Times up!', 'Time never waits.', 'Faster!', 'Almost had it.']

func _ready():
	randomize()
	var image = Image.new()
	var err = image.load("user://lose_scene.png")
	if err != OK:
		pass
	else:
		$Background.texture = ImageTexture.new()
		$Background.texture.create_from_image(image, 0)
#
	if Cache.dead_reason == 'cliff':
		$GameOverDescription.text = '"' + cliff_desc[rand_range(0, 4)] + '"'
	elif Cache.dead_reason == 'life':
		$GameOverDescription.text = '"' + life_desc[rand_range(0, 4)] + '"'
	elif Cache.dead_reason == 'burn':
		$GameOverDescription.text = '"' + burn_desc[rand_range(0, 4)] + '"'
	elif Cache.dead_reason == 'timeout':
		$GameOverDescription.text = '"' + timeout_desc[rand_range(0, 4)] + '"'


func _on_PlayAgain_pressed():
	$ButtonClickedSound.play()
	yield(get_tree().create_timer(0.3), "timeout")
	get_tree().change_scene('res://GameScene' + Cache.playing_level + '.tscn')
	


func _on_Home_pressed():
	$ButtonClickedSound.play()
	yield(get_tree().create_timer(0.3), "timeout")
	get_tree().change_scene("res://MainMenu.tscn")


func _on_Quit_pressed():
	$ButtonClickedSound.play()
	yield(get_tree().create_timer(0.3), "timeout")
	get_tree().quit()
