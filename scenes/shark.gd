class_name Shark
extends CharacterBody2D

@export var speed: float = 200
var mouse_position

func _physics_process(delta):
	mouse_position = get_global_mouse_position()
	var distance = mouse_position - position
	if distance.length() >= 2:
		var direction = distance.normalized()
		velocity = direction * speed
		move_and_slide()
	else:
		position = mouse_position
	look_at(mouse_position)
