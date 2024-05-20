class_name PreGameUI
extends Control

@export var timer: Timer
@export var ready_set_go: TextureRect
var counter: int = 0:
	set(value):
		counter = value
		if counter < 3:
			ready_set_go.texture.region = Rect2(0, counter * 60, 100, 60)
			if counter == 2:
				var sfx = splash_sfx.instantiate()
				audio.add_child(sfx)
			else:
				var sfx = tick_sfx.instantiate()
				audio.add_child(sfx)
		else:
			queue_free()
var tick_sfx: PackedScene = preload("res://audio/tick.tscn")
var splash_sfx: PackedScene = preload("res://audio/splash.tscn")
var audio: Node


func _ready():
	audio = get_node("/root/Main/Audio")
	timer.timeout.connect(func(): counter += 1)
	var sfx = tick_sfx.instantiate()
	audio.add_child(sfx)
