extends Control
#const Settings = preload("res://LoadSettings.gd")


var sprites_options = ['marcus', 'jessie']
var configs = ConfigFile.new()
var err = configs.load("user://skyworld.cfg")
var sprite = 'marcus'
var volume = 100

func _ready():
	if err != OK:
		print('failed')
		configs.set_value("config", "sprite", 'marcus')
		configs.set_value("config", "level", "1")
		configs.set_value("config", "volume", "100")

		# Save it to a file (overwrite if already exists).
		configs.save("user://skyworld.cfg")
	
	if ! configs.get_value("config", "level"):
		configs.set_value("config", "level", "1")

	if ! configs.get_value("config", "volume"):
		configs.set_value("config", "volume", "100")
	
	sprite = configs.get_value("config", "sprite")
	volume = int(configs.get_value("config", "volume"))

	print(sprite)

	for sprite_name in sprites_options:
		$ItemList.add_item('', load("res://assets/Backgrounds/" + sprite_name + ".png"), true)
		$ItemList.select(sprites_options.find(sprite, 0), true)
		_on_ItemList_item_selected(sprites_options.find(sprite, 0))

	$HSlider.value = volume

func _on_ItemList_item_selected(index):
	print('selected ' + sprites_options[index])
	$PlayerSpritePreview.texture = load("res://assets/Players/" + sprites_options[index] + "/PNG/Poses HD/idle.png")
	$ItemList.ensure_current_is_visible()
	sprite = sprites_options[index]
	print('now the sprite is ' + sprite)
	configs.set_value("config", "sprite", sprite)
	configs.save("user://skyworld.cfg")
	Settings.update_settings()
#	configs.save("user://skyworld.cfg")




func _on_HomeButton_pressed():
	$ButtonClickedSound.play()
	yield(get_tree().create_timer(0.3), "timeout")
	get_tree().change_scene("res://MainMenu.tscn")



func _on_HSlider_drag_ended(value_changed):
	if value_changed:
		print($HSlider.value)
		configs.set_value("config", "volume", str($HSlider.value))
		configs.save("user://skyworld.cfg")
		Settings.update_settings()
