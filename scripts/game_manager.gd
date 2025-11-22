extends Node

# Game states
enum GameState {MENU, PLAYING, GAME_OVER}
var state: GameState = GameState.MENU

# Player data
var player_stats: PlayerStats

# Game progression
var current_floor: int = 1
var turns_taken: int = 0

# Signals
signal floor_changed(new_floor: int)
signal game_state_changed(new_state: GameState)
signal player_hp_changed(current: int, maximum: int)
signal player_gold_changed(amount: int)
signal player_attack_changed(amount: int)
signal player_died

func _ready():
	_init_player_stats()

func _init_player_stats():
	player_stats = PlayerStats.new()
	player_stats.hp_changed.connect(_on_player_hp_changed)
	player_stats.gold_changed.connect(_on_player_gold_changed)
	player_stats.died.connect(_on_player_died)

func new_game():
	current_floor = 1
	turns_taken = 0
	_init_player_stats()

	change_state(GameState.PLAYING)

	# Notify of initial stats
	player_hp_changed.emit(player_stats.current_hp, player_stats.max_hp)
	player_gold_changed.emit(player_stats.gold)
	player_attack_changed.emit(player_stats.attack)

func next_floor():
	current_floor += 1
	floor_changed.emit(current_floor)

func add_gold(amount: int):
	player_stats.add_gold(amount)

func heal_player(amount: int):
	player_stats.heal(amount)

func damage_player(amount: int):
	player_stats.take_damage(amount)

func add_attack(amount: int):
	player_stats.attack += amount
	player_attack_changed.emit(player_stats.attack)

func increment_turn():
	turns_taken += 1

func game_over():
	change_state(GameState.GAME_OVER)
	player_died.emit()

func change_state(new_state: GameState):
	state = new_state
	game_state_changed.emit(new_state)

func is_playing() -> bool:
	return state == GameState.PLAYING

# Signal handlers
func _on_player_hp_changed(old_value, new_value):
	player_hp_changed.emit(new_value, player_stats.max_hp)

func _on_player_gold_changed(old_value, new_value):
	player_gold_changed.emit(new_value)

func _on_player_died():
	game_over()
