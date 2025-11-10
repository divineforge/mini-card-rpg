# Development Guide - Mini Card Dungeon

## Table of Contents
1. [Getting Started](#getting-started)
2. [Project Structure](#project-structure)
3. [Development Roadmap](#development-roadmap)
4. [Technical Implementation](#technical-implementation)
5. [Web Export for itch.io](#web-export-for-itchio)
6. [Testing and Quality](#testing-and-quality)

---

## Getting Started

### Prerequisites
- **Godot Engine 4.4** (download from godotengine.org)
- **Git** for version control
- **Modern web browser** for testing HTML5 exports
- **itch.io account** for publishing

### Current Project State
The project is currently based on the "Dodge the Creeps" tutorial and includes:
- Basic player movement system
- Animated sprites
- Simple HUD
- Audio system
- Mobile-optimized settings (480x720 resolution)

We will transform this into a card-based dungeon crawler.

---

## Project Structure

```
mini-card-rpg/
├── art/                    # Visual assets
│   ├── cards/             # Card back/front sprites (to create)
│   ├── player/            # Player sprites (existing)
│   ├── enemies/           # Enemy sprites (existing)
│   └── ui/                # UI elements (to create)
├── audio/                 # Sound and music
├── scenes/                # Godot scene files (to organize)
│   ├── cards/            # Card-related scenes
│   ├── ui/               # UI scenes
│   └── levels/           # Level/floor scenes
├── scripts/               # GDScript files (to organize)
│   ├── card_system.gd    # Card mechanics
│   ├── grid_manager.gd   # Grid and positioning
│   ├── player.gd         # Player controller (existing)
│   └── game_manager.gd   # Game state management
├── fonts/                 # Typography (existing)
├── GAME_DESIGN.md         # Design document
├── DEVELOPMENT_GUIDE.md   # This file
├── ARCHITECTURE.md        # Technical architecture
└── project.godot         # Godot project file
```

---

## Development Roadmap

### Sprint 1: Foundation (Week 1)
**Goal**: Set up grid system and basic card mechanics

#### Tasks:
- [ ] **Create Grid System**
  - GridManager scene and script
  - 2D grid positioning (5x5 or 6x6)
  - Visual grid lines (optional debug)

- [ ] **Card System**
  - Card base scene with Area2D
  - Face-down and face-up states
  - Flip animation
  - CardData resource for card types

- [ ] **Refactor Player Movement**
  - Change from free movement to grid-based
  - Snap to grid positions
  - Click/arrow key to move to adjacent cell

- [ ] **Basic Integration**
  - Player spawns on grid
  - Cards placed on grid
  - Player can move to adjacent cards
  - Cards reveal when player moves to them

**Deliverable**: Player can move on grid and reveal cards

---

### Sprint 2: Card Types and Content (Week 2)
**Goal**: Implement different card types and their effects

#### Tasks:
- [ ] **Card Type System**
  - Enum for card types
  - CardData resource with properties
  - Card effect resolution system

- [ ] **Implement Core Card Types**
  - Empty card (no effect)
  - Enemy card (trigger combat)
  - Treasure card (give gold)
  - Exit card (next floor)
  - Potion card (heal HP)

- [ ] **Create Card Visuals**
  - Design card back sprite
  - Create icons for each card type
  - Implement card reveal animation

- [ ] **Player Stats System**
  - HP tracking
  - Gold tracking
  - Death condition
  - Simple HUD update

**Deliverable**: All basic card types working with effects

---

### Sprint 3: Combat System (Week 3)
**Goal**: Implement turn-based combat

#### Tasks:
- [ ] **Combat Manager**
  - Turn-based combat scene/script
  - Combat UI overlay
  - Player attack calculation
  - Enemy attack calculation

- [ ] **Enemy System**
  - Enemy base class
  - 3 enemy types with different stats
  - Enemy data resources
  - Enemy sprites and animations

- [ ] **Combat Flow**
  - Enter combat when revealing enemy card
  - Attack/defend options
  - Damage calculation (Attack - Defense)
  - Combat end conditions (player wins/loses)
  - Return to grid after combat

- [ ] **Combat Feedback**
  - Damage numbers
  - HP bars
  - Attack animations
  - Sound effects

**Deliverable**: Full combat system working

---

### Sprint 4: Procedural Generation (Week 4)
**Goal**: Generate random dungeons

#### Tasks:
- [ ] **Level Generator**
  - LevelGenerator script
  - Procedural grid card placement
  - Ensure exit is far from start
  - Guaranteed minimum treasures

- [ ] **Floor System**
  - Multiple floor support (start with 3)
  - Floor transition
  - Difficulty scaling per floor
  - Floor counter UI

- [ ] **Game Loop**
  - Start menu
  - New game initialization
  - Game over screen
  - Restart functionality
  - Run persistence (stats carry between floors)

- [ ] **Balance Tuning**
  - Adjust enemy stats
  - Adjust treasure amounts
  - Test difficulty curve

**Deliverable**: Complete game loop with multiple floors

---

### Sprint 5: Polish and Juice (Week 5)
**Goal**: Add animations, effects, and UI polish

#### Tasks:
- [ ] **Animation and Effects**
  - Smooth card flip animation
  - Player movement tween
  - Particle effects for treasure
  - Screen shake for damage
  - Card glow/hint for adjacent tiles

- [ ] **UI Enhancement**
  - Better HUD design
  - Inventory display
  - Pause menu
  - Stats screen
  - Tutorial/How to Play screen

- [ ] **Audio**
  - Card flip sound
  - Movement sound
  - Combat sounds
  - Treasure pickup sound
  - Background music
  - Game over music

- [ ] **Visual Polish**
  - Background for grid
  - Better card art
  - Character idle animation
  - Transition effects

**Deliverable**: Polished game feel

---

### Sprint 6: Web Export and Publishing (Week 6)
**Goal**: Deploy to itch.io

#### Tasks:
- [ ] **HTML5 Export Setup**
  - Configure export template
  - Test web build locally
  - Optimize for web (compression, etc.)
  - Mobile touch controls

- [ ] **itch.io Setup**
  - Create game page
  - Write game description
  - Create screenshots and GIFs
  - Upload web build
  - Configure embed settings

- [ ] **Testing**
  - Test on Chrome, Firefox, Safari
  - Test on mobile browsers
  - Performance profiling
  - Bug fixes

- [ ] **Launch**
  - Publish game page
  - Share with community
  - Gather feedback

**Deliverable**: Live game on itch.io!

---

## Technical Implementation

### Grid System Architecture

```gdscript
# GridManager.gd
class_name GridManager
extends Node2D

const GRID_SIZE = Vector2i(6, 6)
const CELL_SIZE = 64  # pixels

var grid: Array[Array]  # 2D array of card references
var player_position: Vector2i

func _ready():
    initialize_grid()
    spawn_cards()

func grid_to_world(grid_pos: Vector2i) -> Vector2:
    return Vector2(grid_pos.x * CELL_SIZE, grid_pos.y * CELL_SIZE)

func world_to_grid(world_pos: Vector2) -> Vector2i:
    return Vector2i(int(world_pos.x / CELL_SIZE), int(world_pos.y / CELL_SIZE))

func is_valid_position(grid_pos: Vector2i) -> bool:
    return grid_pos.x >= 0 and grid_pos.x < GRID_SIZE.x \
       and grid_pos.y >= 0 and grid_pos.y < GRID_SIZE.y

func get_card_at(grid_pos: Vector2i) -> Card:
    if is_valid_position(grid_pos):
        return grid[grid_pos.y][grid_pos.x]
    return null
```

### Card System

```gdscript
# Card.gd
class_name Card
extends Area2D

enum CardType {EMPTY, ENEMY, TREASURE, TRAP, POTION, EXIT, SHOP, EVENT}

@export var card_data: CardData
var is_revealed: bool = false

@onready var card_back = $CardBack
@onready var card_front = $CardFront
@onready var animation_player = $AnimationPlayer

func reveal():
    if is_revealed:
        return

    is_revealed = true
    animation_player.play("flip")
    card_front.texture = card_data.icon

    # Trigger card effect
    trigger_effect()

func trigger_effect():
    match card_data.type:
        CardType.ENEMY:
            GameManager.start_combat(card_data.enemy_data)
        CardType.TREASURE:
            GameManager.add_gold(card_data.gold_amount)
        CardType.POTION:
            GameManager.heal_player(card_data.heal_amount)
        CardType.EXIT:
            GameManager.next_floor()
        # ... etc
```

### Player Grid Movement

```gdscript
# PlayerGrid.gd
extends Node2D

var grid_position: Vector2i
var is_moving: bool = false

func _input(event):
    if is_moving or GameManager.in_combat:
        return

    var direction = Vector2i.ZERO

    if event.is_action_pressed("move_up"):
        direction = Vector2i.UP
    elif event.is_action_pressed("move_down"):
        direction = Vector2i.DOWN
    elif event.is_action_pressed("move_left"):
        direction = Vector2i.LEFT
    elif event.is_action_pressed("move_right"):
        direction = Vector2i.RIGHT

    if direction != Vector2i.ZERO:
        try_move(direction)

func try_move(direction: Vector2i):
    var new_pos = grid_position + direction

    if GridManager.is_valid_position(new_pos):
        move_to(new_pos)

func move_to(new_grid_pos: Vector2i):
    is_moving = true
    grid_position = new_grid_pos

    var target_world_pos = GridManager.grid_to_world(grid_position)
    var tween = create_tween()
    tween.tween_property(self, "position", target_world_pos, 0.2)
    await tween.finished

    is_moving = false

    # Reveal card at new position
    var card = GridManager.get_card_at(grid_position)
    if card:
        card.reveal()
```

---

## Web Export for itch.io

### Godot Export Settings

1. **Install Export Templates**
   - In Godot: Editor → Manage Export Templates
   - Download templates for Godot 4.4

2. **Create HTML5 Export Preset**
   - Project → Export
   - Add → HTML5
   - Set options:
     - **Export Type**: Regular
     - **Head Include**: (leave default)
     - **Custom HTML Shell**: (optional custom template)
     - **Texture Format**: PNG for compatibility
     - **Scale**: Preserve aspect ratio

3. **Export Settings**
   ```
   Export Path: builds/web/index.html
   Export Mode: Release
   Encryption: None (for web)
   ```

4. **Optimize for Web**
   - Project Settings → Rendering → Textures:
     - Enable texture compression
   - Keep asset sizes small
   - Minimize audio file sizes

### itch.io Upload Process

1. **Create New Project**
   - Go to itch.io dashboard
   - Create New Project
   - Set title: "Mini Card Dungeon"
   - Kind of Project: HTML

2. **Upload Files**
   - Zip the entire web build folder
   - Upload ZIP to itch.io
   - Check "This file will be played in the browser"

3. **Configure Embed Options**
   - Viewport dimensions: 480x720 (portrait)
   - Enable fullscreen button
   - Enable mobile-friendly controls

4. **Page Setup**
   - Write description
   - Add screenshots (take during gameplay)
   - Set tags: roguelike, card-game, dungeon-crawler
   - Choose pricing (free or paid)

5. **Publish**
   - Save & view page
   - Test the embedded game
   - Set to "Public" when ready

---

## Testing and Quality

### Testing Checklist

#### Core Functionality
- [ ] Player movement in all 4 directions
- [ ] Cards reveal correctly
- [ ] All card types trigger proper effects
- [ ] Combat calculations correct
- [ ] HP reaches 0 = game over
- [ ] Exit card advances to next floor
- [ ] Procedural generation creates valid layouts

#### Web Build
- [ ] Game loads in Chrome
- [ ] Game loads in Firefox
- [ ] Game loads in Safari
- [ ] Game loads on mobile (iOS/Android)
- [ ] No console errors
- [ ] Maintains 60 FPS
- [ ] Audio plays correctly

#### Polish
- [ ] Animations smooth
- [ ] No visual glitches
- [ ] UI readable and clear
- [ ] Controls responsive
- [ ] Sound effects trigger correctly

### Performance Tips
- Use object pooling for cards
- Limit particle effects
- Compress textures
- Keep total build under 50MB
- Test on low-end devices

---

## Troubleshooting

### Common Issues

**Problem**: Cards don't reveal when player moves to them
**Solution**: Check if card.reveal() is called in player movement code

**Problem**: Grid positions don't align with visuals
**Solution**: Ensure CELL_SIZE matches your card sprite size

**Problem**: Web build doesn't load on itch.io
**Solution**: Check browser console for errors, ensure all files in ZIP

**Problem**: Combat doesn't start
**Solution**: Verify GameManager signals are connected properly

**Problem**: Performance is slow
**Solution**: Profile with Godot debugger, reduce particle effects, optimize sprites

---

## Resources

- [Godot Documentation](https://docs.godotengine.org/)
- [Godot HTML5 Export](https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_web.html)
- [itch.io Creator Guide](https://itch.io/docs/creators/)
- [GDQuest Tutorials](https://www.gdquest.com/)

---

## Next Steps

1. Review GAME_DESIGN.md for full game vision
2. Review ARCHITECTURE.md for technical details
3. Start with Sprint 1 tasks
4. Commit progress regularly to git
5. Test frequently during development
6. Ask for help in Godot community if stuck

Happy developing! 🎮
