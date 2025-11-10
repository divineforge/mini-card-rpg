# Quick Start Guide - Mini Card Dungeon

## What You Have Now

Your repo now contains a complete foundation for a card-based dungeon crawler game! Here's what's been set up:

### 📚 Documentation
- **GAME_DESIGN.md** - Complete game design vision and mechanics
- **DEVELOPMENT_GUIDE.md** - Step-by-step development roadmap (6 sprints)
- **ARCHITECTURE.md** - Technical implementation details and system architecture
- **QUICKSTART.md** - This file!

### 🎮 Core Systems (Scripts Created)

All scripts are in the `/scripts/` folder:

1. **card_data.gd** - Resource defining card types and properties
2. **player_stats.gd** - Player health, attack, defense, and gold
3. **grid_manager.gd** - Manages the game grid and card positions
4. **card.gd** - Individual card behavior (reveal, effects)
5. **player_grid.gd** - Grid-based player movement
6. **game_manager.gd** - Central game state manager (Autoload singleton)
7. **level_generator.gd** - Procedural dungeon generation

### ⚙️ Configuration
- **Web Export** preset configured for itch.io deployment
- **GameManager** set up as autoload singleton
- **Mobile-friendly** resolution (480x720 portrait)

---

## Next Steps - Building the Game

### Option 1: Follow the Full Development Guide

Open **DEVELOPMENT_GUIDE.md** and follow the 6-sprint roadmap:
- **Sprint 1**: Set up grid and basic card mechanics in Godot editor
- **Sprint 2**: Implement all card types
- **Sprint 3**: Build combat system
- **Sprint 4**: Add procedural generation and game loop
- **Sprint 5**: Polish with animations and effects
- **Sprint 6**: Export to web and publish on itch.io

### Option 2: Quick MVP Path

If you want to get something playable fast, focus on these tasks:

1. **Open in Godot 4.4**
   - Install Godot 4.4 from godotengine.org
   - Open this project folder

2. **Create Card Scene** (30 min)
   - Create `scenes/cards/card.tscn`
   - Add Area2D with CollisionShape2D
   - Add two Sprite2D nodes: CardBack and CardFront
   - Attach `scripts/card.gd`
   - Create simple card back texture (64x64px)

3. **Create Grid Manager Scene** (20 min)
   - Create `scenes/grid/grid_manager.tscn`
   - Add Node2D root
   - Attach `scripts/grid_manager.gd`

4. **Create Player Scene** (20 min)
   - Create `scenes/player/player_grid.tscn`
   - Add Node2D with your existing player sprite
   - Attach `scripts/player_grid.gd`

5. **Update Main Scene** (30 min)
   - Open `main.tscn`
   - Remove old dodge mechanics
   - Add GridManager instance
   - Add Player instance
   - Add simple test: spawn a few cards on the grid

6. **Test and Iterate** (ongoing)
   - Press F5 to run
   - Use arrow keys to move
   - Debug and refine

---

## Understanding the Architecture

### How It All Connects

```
GameManager (Singleton)
    ↓ manages
PlayerStats (health, gold, etc.)
    ↓
Main Scene
    ├── GridManager (manages card grid)
    │   └── Cards (face-down, reveal on move)
    └── Player (moves on grid, triggers reveals)
```

### Key Game Flow

1. **Game Start**
   - GameManager.new_game() called
   - LevelGenerator creates card data for floor
   - GridManager spawns cards on grid
   - Player placed at grid position (0, 0)

2. **Player Movement**
   - Player presses arrow key
   - PlayerGrid validates move
   - Player animates to new grid position
   - Card at position reveals
   - Card effect triggers (enemy, treasure, etc.)

3. **Card Effects**
   - Empty: Nothing happens
   - Treasure: Add gold to player
   - Potion: Heal player
   - Enemy: Start combat (to be implemented)
   - Trap: Damage player
   - Exit: Load next floor

---

## Common Tasks

### Adding a New Card Type

1. Add to `CardType` enum in `scripts/card_data.gd`
2. Add properties to CardData resource if needed
3. Handle in `card.gd` trigger_effect()
4. Add to LevelGenerator distribution
5. Create visual/icon for the card

### Adjusting Difficulty

Edit `scripts/level_generator.gd`:
- `calculate_distribution()` - Change card type percentages
- `create_card_data()` - Adjust enemy/trap stats
- Modify floor multipliers for scaling

### Changing Grid Size

Edit `scripts/grid_manager.gd`:
```gdscript
const GRID_SIZE = Vector2i(6, 6)  # Change to desired size
const CELL_SIZE = 64  # Adjust if cards are different size
```

---

## Testing Web Build

When you're ready to test the web version:

1. **Export from Godot**
   - Project → Export
   - Select "Web" preset (already configured)
   - Export to `builds/web/`

2. **Test Locally**
   ```bash
   cd builds/web
   python -m http.server 8000
   # Visit http://localhost:8000 in browser
   ```

3. **Upload to itch.io**
   - Zip the `builds/web` folder
   - Upload to itch.io
   - Set as "Playable in browser"
   - Configure viewport: 480x720

---

## Useful Resources

### Godot Documentation
- [Godot 2D Tutorial](https://docs.godotengine.org/en/stable/getting_started/first_2d_game/)
- [GDScript Basics](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_basics.html)
- [Exporting for Web](https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_web.html)

### Game Design References
- Card Dungeon (Steam) - Original inspiration
- Dungeon Cards (Steam) - Similar mechanics
- Slay the Spire - Card-based roguelike

### Community
- [Godot Discord](https://discord.gg/godotengine)
- [r/godot](https://reddit.com/r/godot)
- [itch.io Creator Community](https://itch.io/community)

---

## Troubleshooting

### Scripts not loading
- Make sure all scripts are in `res://scripts/` folder
- Check Godot's Output panel for errors
- Verify GameManager is in Autoload (Project Settings → Autoload)

### Cards not appearing
- Check GridManager is in the scene
- Verify Card scene is created with proper node structure
- Make sure card spawning code is called

### Player not moving
- Verify arrow key inputs are configured (Project Settings → Input Map)
- Check PlayerGrid has reference to GridManager
- Look for errors in Output panel

---

## Current State vs Final Vision

### ✅ What's Done
- Complete architecture and documentation
- All core system scripts written
- Web export configured
- Game design planned out

### 🚧 What's Next (You'll Build)
- Create actual Godot scenes (.tscn files)
- Design card visuals and icons
- Implement combat UI and system
- Add animations and polish
- Create menus and HUD
- Test and balance gameplay
- Deploy to itch.io

---

## Your Development Workflow

Recommended approach:

1. **Morning**: Read through GAME_DESIGN.md to understand the vision
2. **Day 1-2**: Follow Sprint 1 in DEVELOPMENT_GUIDE.md (Grid + Cards)
3. **Day 3-4**: Sprint 2 (Card Types)
4. **Day 5-7**: Sprint 3 (Combat)
5. **Week 2**: Sprint 4 (Procedural + Game Loop)
6. **Week 3**: Sprint 5 (Polish)
7. **Week 4**: Sprint 6 (Deploy!)

Take it step by step. Don't rush. Test frequently. Have fun!

---

## Getting Help

If you get stuck:
1. Check the ARCHITECTURE.md for implementation details
2. Review DEVELOPMENT_GUIDE.md for specific tasks
3. Search Godot docs for specific node/function help
4. Ask in Godot Discord/Reddit communities

---

## 🎯 Your First Goal

**Get a playable prototype where:**
- Player can move on a grid
- Cards reveal when player moves to them
- At least 3 card types work (Empty, Treasure, Exit)
- Can advance to next floor

Once you have that, everything else is just adding more content and polish!

**Good luck, and have fun building your card dungeon crawler!** 🎮✨
