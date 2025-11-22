extends Control

@onready var dungeon_board = $DungeonBoard
@onready var hp_label: Label = $HUD/HPLabel
@onready var gold_label: Label = $HUD/GoldLabel
@onready var attack_label: Label = $HUD/AttackLabel
@onready var floor_label: Label = $HUD/FloorLabel
@onready var game_over_panel: Panel = $GameOverPanel
@onready var start_panel: Panel = $StartPanel
@onready var weapon_slot: ColorRect = $EquipmentPanel/WeaponSlot
@onready var weapon_name_label: Label = $EquipmentPanel/WeaponSlot/WeaponName
@onready var exit_progress_bar: ProgressBar = $HUD/ExitProgressBar
@onready var exit_progress_label: Label = $HUD/ExitProgressLabel

func _ready():
	# Connect to GameManager signals
	GameManager.player_hp_changed.connect(_on_hp_changed)
	GameManager.player_gold_changed.connect(_on_gold_changed)
	GameManager.player_attack_changed.connect(_on_attack_changed)
	GameManager.floor_changed.connect(_on_floor_changed)
	GameManager.player_died.connect(_on_player_died)

	# Connect dungeon board signals
	dungeon_board.game_over.connect(_on_game_over)
	dungeon_board.weapon_equipped.connect(_on_weapon_equipped)
	dungeon_board.weapon_used.connect(_on_weapon_used)
	dungeon_board.progress_updated.connect(_on_progress_updated)

	# Show start screen
	show_start_screen()

func show_start_screen():
	start_panel.visible = true
	game_over_panel.visible = false
	dungeon_board.visible = false

func start_game():
	start_panel.visible = false
	game_over_panel.visible = false
	dungeon_board.visible = true

	GameManager.new_game()
	dungeon_board.setup_board()
	update_hud()
	clear_weapon_display()
	reset_progress_bar()

func update_hud():
	if GameManager.player_stats:
		hp_label.text = "HP: %d/%d" % [GameManager.player_stats.current_hp, GameManager.player_stats.max_hp]
		gold_label.text = "Gold: %d" % GameManager.player_stats.gold
		attack_label.text = "ATK: %d" % GameManager.player_stats.attack
	floor_label.text = "Floor: %d" % GameManager.current_floor

func _on_hp_changed(current: int, maximum: int):
	hp_label.text = "HP: %d/%d" % [current, maximum]

func _on_gold_changed(amount: int):
	gold_label.text = "Gold: %d" % amount

func _on_attack_changed(amount: int):
	attack_label.text = "ATK: %d" % amount

func _on_floor_changed(floor_num: int):
	floor_label.text = "Floor: %d" % floor_num

func _on_player_died():
	_on_game_over()

func _on_game_over():
	game_over_panel.visible = true

func _on_restart_pressed():
	game_over_panel.visible = false
	start_game()

func _on_start_pressed():
	start_game()

func _on_quit_pressed():
	get_tree().quit()

func _input(event):
	if event.is_action_pressed("start_game"):
		if start_panel.visible:
			start_game()
		elif game_over_panel.visible:
			start_game()
	# ESC to quit
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()

# Weapon display functions
func _on_weapon_equipped(weapon_name: String, weapon_value: int):
	weapon_slot.color = Color.ORANGE
	weapon_name_label.text = "%s\n+%d" % [weapon_name, weapon_value]

func _on_weapon_used():
	clear_weapon_display()

func clear_weapon_display():
	weapon_slot.color = Color(0.2, 0.2, 0.2, 1)
	weapon_name_label.text = ""

# Progress bar functions
func _on_progress_updated(current_steps: int, max_steps: int):
	exit_progress_bar.max_value = max_steps
	exit_progress_bar.value = current_steps
	exit_progress_label.text = "Exit: %d/%d" % [current_steps, max_steps]

func reset_progress_bar():
	exit_progress_bar.max_value = dungeon_board.steps_to_exit
	exit_progress_bar.value = 0
	exit_progress_label.text = "Exit: 0/%d" % dungeon_board.steps_to_exit
