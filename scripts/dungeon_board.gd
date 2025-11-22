class_name DungeonBoard
extends Control

# Grid configuration
const GRID_SIZE = Vector2i(3, 3)
const CARD_SIZE = Vector2(80, 80)
const CARD_SPACING = 8

# Game state
var player_card: Card
var player_position: Vector2i = Vector2i(1, 1)  # Center of 3x3 grid
var cards: Array = []  # Flat array of all cards on board
var grid: Array = []   # 2D array for position lookup

# Card generation weights (for variety)
var card_weights = {
	CardData.CardType.MONSTER: 40,
	CardData.CardType.WEAPON: 15,
	CardData.CardType.SHIELD: 10,
	CardData.CardType.POTION: 15,
	CardData.CardType.GOLD: 20,
}

signal player_clashed(card_type: CardData.CardType, value: int)
signal turn_completed
signal game_over

func _ready():
	initialize_grid()
	# Don't auto-setup - wait for game start

func initialize_grid():
	grid.clear()
	for y in range(GRID_SIZE.y):
		var row = []
		for x in range(GRID_SIZE.x):
			row.append(null)
		grid.append(row)

func setup_board():
	clear_board()

	# Create player card in center
	player_position = Vector2i(1, 1)
	player_card = create_card(CardData.create_player(), player_position)

	# Fill remaining positions with random cards
	for y in range(GRID_SIZE.y):
		for x in range(GRID_SIZE.x):
			var pos = Vector2i(x, y)
			if pos != player_position:
				var card_data = generate_random_card()
				create_card(card_data, pos)

func clear_board():
	for card in cards:
		if is_instance_valid(card):
			card.queue_free()
	cards.clear()
	initialize_grid()
	player_card = null

func create_card(data: CardData, grid_pos: Vector2i) -> Card:
	var card = Card.new()
	add_child(card)
	card.setup(data, grid_pos)
	card.position = grid_to_screen(grid_pos)
	card.card_clicked.connect(_on_card_clicked)

	cards.append(card)
	grid[grid_pos.y][grid_pos.x] = card

	if data.type == CardData.CardType.PLAYER:
		player_card = card

	return card

func generate_random_card() -> CardData:
	# Calculate total weight
	var total_weight = 0
	for weight in card_weights.values():
		total_weight += weight

	# Pick random based on weight
	var roll = randi() % total_weight
	var current = 0
	var selected_type = CardData.CardType.MONSTER

	for type in card_weights:
		current += card_weights[type]
		if roll < current:
			selected_type = type
			break

	# Create card based on type with scaling values
	var floor_bonus = GameManager.current_floor - 1

	match selected_type:
		CardData.CardType.MONSTER:
			var hp = randi_range(2, 5) + floor_bonus
			var names = ["Slime", "Goblin", "Rat", "Bat", "Spider"]
			return CardData.create_monster(hp, names[randi() % names.size()])
		CardData.CardType.WEAPON:
			var attack = randi_range(2, 4) + floor_bonus / 2
			var names = ["Sword", "Dagger", "Axe"]
			return CardData.create_weapon(attack, names[randi() % names.size()])
		CardData.CardType.SHIELD:
			var defense = randi_range(1, 3) + floor_bonus / 2
			return CardData.create_shield(defense)
		CardData.CardType.POTION:
			var heal = randi_range(3, 6) + floor_bonus
			return CardData.create_potion(heal)
		CardData.CardType.GOLD:
			var amount = randi_range(5, 15) + floor_bonus * 2
			return CardData.create_gold(amount)

	return CardData.create_monster(3, "Monster")

func grid_to_screen(grid_pos: Vector2i) -> Vector2:
	var total_size = Vector2(
		GRID_SIZE.x * CARD_SIZE.x + (GRID_SIZE.x - 1) * CARD_SPACING,
		GRID_SIZE.y * CARD_SIZE.y + (GRID_SIZE.y - 1) * CARD_SPACING
	)
	var offset = (size - total_size) / 2
	return Vector2(
		grid_pos.x * (CARD_SIZE.x + CARD_SPACING),
		grid_pos.y * (CARD_SIZE.y + CARD_SPACING)
	) + offset

func is_adjacent(from: Vector2i, to: Vector2i) -> bool:
	var diff = to - from
	return (abs(diff.x) == 1 and diff.y == 0) or (abs(diff.y) == 1 and diff.x == 0)

func _on_card_clicked(card: Card):
	if card == player_card:
		return

	if not is_adjacent(player_position, card.grid_position):
		return

	# Process the clash
	resolve_clash(card)

func resolve_clash(target_card: Card):
	var card_data = target_card.card_data
	var target_pos = target_card.grid_position

	match card_data.type:
		CardData.CardType.MONSTER:
			resolve_monster_clash(target_card)
		CardData.CardType.WEAPON:
			resolve_weapon_pickup(target_card)
		CardData.CardType.SHIELD:
			resolve_shield_pickup(target_card)
		CardData.CardType.POTION:
			resolve_potion_pickup(target_card)
		CardData.CardType.GOLD:
			resolve_gold_pickup(target_card)
		_:
			move_player_to(target_pos)

	player_clashed.emit(card_data.type, card_data.value)

func resolve_monster_clash(monster_card: Card):
	var monster_hp = monster_card.card_data.value
	var player_attack = GameManager.player_stats.attack
	var target_pos = monster_card.grid_position  # Store position before removing

	# Player attacks monster
	monster_hp -= player_attack

	if monster_hp <= 0:
		# Monster defeated - move player to that position
		remove_card(monster_card)
		move_player_to(target_pos)
	else:
		# Monster survives - player takes damage equal to remaining HP
		GameManager.damage_player(monster_hp)
		monster_card.set_value(monster_hp)
		monster_card.flash_damage()

		# Don't move - just dealt damage
		check_game_over()

	turn_completed.emit()
	fill_empty_spaces()

func resolve_weapon_pickup(weapon_card: Card):
	var target_pos = weapon_card.grid_position
	# Weapon gives attack boost
	GameManager.player_stats.attack += weapon_card.card_data.value
	remove_card(weapon_card)
	move_player_to(target_pos)
	turn_completed.emit()
	fill_empty_spaces()

func resolve_shield_pickup(shield_card: Card):
	var target_pos = shield_card.grid_position
	# Shield restores health (like armor/defense in original)
	GameManager.heal_player(shield_card.card_data.value)
	remove_card(shield_card)
	move_player_to(target_pos)
	turn_completed.emit()
	fill_empty_spaces()

func resolve_potion_pickup(potion_card: Card):
	var target_pos = potion_card.grid_position
	GameManager.heal_player(potion_card.card_data.value)
	remove_card(potion_card)
	move_player_to(target_pos)
	turn_completed.emit()
	fill_empty_spaces()

func resolve_gold_pickup(gold_card: Card):
	var target_pos = gold_card.grid_position
	GameManager.add_gold(gold_card.card_data.value)
	remove_card(gold_card)
	move_player_to(target_pos)
	turn_completed.emit()
	fill_empty_spaces()

func move_player_to(new_pos: Vector2i):
	# Clear old position
	grid[player_position.y][player_position.x] = null

	# Update position
	player_position = new_pos
	grid[new_pos.y][new_pos.x] = player_card
	player_card.grid_position = new_pos

	# Animate movement
	player_card.animate_to(grid_to_screen(new_pos))

func remove_card(card: Card):
	var pos = card.grid_position
	grid[pos.y][pos.x] = null
	cards.erase(card)
	card.queue_free()

func fill_empty_spaces():
	# Find all empty positions (but not where player is)
	for y in range(GRID_SIZE.y):
		for x in range(GRID_SIZE.x):
			var pos = Vector2i(x, y)
			if grid[y][x] == null and pos != player_position:
				var card_data = generate_random_card()
				var card = create_card(card_data, pos)
				# Could add spawn animation here

func check_game_over():
	if GameManager.player_stats.current_hp <= 0:
		game_over.emit()

func _input(event):
	# Keyboard controls
	if event.is_action_pressed("move_up"):
		try_move(Vector2i.UP)
	elif event.is_action_pressed("move_down"):
		try_move(Vector2i.DOWN)
	elif event.is_action_pressed("move_left"):
		try_move(Vector2i.LEFT)
	elif event.is_action_pressed("move_right"):
		try_move(Vector2i.RIGHT)

func try_move(direction: Vector2i):
	var target_pos = player_position + direction
	if is_valid_position(target_pos):
		var target_card = grid[target_pos.y][target_pos.x]
		if target_card:
			resolve_clash(target_card)

func is_valid_position(pos: Vector2i) -> bool:
	return pos.x >= 0 and pos.x < GRID_SIZE.x and pos.y >= 0 and pos.y < GRID_SIZE.y

func restart_game():
	GameManager.new_game()
	setup_board()
