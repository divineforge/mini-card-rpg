# Mini Card Dungeon 🎴⚔️

A roguelike card revelation dungeon crawler built with Godot Engine 4.4 for web browsers and itch.io.

## 🎮 Game Concept

Navigate through procedurally generated dungeons represented as a grid of face-down cards. Move your character to reveal cards - each could be an enemy, treasure, trap, or the exit to the next floor. Plan your path carefully and survive as deep as you can go!

**Genre**: Roguelike Card Game / Dungeon Crawler
**Platform**: Web (HTML5) via Godot Engine
**Target**: itch.io
**Inspired by**: Card Dungeon, Dungeon Cards, and other card-based roguelikes

---

## 📋 Project Status

**Current Phase**: Foundation Complete ✅

### What's Been Built

✅ Complete game design documentation
✅ Technical architecture and system design
✅ All core game scripts implemented
✅ Web export configuration for itch.io
✅ 6-sprint development roadmap

### What's Next

The foundation is ready! Now it's time to:
1. Create Godot scenes using the scripts
2. Design card visuals and UI
3. Implement combat system
4. Add animations and polish
5. Deploy to itch.io

---

## 🚀 Quick Start

### For Developers

1. **Install Godot 4.4** from [godotengine.org](https://godotengine.org)
2. **Open this project** in Godot
3. **Read QUICKSTART.md** for your next steps
4. **Follow DEVELOPMENT_GUIDE.md** for the full roadmap

### Key Documentation

- **[QUICKSTART.md](QUICKSTART.md)** - Start here! Your first steps
- **[GAME_DESIGN.md](GAME_DESIGN.md)** - Complete game vision and mechanics
- **[DEVELOPMENT_GUIDE.md](DEVELOPMENT_GUIDE.md)** - Step-by-step build guide (6 sprints)
- **[ARCHITECTURE.md](ARCHITECTURE.md)** - Technical implementation details

---

## 🎯 Core Gameplay

### Card Revelation System
- Dungeon is a grid of face-down cards
- Move your character to reveal cards
- Each card triggers an effect:
  - **Enemy** - Fight to survive
  - **Treasure** - Collect gold
  - **Potion** - Restore health
  - **Trap** - Take damage
  - **Exit** - Advance to next floor
  - **Empty** - Safe space

### Progression
- Turn-based movement
- Procedurally generated floors
- Increasing difficulty
- Permadeath (roguelike style)
- Unlockable upgrades

---

## 🛠️ Technical Stack

- **Engine**: Godot 4.4
- **Language**: GDScript
- **Platform**: HTML5/WebGL
- **Resolution**: 480x720 (portrait, mobile-friendly)
- **Distribution**: itch.io

---

## 📁 Project Structure

```
mini-card-rpg/
├── GAME_DESIGN.md          # Game design document
├── DEVELOPMENT_GUIDE.md    # Development roadmap
├── ARCHITECTURE.md         # Technical architecture
├── QUICKSTART.md          # Quick start guide
├── scripts/               # Core game scripts
│   ├── card_data.gd       # Card type definitions
│   ├── player_stats.gd    # Player statistics
│   ├── grid_manager.gd    # Grid system
│   ├── card.gd           # Card behavior
│   ├── player_grid.gd    # Player movement
│   ├── game_manager.gd   # Game state manager
│   └── level_generator.gd # Procedural generation
├── art/                  # Visual assets
├── fonts/               # Typography
└── project.godot        # Godot project file
```

---

## 🎨 Current Features

### Core Systems (Code Complete)
- ✅ Grid-based movement system
- ✅ Card data structure and types
- ✅ Player stats (HP, Attack, Defense, Gold)
- ✅ Procedural level generation
- ✅ Game state management
- ✅ Card reveal mechanics

### To Be Implemented (Scenes & Polish)
- ⏳ Godot scene files (.tscn)
- ⏳ Card visuals and animations
- ⏳ Combat UI and system
- ⏳ HUD and menus
- ⏳ Sound effects and music
- ⏳ Polish and juice

---

## 🏗️ Development Roadmap

Following the 6-sprint plan in DEVELOPMENT_GUIDE.md:

- **Sprint 1** (Week 1): Grid system + basic cards
- **Sprint 2** (Week 2): All card types implementation
- **Sprint 3** (Week 3): Combat system
- **Sprint 4** (Week 4): Procedural generation + game loop
- **Sprint 5** (Week 5): Animations + UI polish
- **Sprint 6** (Week 6): Web export + itch.io publish

**Estimated Total Time**: 6 weeks

---

## 🎓 Learning Resources

### Godot Documentation
- [Getting Started with Godot](https://docs.godotengine.org/en/stable/getting_started/introduction/index.html)
- [First 2D Game Tutorial](https://docs.godotengine.org/en/stable/getting_started/first_2d_game/index.html)
- [Exporting for Web](https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_web.html)

### Reference Games
- **Card Dungeon** (Steam) - Original inspiration
- **Dungeon Cards** (Steam) - Similar grid-based card gameplay
- **Slay the Spire** - Card-based roguelike combat

---

## 🤝 Contributing

This is a learning/portfolio project, but feedback and suggestions are welcome!

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

---

## 📝 License

This project is open source. Feel free to use it as a learning resource or starting point for your own game.

Assets in the `/art` folder are from the Godot "Dodge the Creeps" tutorial and have their own licensing.

---

## 🎯 Project Goals

1. **Learn Godot 4.4** - Hands-on experience with modern game engine
2. **Build a Complete Game** - From concept to published web game
3. **Master Roguelike Design** - Procedural generation, permadeath, balance
4. **Deploy to itch.io** - Real-world game publishing experience
5. **Portfolio Piece** - Demonstrable game development skills

---

## 📞 Contact & Links

- **itch.io**: (Coming soon after Sprint 6!)
- **Play Online**: (Coming soon!)

---

## 🙏 Acknowledgments

- Godot Engine team for the amazing open-source engine
- Card Dungeon and similar games for inspiration
- Godot community for tutorials and resources

---

**Ready to build?** Start with [QUICKSTART.md](QUICKSTART.md)! 🚀
