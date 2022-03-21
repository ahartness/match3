extends Node2D

# Grid Variables
export (int) var width
export (int) var height
export (int) var x_start
export (int) var y_start
export (int) var offset

# load in different colored pieces
var possible_pieces = [
	preload("res://Scenes/blue_piece.tscn"),
	preload("res://Scenes/yellow_piece.tscn"),
	preload("res://Scenes/green_piece.tscn"),
	preload("res://Scenes/light_green_piece.tscn"),
	preload("res://Scenes/orange_piece.tscn"),
	preload("res://Scenes/pink_piece.tscn")
]

var all_pieces = [];

# Touch Coordinate Variables
var first_touch = Vector2(0, 0)
var final_touch = Vector2(0, 0)
var controlling = false

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	all_pieces = setup_2d_array()
	spawn_pieces()

func setup_2d_array():
	var array = []
	for i in width:
		array.append([])
		for j in height:
			array[i].append(null)
	return array

func match_at(i, j, color):
	if i > 1:
		if all_pieces[i - 1][j] != null && all_pieces[i - 2][j] != null:
			if all_pieces[i - 1][j].color == color && all_pieces[i - 2][j].color == color:
				return true
	if j > 1:
		if all_pieces[i][j - 1] != null && all_pieces[i][j - 2] != null:
			if all_pieces[i][j - 1].color == color && all_pieces[i][j - 2].color == color:
				return true


func spawn_pieces():
	for i in width:
		for j in height:
			# Choose a random number between 0 and number of possible pieces
			var rand = floor(rand_range(0, possible_pieces.size()))
			var piece = possible_pieces[rand].instance()
			var loops = 0
			while(match_at(i, j, piece.color) && loops < 50):
				rand = floor(rand_range(0, possible_pieces.size()))
				loops += 1
				piece = possible_pieces[rand].instance()
			# Instance that piece from array
			add_child(piece)
			piece.position = grid_to_pixel(i, j)
			all_pieces[i][j] = piece

func grid_to_pixel(column, row):
	var new_x = x_start + offset * column
	var new_y = y_start + -offset * row
	return Vector2(new_x, new_y)

func pixel_to_grid(pixel_x, pixel_y):
	var new_x = round((pixel_x - x_start) / offset)
	var new_y = round((pixel_y - y_start) / -offset)
	return Vector2(new_x, new_y)

func touch_input():
	if Input.is_action_just_pressed("ui_touch"):
		first_touch = get_global_mouse_position()
		var grid_position = pixel_to_grid(first_touch.x, first_touch.y)
		if is_in_grid(grid_position.x, grid_position.y):
			controlling = true
	if Input.is_action_just_released("ui_touch"):
		final_touch = get_global_mouse_position()
		var final_position = pixel_to_grid(final_touch.x, final_touch.y)
		if is_in_grid(final_position.x, final_position.y) && controlling:
			print("Swiped")

func swap_pieces(piece, direction):
	
	pass

func is_in_grid(column, row):
	if column >= 0 && column < width:
		if row >= 0 && row < height:
			return true
	return false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	touch_input()
