#only works for LEVEL 1
#clear condition: if traffic object is inside safe zone

extends Node2D

@onready var traffic_sprite: AnimatedSprite2D = $AnimatedSprite2D #ref to sprite for changing to icon mode

const tile_size = Vector2(16,16) #for snapping
var mouse_position: Vector2

var draggable = false #changes depending on if mouse is inside body or not
var offset: Vector2 #offset between global object position and mouse position

#on game start
func _ready():
	traffic_sprite.play("default")
	
	
func _process(delta):
	if draggable: #checks if mouse is in area body, prevents dragging from outside
		if Input.is_action_just_pressed("click"):
			offset = get_global_mouse_position() - global_position #calculates offset
			traffic_sprite.play("icon") #transforms into icon sprite
			Drag.is_dragging = true #global is_dragging var
		if Input.is_action_pressed("click"):
			mouse_position = get_global_mouse_position() - (tile_size/2 +offset) #applies offset and fixes snapping thoda
			global_position = mouse_position.snapped(tile_size) #actual position code
		elif Input.is_action_just_released("click"):
			Drag.is_dragging = false 


func _on_area_2d_body_entered(body: StaticBody2D): 
	if body.is_in_group('safe'): #safe is a group, scene safezone is 'safe'
		Drag.is_safe = true #global variable to signal object is in safe zone (aka level will clear)
		print("we re safe") #just for my reference, not important


func _on_area_2d_body_exited(body: StaticBody2D):
	if body.is_in_group('safe'):
		Drag.is_safe = false
		print("we re not safe")


func _on_area_2d_mouse_entered(): #connected to area2d in object, signals when mouse enters collision shape
	if not Drag.is_dragging: #for smooth movement
		draggable = true


func _on_area_2d_mouse_exited():
	if not Drag.is_dragging:
		draggable = false
