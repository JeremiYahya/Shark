extends Node2D

@export var timer: Timer
var speed: float


func _ready():
	speed = randf_range(80, 200)
	var rand_size = randf_range(1, 2)
	scale = Vector2(rand_size, rand_size)
	timer.timeout.connect(func(): queue_free())

func _process(delta):
	position = Vector2(position.x, position.y - (speed * delta))
