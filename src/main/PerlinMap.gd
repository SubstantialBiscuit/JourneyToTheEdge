extends Node2D


export var MAP_SIZE := Vector2(5000, 5000)
const NOISE_FACTOR := 100
var noise = OpenSimplexNoise.new()
onready var sprite := get_node("Sprite")


# Called when the node enters the scene tree for the first time.
func _ready():
	noise.seed = randi()
	noise.octaves = 2
	noise.period = 10
	
	var image = noise.get_image(MAP_SIZE.x / NOISE_FACTOR, MAP_SIZE.y / NOISE_FACTOR)
	image.lock()
	image.resize(MAP_SIZE.x, MAP_SIZE.y)
	var texture = ImageTexture.new()
	texture.create_from_image(image)
	sprite.set("texture", texture)
