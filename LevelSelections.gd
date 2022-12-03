extends Control


func _ready():
	$AnimationPlayer.play("fade")

func _process(delta):
	if not $AnimationPlayer.is_playing() and get_node("ColorRect"):
		$ColorRect.queue_free()

func _on_Level1_pressed():
	$ButtonClickedSound.play()
	yield(get_tree().create_timer(0.3), "timeout")
	get_tree().change_scene("res://GameScene1.tscn")

func _on_Level2_pressed():
	$ButtonClickedSound.play()
	yield(get_tree().create_timer(0.3), "timeout")
	get_tree().change_scene("res://GameScene2.tscn")


func _on_Level3_pressed():
	$ButtonClickedSound.play()
	yield(get_tree().create_timer(0.3), "timeout")
	get_tree().change_scene("res://GameScene3.tscn")
	
	
func _on_Level4_pressed():
	$ButtonClickedSound.play()
	yield(get_tree().create_timer(0.3), "timeout")
	get_tree().change_scene("res://GameScene4.tscn")


func _on_HomeButton_pressed():
	$ButtonClickedSound.play()
	yield(get_tree().create_timer(0.3), "timeout")
	get_tree().change_scene("res://MainMenu.tscn")
