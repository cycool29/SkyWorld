extends Camera2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var player = get_node('/root/GameScene/Player')


func _process(delta: float) -> void:
	position.x = player.position.x
	

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
