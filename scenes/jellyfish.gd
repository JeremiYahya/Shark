extends Area2D

@export var active_timer: Timer
var velocity: float = 100
var target_pos: Vector2
var explosion_sfx: PackedScene = preload("res://audio/explosion.tscn")
var explosion_anim: PackedScene = preload("res://scenes/explosion.tscn")
var audio: Node
var entity_containers: Node


func _ready():
	audio = get_node("/root/Main/Audio")
	entity_containers = get_node("/root/Main/Game/EntityContainers")
	active_timer.timeout.connect(func(): queue_free())
	body_entered.connect(on_hit)


func _process(delta):
	swim(delta)


func swim(delta: float):
	position = Vector2(position.x, position.y - velocity * delta)


func on_hit(body: Node2D):
	if body.collision_layer == 1 && !body.is_stunned:
		body.is_stunned = true
	elif body.collision_layer == 2:
		var _explosion = explosion_anim.instantiate()
		entity_containers.add_child(_explosion)
		_explosion.position = position
		var sfx = explosion_sfx.instantiate()
		audio.add_child(sfx)
		body.queue_free()
		queue_free()
