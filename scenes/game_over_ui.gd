class_name GameOverUI
extends Node

signal retry
signal title

@export var level_label: Label
@export var sub_destroyed_label: Label
@export var time_label: Label
@export var retry_button: TextureButton
@export var title_button: TextureButton


func _ready():
	retry_button.pressed.connect(on_retry)
	title_button.pressed.connect(func(): title.emit())


func on_retry():
	retry.emit()
	queue_free()


func set_ui(level: int, sub: int, time: int):
	level_label.text = "Level: " + str(level)
	sub_destroyed_label.text = "Sub Destroyed: " + str(sub)
	var minutes: int = floori(time / 60)
	var seconds: int = time % 60
	var second_txt: String = str(seconds) if seconds / 10 > 0 else "0" + str(seconds)
	time_label.text = "Time: " + str(minutes) + ":" + second_txt
