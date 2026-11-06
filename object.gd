extends Node2D

@onready var traffic_sprite: AnimatedSprite2D = $AnimatedSprite2D

const tile_size = Vector2(16,16)
var mouse_position: Vector2
var draggable = false
var offset: Vector2

func _ready():
	traffic_sprite.play("default")
	
func _process(delta):
	if draggable:
		if Input.is_action_just_pressed("click"):
			offset = get_global_mouse_position() - global_position
			traffic_sprite.play("icon")
			Drag.is_dragging = true
		if Input.is_action_pressed("click"):
			mouse_position = get_global_mouse_position() - (tile_size/2 +offset)
			global_position = mouse_position.snapped(tile_size)
		elif Input.is_action_just_released("click"):
			Drag.is_dragging = false


func _on_area_2d_body_entered(body: StaticBody2D):
	if body.is_in_group('safe'):
		Drag.is_safe = true
		print("we re safe")


func _on_area_2d_body_exited(body: StaticBody2D):
	if body.is_in_group('safe'):
		Drag.is_safe = false
		print("we re not safe")


func _on_area_2d_mouse_entered():
	if not Drag.is_dragging:
		draggable = true


func _on_area_2d_mouse_exited():
	if not Drag.is_dragging:
		draggable = false
