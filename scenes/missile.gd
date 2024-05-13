extends CharacterBody2D

@export var speed = 150
@export var homing_timer: Timer
@export var active_timer: Timer
var target: Shark
var prev_direction: Vector2


func _ready():
	target = get_node("/root/Main/Game/Shark")
	prev_direction = Vector2()
	active_timer.timeout.connect(func(): queue_free())


func _physics_process(delta):
	move()
	check_collision()


func move():
	if target != null:
		if !homing_timer.is_stopped():
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


func check_collision():
	if get_slide_collision_count() > 0:
		for i in get_slide_collision_count():
			var obj = get_slide_collision(i).get_collider()
			if obj.collision_layer == 1:
				obj.hp -= 1
				queue_free()
