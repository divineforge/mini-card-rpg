class_name PlayerStats
extends Resource

@export var max_hp: int = 10
@export var current_hp: int = 10
@export var attack: int = 1
@export var defense: int = 0
@export var gold: int = 0

signal hp_changed(old_value, new_value)
signal gold_changed(old_value, new_value)
signal died()

func _init():
	current_hp = max_hp

func take_damage(amount: int):
	var old_hp = current_hp
	current_hp = max(0, current_hp - amount)
	hp_changed.emit(old_hp, current_hp)
	if current_hp == 0:
		died.emit()

func heal(amount: int):
	var old_hp = current_hp
	current_hp = min(max_hp, current_hp + amount)
	hp_changed.emit(old_hp, current_hp)

func add_gold(amount: int):
	var old_gold = gold
	gold += amount
	gold_changed.emit(old_gold, gold)

func reset():
	current_hp = max_hp
	gold = 0
