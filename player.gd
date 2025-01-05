extends CharacterBody2D

# Movement parameters
const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Screen dimensions
const SCREEN_WIDTH = 1152
const SCREEN_HEIGHT = 648

# Physics parameters
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Duplicate sprite for wrapping
var duplicate_sprite: Sprite2D

func _ready():
	# Create duplicate sprite for wrapping
	duplicate_sprite = Sprite2D.new()
	duplicate_sprite.texture = $Sprite2D.texture
	duplicate_sprite.scale = $Sprite2D.scale
	add_child(duplicate_sprite)
	duplicate_sprite.hide()

func _physics_process(delta):
	# Add gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# Handle jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Get movement direction
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	# Move character
	move_and_slide()
	
	# Handle screen wrapping
	handle_screen_wrap()

func handle_screen_wrap():
	var sprite_width = $Sprite2D.texture.get_width() * $Sprite2D.scale.x
	var sprite_height = $Sprite2D.texture.get_height() * $Sprite2D.scale.y
	# cheese 
	# Wrap horizontally
	if position.x < -sprite_width / 2:
		position.x += SCREEN_WIDTH + sprite_width
	elif position.x > SCREEN_WIDTH - sprite_width / 2:
		position.x -= SCREEN_WIDTH + sprite_width
	
	# Wrap vertically (if needed)
	if position.y < -sprite_height / 2:
		position.y += SCREEN_HEIGHT + sprite_height
	elif position.y > SCREEN_HEIGHT - sprite_height / 2:
		position.y -= SCREEN_HEIGHT + sprite_height
	
	# Update duplicate sprite position
	duplicate_sprite.global_position = global_position
	
	# Show/hide duplicate sprite based on wrapping
	var wrap_threshold = sprite_width * 0.1  # Adjust this value as needed
	if position.x < -wrap_threshold or position.x > SCREEN_WIDTH - wrap_threshold:
		duplicate_sprite.show()
		if position.x < -wrap_threshold:
			duplicate_sprite.global_position.x += SCREEN_WIDTH
		else:
			duplicate_sprite.global_position.x -= SCREEN_WIDTH
	else:
		duplicate_sprite.hide()

func _exit_tree():
	# Clean up duplicate sprite when player is removed
	if duplicate_sprite:
		duplicate_sprite.queue_free()
