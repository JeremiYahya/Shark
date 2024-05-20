class_name Shark
extends CharacterBody2D

signal eat_sub
signal hp_changed(max_hp: int, hp: int)
signal level_up(level: int)

@export var speed: float = 300
@export var dash_speed: float = 400
@export var dash_decel: float = 400
@export var max_hp: int = 3:
	set(value):
		max_hp = value
		hp_changed.emit(max_hp, hp)
@export var hp: int = 3:
	set(value):
		if value < hp:
			hp = value
			if hp <= 0:
				is_dead = true
				anim.play("dead")
				$CollisionShape2D.set_deferred("disabled", true)
			else:
				anim.play("hurt")
		else:
			hp = clamp(value, 0, max_hp)
		hp_changed.emit(max_hp, hp)
@export var stun_timer: Timer
@export var dash_timer: Timer
@export var anim: AnimatedSprite2D
var extra_speed: float = 0
var level: int = 0:
	set(value):
		level = value
		level_up.emit(level)
var xp_requirement: int = 1
var xp: int = 0
var audio: Node
var entity_containers: Node
var crunch_sfx: PackedScene = preload("res://audio/crunch.tscn")
var dash_sfx: PackedScene = preload("res://audio/dash.tscn")
var explosion: PackedScene = preload("res://scenes/explosion.tscn")
var mouse_position
var is_stunned: bool = false:
	set(value):
		is_stunned = value
		if is_stunned:
			stun_timer.start()
		speed = 0 if is_stunned else 300
var is_dead: bool = false


func _ready():
	audio = get_node("/root/Main/Audio")
	entity_containers = get_node("/root/Main/Game/EntityContainers")
	anim.animation_finished.connect(on_animation_finished)
	stun_timer.timeout.connect(func(): is_stunned = false)
	anim.play("idle")
	hp_changed.emit(max_hp, hp)


func _physics_process(delta):
	if name != "Shark":
		name = "Shark"
	if !is_dead:
		move(delta)
		check_dash()
		check_collision()
	else:
		floating()


func move(delta: float):
	mouse_position = get_global_mouse_position()
	var distance = mouse_position - position
	if distance.length() >= 3:
		var direction = distance.normalized()
		velocity = direction * (speed + extra_speed)
		move_and_slide()
	else:
		position = mouse_position
	anim.flip_h = velocity.x < 0
	extra_speed = clamp(extra_speed - dash_decel * delta, 0, 1000)


func floating():
	velocity = Vector2.UP * 50
	move_and_slide()


func check_dash():
	if Input.is_action_just_pressed("dash") && dash_timer.is_stopped():
		var sfx = dash_sfx.instantiate()
		audio.add_child(sfx)
		extra_speed += dash_speed
		dash_timer.start()


func check_collision():
	if get_slide_collision_count() > 0:
		for i in get_slide_collision_count():
			var obj = get_slide_collision(i).get_collider()
			if obj != null && obj.collision_layer == 2 && !obj.is_dead:
				var _explosion = explosion.instantiate()
				entity_containers.add_child(_explosion)
				_explosion.position = obj.position
				obj.is_dead = true
				obj.queue_free()
				anim.play("eat")
				var sfx = crunch_sfx.instantiate()
				audio.add_child(sfx)
				gain_xp(1)


func on_animation_finished():
	if anim.animation == "eat":
		anim.play("idle")
	elif anim.animation == "hurt":
		anim.play("idle")


func gain_xp(value: int):
	xp += value
	eat_sub.emit()
	if xp >= xp_requirement:
		level += 1
		xp -= xp_requirement
		hp += 1
		if level % 2 == 0:
			xp_requirement += 1
