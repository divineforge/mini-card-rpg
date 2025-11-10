# Technical Architecture - Mini Card Dungeon

## System Overview

This document describes the technical architecture and implementation details for the Mini Card Dungeon game built with Godot Engine 4.4.

---

## Core Systems

### 1. Grid Management System

**Purpose**: Manages the spatial layout of cards in a 2D grid

**Components**:
- `GridManager.gd` - Singleton that manages grid state
- Grid represented as 2D array of Card references
- Coordinate conversion (grid ↔ world space)

**Key Responsibilities**:
- Grid initialization and sizing
- Position validation
- Coordinate transformations
- Card placement and retrieval

**Data Structures**:
```gdscript
# Grid stored as 2D array
var grid: Array[Array]  # grid[y][x] = Card

# Grid configuration
const GRID_SIZE = Vector2i(6, 6)
const CELL_SIZE = 64  # pixels per cell
```

**API**:
```gdscript
func initialize_grid() -> void
func grid_to_world(grid_pos: Vector2i) -> Vector2
func world_to_grid(world_pos: Vector2) -> Vector2i
func is_valid_position(grid_pos: Vector2i) -> bool
func get_card_at(grid_pos: Vector2i) -> Card
func set_card_at(grid_pos: Vector2i, card: Card) -> void
func get_adjacent_positions(grid_pos: Vector2i) -> Array[Vector2i]
```

---

### 2. Card System

**Purpose**: Represents individual dungeon tiles with hidden content

**Components**:
- `Card.gd` - Card node script
- `CardData.gd` - Resource defining card properties
- `card.tscn` - Card scene with visuals

**Card States**:
- **Face-Down**: Initial state, shows card back
- **Face-Up**: Revealed state, shows card content
- **Activated**: Effect has been triggered

**Card Types Enum**:
```gdscript
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
```

**CardData Resource**:
```gdscript
class_name CardData
extends Resource

@export var type: Card.CardType
@export var icon: Texture2D
@export var title: String
@export var description: String

# Type-specific properties
@export var enemy_data: EnemyData
@export var gold_amount: int
@export var heal_amount: int
@export var damage_amount: int
@export var item_data: ItemData
```

**Card Scene Hierarchy**:
```
Card (Area2D)
├── CollisionShape2D
├── CardBack (Sprite2D)
├── CardFront (Sprite2D)
├── Icon (Sprite2D)
├── AnimationPlayer
└── ParticleEmitter (GPUParticles2D)
```

---

### 3. Player System

**Purpose**: Handles player character, movement, and stats

**Components**:
- `PlayerGrid.gd` - Grid-based movement controller
- `PlayerStats.gd` - Player state and statistics
- `player_grid.tscn` - Player scene

**Player Stats**:
```gdscript
class_name PlayerStats
extends Resource

@export var max_hp: int = 100
@export var current_hp: int = 100
@export var attack: int = 10
@export var defense: int = 5
@export var gold: int = 0
@export var inventory: Array[ItemData] = []

signal hp_changed(old_value, new_value)
signal gold_changed(old_value, new_value)
signal died()

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
```

**Movement System**:
```gdscript
# Grid-based movement
var grid_position: Vector2i
var is_moving: bool = false

# Input directions
const DIRECTIONS = {
    "move_up": Vector2i.UP,
    "move_down": Vector2i.DOWN,
    "move_left": Vector2i.LEFT,
    "move_right": Vector2i.RIGHT
}

func try_move(direction: Vector2i):
    var new_pos = grid_position + direction
    if GridManager.is_valid_position(new_pos):
        await move_to(new_pos)
        on_move_complete()

func move_to(target_pos: Vector2i):
    is_moving = true
    grid_position = target_pos

    var world_pos = GridManager.grid_to_world(target_pos)
    var tween = create_tween()
    tween.set_ease(Tween.EASE_IN_OUT)
    tween.set_trans(Tween.TRANS_CUBIC)
    tween.tween_property(self, "position", world_pos, 0.2)

    await tween.finished
    is_moving = false

func on_move_complete():
    # Reveal card at current position
    var card = GridManager.get_card_at(grid_position)
    if card and not card.is_revealed:
        card.reveal()
```

---

### 4. Combat System

**Purpose**: Turn-based combat when encountering enemies

**Components**:
- `CombatManager.gd` - Combat state machine
- `EnemyData.gd` - Enemy stats resource
- `combat_ui.tscn` - Combat UI overlay

**Combat Flow**:
```
1. Player moves to enemy card
2. Enemy card reveals → triggers combat
3. CombatManager.start_combat(enemy_data)
4. Show combat UI overlay
5. Turn loop:
   a. Player chooses action (Attack/Defend/Item)
   b. Player action resolves
   c. Check if enemy defeated → end combat
   d. Enemy action resolves
   e. Check if player defeated → game over
   f. Next turn
6. Combat ends → return to grid
```

**Damage Calculation**:
```gdscript
func calculate_damage(attacker_attack: int, defender_defense: int) -> int:
    var damage = attacker_attack - defender_defense
    return max(1, damage)  # Minimum 1 damage
```

**Combat State Machine**:
```gdscript
enum CombatState {
    IDLE,
    PLAYER_TURN,
    PLAYER_ATTACKING,
    ENEMY_TURN,
    ENEMY_ATTACKING,
    VICTORY,
    DEFEAT
}

var state: CombatState = CombatState.IDLE
var current_enemy: EnemyData
var combat_ui: CombatUI

signal combat_started(enemy_data)
signal combat_ended(victory: bool)

func start_combat(enemy_data: EnemyData):
    current_enemy = enemy_data.duplicate()
    state = CombatState.PLAYER_TURN
    combat_ui.show()
    combat_started.emit(enemy_data)

func player_attack():
    state = CombatState.PLAYER_ATTACKING
    var damage = calculate_damage(GameManager.player_stats.attack, current_enemy.defense)
    current_enemy.current_hp -= damage

    await show_damage_animation(damage)

    if current_enemy.current_hp <= 0:
        victory()
    else:
        enemy_turn()

func enemy_turn():
    state = CombatState.ENEMY_TURN
    await get_tree().create_timer(0.5).timeout  # Delay for drama

    state = CombatState.ENEMY_ATTACKING
    var damage = calculate_damage(current_enemy.attack, GameManager.player_stats.defense)
    GameManager.player_stats.take_damage(damage)

    await show_damage_animation(damage)

    if GameManager.player_stats.current_hp <= 0:
        defeat()
    else:
        state = CombatState.PLAYER_TURN

func victory():
    state = CombatState.VICTORY
    # Give rewards
    GameManager.player_stats.add_gold(current_enemy.gold_reward)
    await get_tree().create_timer(1.0).timeout
    end_combat(true)

func defeat():
    state = CombatState.DEFEAT
    await get_tree().create_timer(1.0).timeout
    end_combat(false)
    GameManager.game_over()

func end_combat(victory: bool):
    combat_ui.hide()
    state = CombatState.IDLE
    combat_ended.emit(victory)
```

---

### 5. Level Generation System

**Purpose**: Procedurally generates dungeon floors

**Components**:
- `LevelGenerator.gd` - Procedural generation logic
- `FloorData.gd` - Floor configuration resource

**Generation Algorithm**:
```gdscript
class_name LevelGenerator

static func generate_floor(floor_number: int) -> Array[CardData]:
    var cards: Array[CardData] = []
    var total_cells = GridManager.GRID_SIZE.x * GridManager.GRID_SIZE.y

    # Calculate card distribution based on floor
    var distribution = calculate_distribution(floor_number, total_cells)

    # Place special cards first
    var player_pos = Vector2i(0, 0)  # Top-left
    var exit_pos = get_farthest_position(player_pos)

    # Fill grid
    for y in range(GridManager.GRID_SIZE.y):
        for x in range(GridManager.GRID_SIZE.x):
            var pos = Vector2i(x, y)

            if pos == player_pos:
                cards.append(create_card(Card.CardType.EMPTY))
            elif pos == exit_pos:
                cards.append(create_card(Card.CardType.EXIT))
            else:
                cards.append(get_random_card(distribution))

    return cards

static func calculate_distribution(floor: int, total: int) -> Dictionary:
    # Adjust difficulty/content based on floor
    var base_enemies = 0.3 + (floor * 0.05)  # More enemies on later floors
    var base_treasure = 0.2
    var base_potions = 0.15
    var base_traps = 0.1 + (floor * 0.02)
    var base_empty = 1.0 - (base_enemies + base_treasure + base_potions + base_traps)

    return {
        Card.CardType.ENEMY: int(total * base_enemies),
        Card.CardType.TREASURE: int(total * base_treasure),
        Card.CardType.POTION: int(total * base_potions),
        Card.CardType.TRAP: int(total * base_traps),
        Card.CardType.EMPTY: 0  # Fill remaining
    }

static func get_random_card(distribution: Dictionary) -> CardData:
    # Pick random card type based on distribution
    var types = []
    for type in distribution:
        for i in range(distribution[type]):
            types.append(type)

    if types.is_empty():
        return create_card(Card.CardType.EMPTY)

    var random_type = types[randi() % types.size()]
    return create_card(random_type)
```

**Floor Difficulty Scaling**:
```gdscript
static func scale_enemy_stats(base_enemy: EnemyData, floor: int) -> EnemyData:
    var scaled = base_enemy.duplicate()
    var multiplier = 1.0 + (floor - 1) * 0.15  # 15% increase per floor

    scaled.max_hp = int(base_enemy.max_hp * multiplier)
    scaled.current_hp = scaled.max_hp
    scaled.attack = int(base_enemy.attack * multiplier)
    scaled.defense = int(base_enemy.defense * multiplier)
    scaled.gold_reward = int(base_enemy.gold_reward * (1.0 + floor * 0.1))

    return scaled
```

---

### 6. Game Manager (Singleton)

**Purpose**: Central game state management

**Components**:
- `GameManager.gd` - Autoload singleton
- Manages global game state
- Coordinates between systems

**Responsibilities**:
- Game state (menu, playing, paused, game over)
- Floor progression
- Player stats access
- Scene management
- Save/load (future)

**Implementation**:
```gdscript
# GameManager.gd (Autoload)
extends Node

# State
enum GameState {MENU, PLAYING, PAUSED, COMBAT, GAME_OVER}
var state: GameState = GameState.MENU

# References
var player_stats: PlayerStats
var current_floor: int = 1
var grid_manager: GridManager
var combat_manager: CombatManager

# Signals
signal floor_changed(new_floor: int)
signal game_state_changed(new_state: GameState)

func _ready():
    player_stats = PlayerStats.new()
    player_stats.died.connect(game_over)

func new_game():
    current_floor = 1
    player_stats = PlayerStats.new()
    load_floor(1)
    change_state(GameState.PLAYING)

func load_floor(floor_number: int):
    current_floor = floor_number
    var cards = LevelGenerator.generate_floor(floor_number)
    grid_manager.setup_grid(cards)
    floor_changed.emit(floor_number)

func next_floor():
    current_floor += 1
    load_floor(current_floor)

func game_over():
    change_state(GameState.GAME_OVER)

func change_state(new_state: GameState):
    state = new_state
    game_state_changed.emit(new_state)

func start_combat(enemy_data: EnemyData):
    change_state(GameState.COMBAT)
    combat_manager.start_combat(enemy_data)
```

---

## Data Flow

### Player Movement Flow
```
1. Input Event (arrow key press)
   ↓
2. PlayerGrid._input() detects direction
   ↓
3. PlayerGrid.try_move(direction)
   ↓
4. GridManager.is_valid_position() check
   ↓
5. PlayerGrid.move_to() animates movement
   ↓
6. Movement complete signal
   ↓
7. Get card at new position
   ↓
8. Card.reveal() if not already revealed
   ↓
9. Card.trigger_effect() based on type
   ↓
10. Effect resolution (combat, treasure, etc.)
```

### Combat Flow
```
1. Enemy card revealed
   ↓
2. GameManager.start_combat(enemy_data)
   ↓
3. CombatManager takes control
   ↓
4. Combat UI displays
   ↓
5. Turn loop:
   - Player action input
   - Damage calculation
   - HP updates
   - UI updates
   - Enemy AI action
   - Repeat until end condition
   ↓
6. Combat ends (victory or defeat)
   ↓
7. Return to grid or game over
```

---

## Performance Considerations

### Object Pooling
```gdscript
# CardPool.gd
class_name CardPool

var card_scene: PackedScene
var pool: Array[Card] = []
var active_cards: Array[Card] = []

func get_card() -> Card:
    var card: Card
    if pool.size() > 0:
        card = pool.pop_back()
    else:
        card = card_scene.instantiate()
    active_cards.append(card)
    return card

func return_card(card: Card):
    active_cards.erase(card)
    pool.append(card)
    card.reset()
```

### Memory Management
- Pool cards instead of creating/destroying
- Unload unused assets between floors
- Limit particle effects on web builds
- Use compressed textures

### Web Optimization
- Target 60 FPS minimum
- Keep texture sizes reasonable (max 512x512 for most)
- Minimize shader usage
- Compress audio files (OGG format)
- Lazy load assets when possible

---

## Signal Architecture

Key signals for decoupled communication:

```gdscript
# Player
signal moved(old_pos, new_pos)
signal hp_changed(old_hp, new_hp)
signal died()

# Card
signal revealed(card_data)
signal effect_triggered(card_type)

# Combat
signal combat_started(enemy)
signal combat_ended(victory)
signal damage_dealt(target, amount)

# Game Manager
signal floor_changed(floor_number)
signal game_state_changed(state)
signal game_over()
```

---

## File Organization

### Recommended Scene Structure
```
res://
├── scenes/
│   ├── main/
│   │   ├── main.tscn              (Main game scene)
│   │   └── main.gd
│   ├── grid/
│   │   ├── grid_manager.tscn
│   │   └── grid_manager.gd
│   ├── cards/
│   │   ├── card.tscn
│   │   ├── card.gd
│   │   └── card_back.png
│   ├── player/
│   │   ├── player_grid.tscn
│   │   └── player_grid.gd
│   ├── combat/
│   │   ├── combat_manager.tscn
│   │   ├── combat_ui.tscn
│   │   └── combat_manager.gd
│   └── ui/
│       ├── hud.tscn
│       ├── game_over.tscn
│       └── main_menu.tscn
├── scripts/
│   ├── autoload/
│   │   └── game_manager.gd
│   ├── resources/
│   │   ├── card_data.gd
│   │   ├── enemy_data.gd
│   │   ├── item_data.gd
│   │   └── player_stats.gd
│   └── utilities/
│       ├── level_generator.gd
│       └── card_pool.gd
├── resources/
│   ├── cards/
│   ├── enemies/
│   └── items/
└── art/
    ├── cards/
    ├── ui/
    └── characters/
```

---

## Testing Strategy

### Unit Tests
- Grid position validation
- Damage calculation
- Card effect logic
- Level generation constraints

### Integration Tests
- Player movement → card reveal
- Combat full flow
- Floor transition
- Game over flow

### Manual Testing
- Web browser compatibility
- Mobile touch controls
- Performance profiling
- Balance testing

---

## Future Extensibility

### Plugin System
Design for future features:
- New card types (just add to enum and CardData)
- New enemy types (create new EnemyData resources)
- New items (ItemData resource system)
- Special abilities (ability system layer)

### Save System
Prepare for future save/load:
```gdscript
func save_game() -> Dictionary:
    return {
        "player_stats": player_stats.to_dict(),
        "current_floor": current_floor,
        "unlocks": unlocked_items,
        "timestamp": Time.get_unix_time_from_system()
    }

func load_game(save_data: Dictionary):
    player_stats.from_dict(save_data["player_stats"])
    current_floor = save_data["current_floor"]
    load_floor(current_floor)
```

### Analytics Hooks
Add hooks for future analytics:
```gdscript
signal analytics_event(event_name: String, params: Dictionary)

# Usage
analytics_event.emit("combat_victory", {
    "enemy_type": enemy.type,
    "floor": current_floor,
    "damage_taken": damage_taken
})
```

---

This architecture provides a solid foundation for the Mini Card Dungeon game with room for future expansion and optimization.
