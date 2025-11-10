extends Node2D

var grid_position: Vector2i = Vector2i(0, 0)
var is_moving: bool = false
var grid_manager: GridManager

@onready var animated_sprite = $AnimatedSprite2D

signal moved(old_pos: Vector2i, new_pos: Vector2i)

func _ready():
	# Will be set by main scene
	pass

func setup(start_pos: Vector2i, manager: GridManager):
	grid_position = start_pos
	grid_manager = manager
	position = grid_manager.grid_to_world(grid_position)
	show()

func _input(event):
	if is_moving or GameManager.in_combat:
		return

	var direction = Vector2i.ZERO

	if event.is_action_pressed("move_up"):
		direction = Vector2i.UP
	elif event.is_action_pressed("move_down"):
		direction = Vector2i.DOWN
	elif event.is_action_pressed("move_left"):
		direction = Vector2i.LEFT
	elif event.is_action_pressed("move_right"):
		direction = Vector2i.RIGHT

	if direction != Vector2i.ZERO:
		try_move(direction)

func try_move(direction: Vector2i):
	var new_pos = grid_position + direction

	if grid_manager.is_valid_position(new_pos):
		await move_to(new_pos)

func move_to(new_grid_pos: Vector2i):
	is_moving = true
	var old_pos = grid_position
	grid_position = new_grid_pos

	var target_world_pos = grid_manager.grid_to_world(grid_position)

	# Animate movement
	if animated_sprite:
		animated_sprite.play()

	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "position", target_world_pos, 0.2)

	await tween.finished

	if animated_sprite:
		animated_sprite.stop()

	is_moving = false
	moved.emit(old_pos, grid_position)

	# Reveal card at new position
	var card = grid_manager.get_card_at(grid_position)
	if card and not card.is_revealed:
		card.reveal()
