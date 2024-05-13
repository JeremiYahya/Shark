class_name Shark
extends CharacterBody2D

@export var speed: float = 300
@export var max_hp: float = 3
@export var hp: float = 3:
	set(value):
		hp = value
		if hp <= 0:
			queue_free()
var mouse_position


func _physics_process(delta):
	move()
	check_collision()


func move():
	mouse_position = get_global_mouse_position()
	var distance = mouse_position - position
	if distance.length() >= 2:
		var direction = distance.normalized()
		velocity = direction * speed
		move_and_slide()
	else:
		position = mouse_position
	look_at(mouse_position)


func check_collision():
	if get_slide_collision_count() > 0:
		for i in get_slide_collision_count():
			var obj = get_slide_collision(i).get_collider()
			if obj.collision_layer == 2:
				obj.queue_free()
