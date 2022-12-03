extends Control

func _ready():
	$AnimationPlayer.play("fade")

func _process(delta):
	if not $AnimationPlayer.is_playing() and get_node("ColorRect"):
		$ColorRect.queue_free()

func _on_HomeButton_pressed():
	$ButtonClickedSound.play()
	yield(get_tree().create_timer(0.3), "timeout")
	get_tree().change_scene("res://MainMenu.tscn")
