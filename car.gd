extends CharacterBody2D

const max_speed = 100
const accel = 1200
const friction = 600

var input = Vector2.ZERO
@onready var pause: Button = $"../pause"

func pause1():
	get_tree().paused = true

func resume():
	get_tree().paused = false

func _ready() -> void:
	pause1()
	Input.action_press("ui_right")
		

func _physics_process(delta):
	car_movement(delta)
	
func get_input():
	input.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	input.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	return input.normalized()

func car_movement(delta):
	input = get_input()
	
	if input == Vector2.ZERO:
		if velocity.length() > (friction * delta):
			velocity -= velocity.normalized() * (friction * delta)
		else:
			velocity = Vector2.ZERO
	else:
		velocity += (input * accel * delta)
		velocity = velocity.limit_length(max_speed)
		
	move_and_slide()
	
	
func _on_pause_toggled(toggled_on: bool):
	if toggled_on == true:
		pause.icon = load(	"res://icons/pause-button-svgrepo-com.svg")
		resume()
	elif toggled_on == false:
		pause.icon = load("res://icons/multimedia-play-icon-circle-button-svgrepo-com.svg")
		pause1()
					
