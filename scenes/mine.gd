class_name Mine
extends CharacterBody2D

@export var detonate_timer: Timer
var target_pos: Vector2
var speed: float
var has_been_hit: bool = false
var explosion_sfx: PackedScene = preload("res://audio/explosion.tscn")
var explosion_anim: PackedScene = preload("res://scenes/explosion.tscn")
var audio: Node
var entity_containers: Node


func _ready():
	audio = get_node("/root/Main/Audio")
	entity_containers = get_node("/root/Main/Game/EntityContainers")
	speed = randf_range(50, 100)
	detonate_timer.timeout.connect(self_explode)


func _physics_process(_delta):
	dive()
	check_collision()


func set_random_destination():
	return Vector2(position.x, randf_range(100, get_viewport_rect().size.y - 100))


func dive():
	var distance = target_pos - position
	if distance.length() >= 3:
		var direction = distance.normalized()
		velocity = direction * speed
		move_and_slide()
	elif detonate_timer.is_stopped():
		detonate_timer.start()


func check_collision():
	if get_slide_collision_count() > 0:
		for i in get_slide_collision_count():
			var obj = get_slide_collision(i).get_collider()
			if obj.collision_layer == 1 && !has_been_hit:
				var _explosion = explosion_anim.instantiate()
				entity_containers.add_child(_explosion)
				_explosion.position = position
				has_been_hit = true
				var sfx = explosion_sfx.instantiate()
				audio.add_child(sfx)
				obj.hp -= 1
				queue_free()
			elif (obj.collision_layer == 2 || obj.collision_layer == 4 || obj.collision_layer == 8) && !has_been_hit:
				var _explosion = explosion_anim.instantiate()
				entity_containers.add_child(_explosion)
				_explosion.position = position
				has_been_hit = true
				var sfx = explosion_sfx.instantiate()
				audio.add_child(sfx)
				obj.queue_free()
				queue_free()


func self_explode():
	var _explosion = explosion_anim.instantiate()
	entity_containers.add_child(_explosion)
	_explosion.position = position
	queue_free()
