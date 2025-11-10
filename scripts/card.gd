class_name Card
extends Area2D

@export var card_data: CardData
var is_revealed: bool = false
var grid_position: Vector2i

@onready var card_back = $CardBack
@onready var card_front = $CardFront
@onready var animation_player = $AnimationPlayer

signal revealed(card_data: CardData)
signal effect_triggered(card_type: CardData.CardType)

func _ready():
	# Start face-down
	if card_back:
		card_back.visible = true
	if card_front:
		card_front.visible = false

func setup(data: CardData, grid_pos: Vector2i):
	card_data = data
	grid_position = grid_pos

	if card_front and card_data:
		# Set up the front of the card based on card type
		update_card_visual()

func update_card_visual():
	if not card_data or not card_front:
		return

	# You'll replace this with actual icons/sprites for each card type
	var color = Color.WHITE
	match card_data.type:
		CardData.CardType.EMPTY:
			color = Color.GRAY
		CardData.CardType.ENEMY:
			color = Color.RED
		CardData.CardType.TREASURE:
			color = Color.YELLOW
		CardData.CardType.POTION:
			color = Color.GREEN
		CardData.CardType.TRAP:
			color = Color.DARK_RED
		CardData.CardType.EXIT:
			color = Color.CYAN

	card_front.modulate = color

func reveal():
	if is_revealed:
		return

	is_revealed = true

	# Play flip animation
	if animation_player and animation_player.has_animation("flip"):
		animation_player.play("flip")
	else:
		# Simple instant reveal if no animation
		if card_back:
			card_back.visible = false
		if card_front:
			card_front.visible = true

	revealed.emit(card_data)

	# Small delay before triggering effect
	await get_tree().create_timer(0.3).timeout
	trigger_effect()

func trigger_effect():
	if not card_data:
		return

	effect_triggered.emit(card_data.type)

	match card_data.type:
		CardData.CardType.ENEMY:
			GameManager.start_combat(card_data)
		CardData.CardType.TREASURE:
			GameManager.add_gold(card_data.gold_amount)
		CardData.CardType.POTION:
			GameManager.heal_player(card_data.heal_amount)
		CardData.CardType.TRAP:
			GameManager.damage_player(card_data.damage_amount)
		CardData.CardType.EXIT:
			GameManager.next_floor()
		CardData.CardType.EMPTY:
			pass  # Nothing happens

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "flip":
		if card_back:
			card_back.visible = false
		if card_front:
			card_front.visible = true
