# Mini Card Dungeon - Game Design Document

## Overview
A roguelike card revelation dungeon crawler where players navigate through procedurally generated dungeons by revealing face-down cards. Each card represents a tile in the dungeon that could contain enemies, treasures, traps, or empty spaces.

## Core Concept
**Genre**: Card-based Roguelike Dungeon Crawler
**Platform**: Web (HTML5) via Godot Engine
**Distribution**: itch.io
**Target Resolution**: 480x720 (mobile-friendly portrait)

## Gameplay Mechanics

### Card Revelation System
- **Face-Down Cards**: The dungeon is represented as a grid of face-down cards
- **Movement Reveals**: When the player moves to a card, it flips and reveals its content
- **Adjacent Preview**: Cards adjacent to the player show a hint (glow/icon) of what they contain
- **Turn-Based**: Each move counts as one turn; enemies act after player moves

### Card Types
1. **Empty Space** - Safe tile, no event
2. **Enemy** - Combat encounter (various types and difficulties)
3. **Treasure** - Gold, items, or equipment
4. **Trap** - Deals damage or applies negative effect
5. **Potion** - Healing or buff
6. **Exit** - Stairs to next level
7. **Shop** - Merchant for buying items
8. **Event** - Special encounters (shrine, fountain, etc.)

### Player Character
- **Movement**: Grid-based, 4-directional (up, down, left, right)
- **Stats**:
  - Health Points (HP)
  - Attack Power
  - Defense
  - Gold
- **Inventory**: Limited slots for items and equipment
- **Skills**: Unlock abilities as you progress

### Combat System
- **Turn-Based**: Player attacks first, then enemy
- **Attack Resolution**:
  - Damage = Player Attack - Enemy Defense
  - Minimum 1 damage guaranteed
- **Enemy AI**: Simple patterns (melee, ranged, special abilities)
- **Death**: Permadeath - restart from floor 1

### Progression
- **Floors**: Multiple dungeon floors (start with 5-10)
- **Difficulty Scaling**: Enemies get stronger each floor
- **Unlockables**: New character classes, starting items
- **Meta-Progression**: Unlock permanent upgrades between runs

### Grid Layout
- **Grid Size**: Start with 5x5 or 6x6 grid per floor
- **Card Placement**: Procedurally generated with rules:
  - Exit always in corner or far from start
  - Enemies distributed evenly
  - Guaranteed minimum treasures per floor
  - Starting position always safe

## Visual Design

### Art Style
- **Top-Down 2D**: Clear, readable grid layout
- **Card Backs**: Mysterious, consistent design
- **Card Fronts**: Clear iconography for each card type
- **Character**: Animated sprite (can reuse existing player art)
- **UI**: Clean, minimalist interface showing stats and inventory

### Animation
- **Card Flip**: Smooth reveal animation (0.3-0.5s)
- **Character Move**: Slide animation between grid cells
- **Combat**: Simple attack animations (slash, impact)
- **Particles**: Effects for treasure, damage, healing

### UI Elements
- **HUD**:
  - Top: HP bar, Gold count
  - Bottom: Mini inventory display
  - Side: Floor number, Turn counter
- **Pause Menu**: Stats, full inventory, quit
- **Game Over Screen**: Stats summary, restart button

## Audio Design
- **Music**: Atmospheric dungeon theme (can reuse existing)
- **SFX**:
  - Card flip sound
  - Footsteps
  - Combat hits
  - Treasure pickup
  - Game over sound (existing)

## Technical Requirements

### Godot Engine (4.4)
- **Export**: HTML5 for web deployment
- **Resolution**: 480x720 (portrait mobile-friendly)
- **Input**: Keyboard (arrow keys) + mouse/touch support
- **Performance**: Must run smoothly on web browsers

### itch.io Requirements
- **Build Size**: Keep under 100MB for fast loading
- **WebGL**: Ensure compatibility with modern browsers
- **Embed Size**: Responsive design for itch.io embed player

## Minimum Viable Product (MVP)

### Phase 1 - Core Mechanics
1. Grid system with face-down cards
2. Player movement on grid
3. Card reveal on move
4. Basic card types: Empty, Enemy, Treasure, Exit
5. Simple combat system
6. HP and death condition

### Phase 2 - Game Loop
1. Multiple floors (3-5 floors)
2. Floor transition
3. Procedural generation
4. Basic enemy variety (3 types)
5. Game over and restart

### Phase 3 - Polish
1. All card types implemented
2. Animations and juice
3. Sound effects
4. Better UI/HUD
5. Tutorial/How to Play

### Phase 4 - Web Deploy
1. HTML5 export configuration
2. itch.io page setup
3. Testing on multiple browsers
4. Performance optimization

## Future Enhancements
- Multiple character classes
- More card types (boss cards, secret rooms)
- Skill system and special abilities
- Daily challenges
- Leaderboards
- More visual themes
- Mobile app version

## Success Metrics
- **Core Loop**: Fun and engaging for 15-30 minute sessions
- **Replayability**: Procedural generation provides variety
- **Difficulty**: Challenging but fair, with skill expression
- **Polish**: Smooth animations and responsive controls
- **Web Performance**: Runs at 60 FPS on modern browsers
