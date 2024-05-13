class_name Main
extends Node

@export var ui: UI
var score: float = 0


func _ready():
	pass # Replace with function body.


func _process(delta):
	score += delta
	var scorei: int = floori(score)
	ui.set_score_display(str(scorei))
