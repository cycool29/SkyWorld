extends Node

var configs = ConfigFile.new()	
var err = configs.load("user://skyworld.cfg")
var sprite = ''
var current_level = 0
var volume = 1

func _ready():
	if err != OK:
		print('failed')
		sprite = configs.get_value("config", "sprite").capitalize()
	OS.set_window_maximized(true)

func update_settings():
	configs.load("user://skyworld.cfg")
	current_level = configs.get_value("config", "level")
	sprite = configs.get_value("config", "sprite").capitalize()
	volume = float(configs.get_value("config", "volume")) / 100
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear2db(volume))
