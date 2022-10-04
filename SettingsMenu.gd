extends Control
const Settings = preload("res://LoadSettings.gd")


var sprites_options = ['marcus', 'jessie']
var configs = ConfigFile.new()
var err = configs.load("user://skyworld.cfg")


func _ready():
	if err != OK:
		print('failed')
		# Set default values
		configs.set_value("config", "sprite", "marcus")

		# Save it to a file (overwrite if already exists).
		configs.save("user://skyworld.cfg")

	var sprite = configs.get_value("config", "sprite")

	print(sprite)

	for sprite_name in sprites_options:
		$ItemList.add_item('', load("res://assets/Backgrounds/" + sprite_name + ".png"), true)
		$ItemList.select(sprites_options.find(sprite, 0), true)
		_on_ItemList_item_selected(sprites_options.find(sprite, 0))


func _on_ItemList_item_selected(index):
	print(sprites_options[index])
	$PlayerSpritePreview.texture = load("res://assets/Players/" + sprites_options[index] + "/PNG/Poses HD/idle.png")
	$ItemList.ensure_current_is_visible()
	configs.set_value("config", "sprite", sprites_options[index])
	configs.save("user://skyworld.cfg")




func _on_HomeButton_pressed():
	get_tree().change_scene("res://MainMenu.tscn")
