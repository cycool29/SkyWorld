extends Node
#const Settings = preload("res://LoadSettings.gd")

var configs = ConfigFile.new()
var err = configs.load("user://skyworld.cfg")
var sprite = configs.get_value('config', 'sprite').capitalize()

	
func _ready():
	pass
	
func _process(delta):
	var err = configs.load("user://skyworld.cfg")
	var sprite = configs.get_value('config', 'sprite').capitalize()

