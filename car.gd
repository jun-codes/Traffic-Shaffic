extends CharacterBody2D

@export var tilemap_layer: TileMapLayer
@export var speed: float = 200.0
@export var tile_size: float = 20.0
@export var look_offset: float = -77.0   # negative = turn later, positive = turn earlier
@export var sprite_angle_offset: float = 0.0   # radians
@onready var pause: Button = $"../pause"
@onready var car: AnimatedSprite2D = $AnimatedSprite2D

var anim_played := false   # member variable
var current_direction: Vector2 = Vector2.ZERO
var last_cell := Vector2i(-999, -999)
var previous_direction: Vector2 = Vector2.ZERO
@export var anim_look_offset: float = -35.0   # when the turn animation starts
@export var turn_anim_speed: float = 3    # 1.0 = normal, 2.0 = twice as fast

var last_anim_cell := Vector2i(-999, -999)

func pause1() -> void:
	get_tree().paused = true

func resume() -> void:
	get_tree().paused = false

func _ready() -> void:
	# The button must keep working while the tree is paused
	pause.icon = load("res://icons/multimedia-play-icon-circle-button-svgrepo-com.svg")

	if tilemap_layer == null:
		tilemap_layer = get_node("/root/Level 1/Roads")

	var cell = tilemap_layer.local_to_map(tilemap_layer.to_local(global_position))
	if tilemap_layer.get_cell_tile_data(cell) == null:
		var start_cell = tilemap_layer.get_used_cells()[0]
		global_position = tilemap_layer.to_global(tilemap_layer.map_to_local(start_cell))
		print("Snapped car to road cell: ", start_cell)

	print(tilemap_layer.get_path(), " used: ", tilemap_layer.get_used_rect())
	pause1()
const CAR_FRAME_1 = preload("uid://byemc865ryo1x")

func _physics_process(delta: float) -> void:
	update_direction_from_tile()
	velocity = current_direction * speed
	move_and_slide()

func _on_pause_toggled(toggled_on: bool) -> void:
	if toggled_on:
		pause.icon = load("res://icons/pause-button-svgrepo-com.svg")
		update_direction_from_tile()
		resume()
	else:
		pause.icon = load("res://icons/multimedia-play-icon-circle-button-svgrepo-com.svg")
		pause1()


const TURNS := {
	"RU": [0, false],   "UL": [-90, false],
	"LD": [-180, false], "DR": [-270, false],
	"LU": [0, true],    "DL": [-90, true],
	"RD": [-180, true],  "UR": [-270, true],
}

func update_car_turn() -> void:
	if current_direction == previous_direction:
		return
	car.play("run")

	previous_direction = current_direction
	
	
func update_direction_from_tile() -> void:
	# --- direction probe: decides WHEN the car turns ---
	var probe = global_position + current_direction * look_offset
	var cell = tilemap_layer.local_to_map(tilemap_layer.to_local(probe))
	var data = tilemap_layer.get_cell_tile_data(cell)

	if cell != last_cell:
		last_cell = cell
		print("cell ", cell, " dir=", data.get_custom_data("direction") if data else "none")

	if data:
		var value := str(data.get_custom_data("direction")).strip_edges().to_upper()
		match value.substr(value.length() - 1, 1):
			"U": current_direction = Vector2.UP
			"D": current_direction = Vector2.DOWN
			"L": current_direction = Vector2.LEFT
			"R": current_direction = Vector2.RIGHT

	# --- animation probe: decides WHEN the turn animation starts ---
	var anim_probe = global_position + current_direction * anim_look_offset
	var anim_cell = tilemap_layer.local_to_map(tilemap_layer.to_local(anim_probe))
	var anim_data = tilemap_layer.get_cell_tile_data(anim_cell)

	var anim_key := ""
	if anim_data:
		var v := str(anim_data.get_custom_data("direction")).strip_edges().to_upper()
		if v.length() >= 2:
			anim_key = v.substr(0, 1) + v.substr(v.length() - 1, 1)

	if TURNS.has(anim_key):
		if not anim_played:
			anim_played = true
			car.rotation_degrees = TURNS[anim_key][0]
			car.flip_h = TURNS[anim_key][1]
			car.play("turn", turn_anim_speed)
	else:
		anim_played = false 
