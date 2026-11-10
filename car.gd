extends CharacterBody2D

@export var tilemap_layer: TileMapLayer
@export var speed: float = 200.0
@export var tile_size: float = 20.0

@onready var pause: Button = $"../pause"

var current_direction: Vector2 = Vector2.ZERO
var last_cell := Vector2i(-999, -999)

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

func _physics_process(_delta: float) -> void:
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

func update_direction_from_tile() -> void:
	# Use the body's position, not the sprite's
	var cell = tilemap_layer.local_to_map(tilemap_layer.to_local(global_position))
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
