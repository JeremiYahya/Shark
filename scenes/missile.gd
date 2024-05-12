extends CharacterBody2D

@export var speed = 150
@export var timer: Timer
var target: Shark
var prev_direction: Vector2


func _ready():
	target = get_node("/root/Main/Game/Shark")


func _physics_process(delta):
	if target:
		if !timer.is_stopped():
			var distance = target.position - position
			if distance.length() >= 2:
				var direction = distance.normalized()
				velocity = direction * speed
				move_and_slide()
				prev_direction = direction
			look_at(target.position)
		else:
			velocity = prev_direction * speed
			move_and_slide()
