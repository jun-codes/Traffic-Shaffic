extends PathFollow2D

var speed = 0.1
# Called when the node enters the scene tree for the first time.
func _process(delta):
	progress_ratio += delta * speed
