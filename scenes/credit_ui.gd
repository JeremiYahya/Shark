class_name CreditUI
extends Node


func _process(_delta):
	if Input.is_action_just_pressed("close_credits"):
		queue_free()
