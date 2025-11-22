class_name CardData
extends Resource

# Dungeon Cards-style card types
enum CardType {
	PLAYER,     # The player's card
	MONSTER,    # Enemy with HP - clashing deals mutual damage
	WEAPON,     # Gives attack bonus (one-time use)
	SHIELD,     # Gives defense/armor
	POTION,     # Heals player
	GOLD,       # Currency pickup
	SPECIAL,    # Special abilities (fireball, etc.)
}

@export var type: CardType = CardType.MONSTER
@export var icon: Texture2D
@export var title: String = ""
@export var value: int = 0  # Generic value (HP for monster, amount for gold/potion, bonus for weapon)

# Create common card types
static func create_monster(hp: int, title_name: String = "Monster") -> CardData:
	var data = CardData.new()
	data.type = CardType.MONSTER
	data.title = title_name
	data.value = hp
	return data

static func create_weapon(attack_bonus: int, title_name: String = "Sword") -> CardData:
	var data = CardData.new()
	data.type = CardType.WEAPON
	data.title = title_name
	data.value = attack_bonus
	return data

static func create_shield(defense: int, title_name: String = "Shield") -> CardData:
	var data = CardData.new()
	data.type = CardType.SHIELD
	data.title = title_name
	data.value = defense
	return data

static func create_potion(heal_amount: int) -> CardData:
	var data = CardData.new()
	data.type = CardType.POTION
	data.title = "Potion"
	data.value = heal_amount
	return data

static func create_gold(amount: int) -> CardData:
	var data = CardData.new()
	data.type = CardType.GOLD
	data.title = "Gold"
	data.value = amount
	return data

static func create_player() -> CardData:
	var data = CardData.new()
	data.type = CardType.PLAYER
	data.title = "Hero"
	data.value = 0
	return data
