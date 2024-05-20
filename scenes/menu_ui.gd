class_name MenuUI
extends Control

signal start_game
signal credit

@export var title: TextureRect
@export var start_button: TextureButton
@export var credit_button: TextureButton
@export var quit_button: TextureButton
@export var timer: Timer
var title_counter: int = 0:
	set(value):
		title_counter = value
		title.texture.region = Rect2(0, title_counter * 100, 200, 100)
var is_forward: bool = true


func _ready():
	start_button.pressed.connect(on_start_button_pressed)
	credit_button.pressed.connect(func(): credit.emit())
	quit_button.pressed.connect(func(): get_tree().quit())
	timer.timeout.connect(animate_title)


func on_start_button_pressed():
	start_game.emit()
	queue_free()


func animate_title():
	if title_counter == 0 && !is_forward:
		is_forward = true
	elif title_counter == 2 && is_forward:
		is_forward = false
	if is_forward:
		title_counter += 1
	else:
		title_counter -= 1
