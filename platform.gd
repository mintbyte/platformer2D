extends StaticBody2D


var move_speed = 100  # How fast the platform moves
var move_direction = 1  # Which way it's moving (1 for right, -1 for left)
var move_limit = 100  # How far it moves each way
var start_position = Vector2.ZERO

func _ready():
	# Save the starting position when the game begins
	start_position = position

func _process(delta):
	# Move the platform
	position.x += move_speed * move_direction * delta
	
	# Check if we've gone too far right
	if position.x > start_position.x + move_limit:
		move_direction = -1  # Start moving left
	
	# Check if we've gone too far left
	if position.x < start_position.x - move_limit:
		move_direction = 1   # Start moving right

func get_speed():
	return move_speed * move_direction
