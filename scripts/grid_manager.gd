class_name GridManager
extends Node2D

const GRID_SIZE = Vector2i(6, 6)
const CELL_SIZE = 64  # pixels

var grid: Array = []  # 2D array of card references
var player_position: Vector2i = Vector2i(0, 0)

signal card_revealed(card_data: CardData)

func _ready():
	initialize_grid()

func initialize_grid():
	grid.clear()
	for y in range(GRID_SIZE.y):
		var row = []
		for x in range(GRID_SIZE.x):
			row.append(null)
		grid.append(row)

func grid_to_world(grid_pos: Vector2i) -> Vector2:
	# Center the grid on screen
	var offset = Vector2(
		(get_viewport_rect().size.x - GRID_SIZE.x * CELL_SIZE) / 2,
		(get_viewport_rect().size.y - GRID_SIZE.y * CELL_SIZE) / 2
	)
	return Vector2(grid_pos.x * CELL_SIZE, grid_pos.y * CELL_SIZE) + offset + Vector2(CELL_SIZE/2, CELL_SIZE/2)

func world_to_grid(world_pos: Vector2) -> Vector2i:
	var offset = Vector2(
		(get_viewport_rect().size.x - GRID_SIZE.x * CELL_SIZE) / 2,
		(get_viewport_rect().size.y - GRID_SIZE.y * CELL_SIZE) / 2
	)
	var adjusted = world_pos - offset
	return Vector2i(int(adjusted.x / CELL_SIZE), int(adjusted.y / CELL_SIZE))

func is_valid_position(grid_pos: Vector2i) -> bool:
	return grid_pos.x >= 0 and grid_pos.x < GRID_SIZE.x \
	   and grid_pos.y >= 0 and grid_pos.y < GRID_SIZE.y

func get_card_at(grid_pos: Vector2i):
	if is_valid_position(grid_pos):
		return grid[grid_pos.y][grid_pos.x]
	return null

func set_card_at(grid_pos: Vector2i, card):
	if is_valid_position(grid_pos):
		grid[grid_pos.y][grid_pos.x] = card

func get_adjacent_positions(grid_pos: Vector2i) -> Array[Vector2i]:
	var adjacent: Array[Vector2i] = []
	var directions = [Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT]

	for dir in directions:
		var pos = grid_pos + dir
		if is_valid_position(pos):
			adjacent.append(pos)

	return adjacent

func clear_grid():
	for y in range(GRID_SIZE.y):
		for x in range(GRID_SIZE.x):
			var card = grid[y][x]
			if card:
				card.queue_free()
			grid[y][x] = null
