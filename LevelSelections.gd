extends Control
const Settings = preload("res://LoadSettings.gd")

func _ready():
	pass



func _on_Level1_pressed():
	get_tree().change_scene("res://GameScene.tscn")

func _on_Level2_pressed():
	get_tree().change_scene("res://GameScene2.tscn")


func _on_Level3_pressed():
	get_tree().change_scene("res://GameScene3.tscn")
