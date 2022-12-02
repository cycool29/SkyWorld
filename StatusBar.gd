extends CanvasLayer


func _ready():
	get_node("Panel")

func _process(delta):
	$Panel.rect_size.x = $Label.rect_size.x + 20
	$Panel.rect_position.x = 960 - $Panel.rect_size.x / 2
	$Label.rect_position.x = 960 - $Label.rect_size.x / 2

