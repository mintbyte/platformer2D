extends AnimatableBody2D  # Changed from StaticBody2D

var move_speed = 150
var move_direction = 1
var move_limit = 100
var start_position = Vector2.ZERO

func _ready():
	start_position = position

func _physics_process(delta):  # Changed from _process to _physics_process
	# Move the platform
	position.x += move_speed * move_direction * delta
	
	# Check if we've gone too far right
	if position.x > start_position.x + move_limit:
		move_direction = -1
	
	# Check if we've gone too far left
	if position.x < start_position.x - move_limit:
		move_direction = 1

func get_speed():
	return move_speed * move_direction
