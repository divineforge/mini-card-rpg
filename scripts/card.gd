class_name Card
extends Control

@export var card_data: CardData
var grid_position: Vector2i
var is_player_card: bool = false

# Visual components (will be created dynamically)
var background: ColorRect
var label: Label
var value_label: Label

signal card_clicked(card: Card)

func _ready():
	setup_visuals()

func setup_visuals():
	# Set card size for click detection
	custom_minimum_size = Vector2(80, 80)
	size = Vector2(80, 80)

	# Create background
	background = ColorRect.new()
	background.custom_minimum_size = Vector2(80, 80)
	background.size = Vector2(80, 80)
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE  # Let parent handle clicks
	add_child(background)

	# Create title label
	label = Label.new()
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.size = Vector2(80, 40)
	label.position = Vector2(0, 10)
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(label)

	# Create value label
	value_label = Label.new()
	value_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	value_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	value_label.size = Vector2(80, 40)
	value_label.position = Vector2(0, 40)
	value_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(value_label)

	# Make clickable
	mouse_filter = Control.MOUSE_FILTER_STOP

func setup(data: CardData, grid_pos: Vector2i):
	card_data = data
	grid_position = grid_pos
	is_player_card = data.type == CardData.CardType.PLAYER
	update_visual()

func update_visual():
	if not card_data:
		return

	if not background:
		setup_visuals()

	# Set color based on card type
	var color = Color.GRAY
	var title_text = ""
	var value_text = ""

	match card_data.type:
		CardData.CardType.PLAYER:
			color = Color.DODGER_BLUE
			title_text = "HERO"
			value_text = ""
		CardData.CardType.MONSTER:
			color = Color.INDIAN_RED
			title_text = card_data.title
			value_text = str(card_data.value) + " HP"
		CardData.CardType.WEAPON:
			color = Color.ORANGE
			title_text = card_data.title
			value_text = "+" + str(card_data.value)
		CardData.CardType.SHIELD:
			color = Color.SLATE_GRAY
			title_text = card_data.title
			value_text = str(card_data.value)
		CardData.CardType.POTION:
			color = Color.LIME_GREEN
			title_text = "Potion"
			value_text = "+" + str(card_data.value)
		CardData.CardType.GOLD:
			color = Color.GOLD
			title_text = "Gold"
			value_text = str(card_data.value)
		CardData.CardType.SPECIAL:
			color = Color.PURPLE
			title_text = card_data.title
			value_text = str(card_data.value)
		CardData.CardType.EXIT:
			color = Color.CYAN
			title_text = "EXIT"
			value_text = ">>>"

	background.color = color
	label.text = title_text
	value_label.text = value_text

func set_value(new_value: int):
	if card_data:
		card_data.value = new_value
		update_visual()

func _gui_input(event: InputEvent):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			card_clicked.emit(self)
			accept_event()  # Prevent event from propagating

func animate_to(target_position: Vector2, duration: float = 0.2):
	var tween = create_tween()
	tween.tween_property(self, "position", target_position, duration)
	return tween

func flash_damage():
	var tween = create_tween()
	tween.tween_property(background, "modulate", Color.WHITE, 0.1)
	tween.tween_property(background, "modulate", Color.RED, 0.1)
	tween.tween_property(background, "modulate", Color.WHITE, 0.1)
