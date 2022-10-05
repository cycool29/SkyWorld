extends KinematicBody2D
#const Settings = preload("res://LoadSettings.gd")

var velocity = Vector2()
var direction = 1
export(String, "Timer", "Collide") var moving_way = "Timer"
onready var initial_y = position.y
onready var initial_x = position.x

func _ready():
	if moving_way == 'Timer':
		$Timer.start()



func _process(delta):
	velocity.x = 50 * direction # get negative if times with -1 and get positive if times with 1 
	move_and_slide(velocity, Vector2.UP)
	
	if moving_way == 'Collide':
		for index in get_slide_count():
			var collision := get_slide_collision(index)
			var body := collision.collider
			if body.name == 'TileMapSolid':
				direction *= -1
	position.y = initial_y
	
func _on_Timer_timeout():
	direction *= -1
	$Timer.start()
