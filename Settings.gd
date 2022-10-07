extends Node

var configs = ConfigFile.new()	
var err = configs.load("user://skyworld.cfg")
var sprite = ''
var current_level = 0

func _ready():
	if err != OK:
		print('failed')
		sprite = configs.get_value("config", "sprite").capitalize()

func update_settings():
	configs.load("user://skyworld.cfg")
	current_level = configs.get_value("config", "level")
	sprite = configs.get_value("config", "sprite").capitalize()
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), 0)