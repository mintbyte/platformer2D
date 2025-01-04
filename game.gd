extends Node2D

# Screen dimensions
const SCREEN_WIDTH = 1152
const SCREEN_HEIGHT = 648

# Wall settings
const WALL_WIDTH = 32
const WALL_HEIGHT = 32  # Made smaller to be less obtrusive
const WALL_COLOR = Color(0.6, 0.4, 0.2)

# Scene references
var wall_scene: PackedScene

func _ready():
	create_wall_scene()
	create_screen_bounds()

func create_wall_scene():
	# Create the wall scene structure
	var wall = StaticBody2D.new()
	wall.name = "Wall"
	
	# Create collision shape
	var collision = CollisionShape2D.new()
	var shape = RectangleShape2D.new()
	shape.size = Vector2(WALL_WIDTH, WALL_HEIGHT)
	collision.shape = shape
	wall.add_child(collision)
	
	# Create sprite
	var sprite = Sprite2D.new()
	var img = Image.create(WALL_WIDTH, WALL_HEIGHT, false, Image.FORMAT_RGBA8)
	img.fill(WALL_COLOR)
	var texture = ImageTexture.create_from_image(img)
	sprite.texture = texture
	wall.add_child(sprite)
	
	# Save as scene
	wall_scene = PackedScene.new()
	wall_scene.pack(wall)

func spawn_wall(position: Vector2) -> StaticBody2D:
	var wall_instance = wall_scene.instantiate()
	wall_instance.position = position
	add_child(wall_instance)
	return wall_instance

func create_screen_bounds():
	# Create floor
	for x in range(0, SCREEN_WIDTH, WALL_WIDTH):
		spawn_wall(Vector2(x, SCREEN_HEIGHT - WALL_HEIGHT))
	
	# Create a few platforms (adjust positions as needed)
	var platform_positions = [
		Vector2(300, 450),  # Middle platform
		Vector2(600, 350),  # Upper platform
		Vector2(100, 500)   # Lower platform
	]
	
	for pos in platform_positions:
		spawn_wall(pos)

func remove_wall(wall: StaticBody2D):
	if is_instance_valid(wall):
		wall.queue_free()

func clear_all_walls():
	for wall in get_tree().get_nodes_in_group("walls"):
		remove_wall(wall)

# Removed mouse input handling to prevent accidental wall creation
