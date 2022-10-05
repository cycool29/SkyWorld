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
	print(configs.get_value("config", "level"))
	configs.load("user://skyworld.cfg")
	sprite = configs.get_value("config", "sprite").capitalize()
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), 0)
