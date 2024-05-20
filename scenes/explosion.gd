class_name Explosion
extends AnimatedSprite2D


func _ready():
	animation_finished.connect(func(): queue_free())
