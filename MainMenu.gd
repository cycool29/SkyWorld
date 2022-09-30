extends Control

func _ready():
	pass


func _on_StartButton_pressed():
	 get_tree().change_scene('res://GameScene.tscn')


func _on_HelpButton_pressed():
	 get_tree().change_scene('res://HelpMenu.tscn')


func _on_QuitButton_pressed():
	get_tree().quit()

