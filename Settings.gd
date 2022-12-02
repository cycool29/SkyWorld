extends Node

var configs = ConfigFile.new()	
var err = configs.load("user://skyworld.cfg")
var sprite = ''
var current_level = 0
var volume = 1

func _ready():
	if err != OK:
		print('failed')
		current_level = 1
		sprite = 'Marcus'
		volume = 80.0
		configs.set_value("config", "sprite", 'marcus')
		configs.set_value("config", "level", "1")
		configs.set_value("config", "volume", "100")

		# Save it to a file (overwrite if already exists).
		configs.save("user://skyworld.cfg")
		OS.window_fullscreen = true

func update_settings():
	configs.load("user://skyworld.cfg")
	current_level = configs.get_value("config", "level")
	sprite = configs.get_value("config", "sprite").capitalize()
	volume = float(configs.get_value("config", "volume")) / 100
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear2db(volume))
