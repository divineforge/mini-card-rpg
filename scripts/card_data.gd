class_name CardData
extends Resource

enum CardType {
	EMPTY,      # Nothing happens
	ENEMY,      # Starts combat
	TREASURE,   # Gives gold/items
	TRAP,       # Deals damage
	POTION,     # Heals player
	EXIT,       # Advances to next floor
	SHOP,       # Opens shop UI
	EVENT       # Special encounter
}

@export var type: CardType = CardType.EMPTY
@export var icon: Texture2D
@export var title: String = ""
@export var description: String = ""

# Type-specific properties
@export_group("Enemy Properties")
@export var enemy_name: String = ""
@export var enemy_hp: int = 10
@export var enemy_attack: int = 5
@export var enemy_defense: int = 2
@export var enemy_gold_reward: int = 10

@export_group("Treasure Properties")
@export var gold_amount: int = 20

@export_group("Potion Properties")
@export var heal_amount: int = 20

@export_group("Trap Properties")
@export var damage_amount: int = 10

func _init():
	pass
