extends CharacterBody2D

const SPEED = 200.0
var direction = 1
var tm

func _process(delta):
	tm = delta
	position.y += direction * SPEED * delta
	if position.y < 230:
		direction = 1
	if position.y > 434:
		direction = -1


func _on_object_traffic_switched():
	await get_tree().create_timer(0.6).timeout
	position.y += SPEED * tm * 3.5
