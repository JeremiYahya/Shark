extends AudioStreamPlayer


func _ready():
	finished.connect(func(): queue_free())
