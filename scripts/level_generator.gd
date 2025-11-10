class_name LevelGenerator

static func generate_floor(floor_number: int, grid_size: Vector2i) -> Array:
	var cards = []
	var total_cells = grid_size.x * grid_size.y

	# Calculate card distribution based on floor
	var distribution = calculate_distribution(floor_number, total_cells)

	# Reserve positions
	var player_pos = Vector2i(0, 0)  # Top-left
	var exit_pos = get_farthest_position(player_pos, grid_size)

	# Create card pool
	var card_pool = create_card_pool(distribution, floor_number)

	# Fill grid
	for y in range(grid_size.y):
		for x in range(grid_size.x):
			var pos = Vector2i(x, y)
			var card_data: CardData

			if pos == player_pos:
				# Starting position is always empty
				card_data = create_card_data(CardData.CardType.EMPTY)
			elif pos == exit_pos:
				# Exit position
				card_data = create_card_data(CardData.CardType.EXIT)
			else:
				# Random card from pool
				if card_pool.size() > 0:
					card_data = card_pool.pop_front()
				else:
					card_data = create_card_data(CardData.CardType.EMPTY)

			cards.append(card_data)

	return cards

static func calculate_distribution(floor: int, total: int) -> Dictionary:
	# Adjust difficulty/content based on floor
	# More enemies and traps on later floors
	var base_enemies = min(0.3 + (floor * 0.03), 0.5)
	var base_treasure = 0.2
	var base_potions = max(0.15 - (floor * 0.01), 0.1)
	var base_traps = min(0.05 + (floor * 0.02), 0.15)

	# Reserve 2 cells for player start and exit
	var available = total - 2

	return {
		CardData.CardType.ENEMY: int(available * base_enemies),
		CardData.CardType.TREASURE: int(available * base_treasure),
		CardData.CardType.POTION: int(available * base_potions),
		CardData.CardType.TRAP: int(available * base_traps),
	}

static func create_card_pool(distribution: Dictionary, floor: int) -> Array:
	var pool = []

	for card_type in distribution:
		var count = distribution[card_type]
		for i in range(count):
			var card_data = create_card_data(card_type, floor)
			pool.append(card_data)

	# Shuffle the pool
	pool.shuffle()

	# Fill remaining with empty cards
	return pool

static func create_card_data(card_type: CardData.CardType, floor: int = 1) -> CardData:
	var data = CardData.new()
	data.type = card_type

	match card_type:
		CardData.CardType.EMPTY:
			data.title = "Empty Space"
			data.description = "Nothing here"

		CardData.CardType.ENEMY:
			# Scale enemy stats with floor
			var multiplier = 1.0 + (floor - 1) * 0.15
			data.title = "Enemy"
			data.description = "A hostile creature"
			data.enemy_name = get_random_enemy_name()
			data.enemy_hp = int(10 * multiplier)
			data.enemy_attack = int(5 * multiplier)
			data.enemy_defense = int(2 * multiplier)
			data.enemy_gold_reward = int(10 + floor * 5)

		CardData.CardType.TREASURE:
			data.title = "Treasure"
			data.description = "Gold!"
			data.gold_amount = 15 + randi() % 20 + (floor * 5)

		CardData.CardType.POTION:
			data.title = "Health Potion"
			data.description = "Restores HP"
			data.heal_amount = 20 + randi() % 10

		CardData.CardType.TRAP:
			data.title = "Trap"
			data.description = "Deals damage"
			var multiplier_trap = 1.0 + (floor - 1) * 0.1
			data.damage_amount = int((5 + randi() % 10) * multiplier_trap)

		CardData.CardType.EXIT:
			data.title = "Exit"
			data.description = "Stairs to next floor"

	return data

static func get_farthest_position(from_pos: Vector2i, grid_size: Vector2i) -> Vector2i:
	# Simple: put exit in opposite corner
	return Vector2i(grid_size.x - 1, grid_size.y - 1)

static func get_random_enemy_name() -> String:
	var names = ["Goblin", "Skeleton", "Slime", "Bat", "Spider", "Wolf", "Zombie", "Orc"]
	return names[randi() % names.size()]
