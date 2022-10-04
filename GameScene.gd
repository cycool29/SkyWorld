extends Node2D
const Settings = preload("res://LoadSettings.gd")

func _ready():
	get_node(Settings.sprite).visible = true
	if Settings.sprite == 'Jessie':
		get_node("Marcus").queue_free()
	elif Settings.sprite == 'Marcus':
		get_node("Jessie").queue_free()
