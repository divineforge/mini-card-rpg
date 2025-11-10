extends Node

# Game states
enum GameState {MENU, PLAYING, PAUSED, COMBAT, GAME_OVER}
var state: GameState = GameState.MENU

# Player data
var player_stats: PlayerStats

# Game progression
var current_floor: int = 1
var in_combat: bool = false

# Signals
signal floor_changed(new_floor: int)
signal game_state_changed(new_state: GameState)
signal player_hp_changed(current: int, maximum: int)
signal player_gold_changed(amount: int)

func _ready():
	player_stats = PlayerStats.new()
	player_stats.hp_changed.connect(_on_player_hp_changed)
	player_stats.gold_changed.connect(_on_player_gold_changed)
	player_stats.died.connect(_on_player_died)

func new_game():
	current_floor = 1
	player_stats = PlayerStats.new()
	player_stats.hp_changed.connect(_on_player_hp_changed)
	player_stats.gold_changed.connect(_on_player_gold_changed)
	player_stats.died.connect(_on_player_died)

	change_state(GameState.PLAYING)

	# Notify of initial stats
	player_hp_changed.emit(player_stats.current_hp, player_stats.max_hp)
	player_gold_changed.emit(player_stats.gold)

func next_floor():
	current_floor += 1
	floor_changed.emit(current_floor)
	# The main scene will handle loading the new floor

func add_gold(amount: int):
	player_stats.add_gold(amount)

func heal_player(amount: int):
	player_stats.heal(amount)

func damage_player(amount: int):
	player_stats.take_damage(amount)

func start_combat(enemy_card_data: CardData):
	in_combat = true
	change_state(GameState.COMBAT)
	# Combat system to be implemented

func end_combat():
	in_combat = false
	change_state(GameState.PLAYING)

func game_over():
	change_state(GameState.GAME_OVER)

func change_state(new_state: GameState):
	state = new_state
	game_state_changed.emit(new_state)

# Signal handlers
func _on_player_hp_changed(old_value, new_value):
	player_hp_changed.emit(new_value, player_stats.max_hp)

func _on_player_gold_changed(old_value, new_value):
	player_gold_changed.emit(new_value)

func _on_player_died():
	game_over()
