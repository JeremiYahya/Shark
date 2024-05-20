extends CharacterBody2D

@export var speed = 150
@export var homing_timer: Timer
@export var active_timer: Timer
@export var enable_collider_timer: Timer
var target: Shark
var audio: Node
var entity_containers: Node
var prev_direction: Vector2 = Vector2.RIGHT
var has_been_hit: bool = false
var explosion_sfx: PackedScene = preload("res://audio/explosion.tscn")
var explosion_anim: PackedScene = preload("res://scenes/explosion.tscn")


func _ready():
	audio = get_node("/root/Main/Audio")
	entity_containers = get_node("/root/Main/Game/EntityContainers")
	target = get_node("/root/Main/Game/EntityContainers/Shark")
	prev_direction = Vector2()
	active_timer.timeout.connect(func(): queue_free())
	enable_collider_timer.timeout.connect(func(): $CollisionShape2D.set_deferred("disabled", false))


func _physics_process(_delta):
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
