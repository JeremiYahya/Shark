extends Node2D

@export var bubble_timer: Timer
var bubble: PackedScene = preload("res://scenes/bubble.tscn")


func _ready():
	bubble_timer.timeout.connect(summon_bubble)

func _process(_delta):
	if bubble_timer.is_stopped():
		bubble_timer.wait_time = randf_range(0.5, 1.5)
		bubble_timer.start()


func summon_bubble():
	var obj = bubble.instantiate()
	add_child(obj)
	obj.position = Vector2(randf_range(0, get_viewport_rect().size.x), get_viewport_rect().size.y + 100)
