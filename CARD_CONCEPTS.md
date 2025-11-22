# Dungeon Cards - Game Concepts

## Overview

A roguelike puzzle game played on a 3x3 grid. You are the **Hero** card in the center, surrounded by 8 cards representing monsters, loot, and power-ups. Move by clicking adjacent cards to interact with them.

---

## Core Mechanics

### Movement & Clashing
- **Click** an adjacent card (up/down/left/right) to move
- Moving onto a card triggers a **clash** - resolving that card's effect
- After each move, empty spaces fill with new random cards
- **Goal**: Survive as long as possible, collect gold, grow stronger

### Combat Formula
```
When clashing with a Monster:
  Monster HP -= Your Attack
  If Monster HP <= 0: Monster dies, you move to its space
  If Monster HP > 0: You take damage = remaining Monster HP
```

---

## Card Types

### Creatures (Monsters)

| Name | HP Range | Color | Description |
|------|----------|-------|-------------|
| **Slime** | 2-3 | Red | Weak, gelatinous blob. Perfect for beginners. |
| **Rat** | 2-4 | Red | Quick dungeon vermin. Low threat. |
| **Bat** | 3-4 | Red | Flying nuisance. Slightly tougher than rats. |
| **Goblin** | 3-5 | Red | Cunning humanoid. Moderate challenge. |
| **Spider** | 4-5 | Red | Eight-legged horror. Dangerous in groups. |

*Monster HP increases with dungeon floor.*

---

### Weapons (Attack Boost)

| Name | ATK Bonus | Color | Description |
|------|-----------|-------|-------------|
| **Dagger** | +2 | Orange | Quick blade. Small but reliable damage boost. |
| **Sword** | +3 | Orange | Classic weapon. Solid attack improvement. |
| **Axe** | +4 | Orange | Heavy weapon. Maximum damage potential. |

**Effect**: Weapons are **consumable** - equipping one adds it to your weapon slot. The bonus is used on your next monster attack, then the weapon is consumed. Only one weapon can be held at a time.

---

### Armor (Shields)

| Name | Value | Color | Description |
|------|-------|-------|-------------|
| **Shield** | 1-3 | Gray | Defensive equipment that restores HP. |

**Effect**: Heals you for the shield's value. In Dungeon Cards style, shields act as "armor" that absorbs damage before it reaches you.

---

### Utilities (Consumables)

| Type | Value Range | Color | Description |
|------|-------------|-------|-------------|
| **Potion** | +3 to +6 | Green | Magical healing elixir. Restores HP instantly. |
| **Gold** | 5-15 | Yellow | Precious coins. Track your high score! |

---

### Exit (Floor Progression)

| Type | Color | Description |
|------|-------|-------------|
| **EXIT** | Cyan | Stairs to the next dungeon floor. |

**Effect**: Stepping on the EXIT card advances you to the next floor. The board resets with new cards and difficulty increases.

**Spawn Condition**: The EXIT card appears when you're within **5 steps** of the floor goal. Each move counts as 1 step towards the exit (default: 15 steps per floor).

---

## Floor Progress

- Each floor requires **15 steps** before the exit appears
- A progress bar shows: `Exit: X/15`
- When within 5 steps of the goal, an **EXIT** card spawns
- Reaching the EXIT advances to the next floor
- Each new floor resets progress but keeps your stats (HP, Gold, Attack)

---

## Player Stats

| Stat | Starting Value | Description |
|------|----------------|-------------|
| **HP** | 10 | Your life force. Reach 0 and it's game over. |
| **ATK** | 1 | Damage dealt to monsters per clash. |
| **Gold** | 0 | Currency collected. Measures your success! |
| **Floor** | 1 | Current dungeon depth. Higher = harder enemies. |

---

## Strategy Tips

1. **Weapons First**: Prioritize picking up weapons early - they make monster fights trivial
2. **HP Management**: Don't clash with monsters when low HP unless you can one-shot them
3. **Calculate Damage**: Monster HP - Your ATK = Damage you'll take (if positive)
4. **Route Planning**: Look at all 4 adjacent cards before moving
5. **Gold is Score**: Collect gold to track your best runs

---

## Difficulty Scaling

As you progress through floors:
- Monster HP increases by +1 per floor
- Weapon ATK increases slightly
- Potion healing increases
- Gold rewards increase

---

## Controls

| Input | Action |
|-------|--------|
| **Mouse Click** | Select adjacent card to move/clash |
| **Arrow Keys** | Move in direction |
| **Enter** | Start game / Restart |
| **ESC** | Quit game |

---

## Future Card Ideas

### More Monsters
- **Skeleton** - Undead warrior, high HP
- **Ghost** - Phasing creature, requires magic to hit
- **Mimic** - Disguised as treasure, surprise attack!
- **Dragon** - Boss monster, massive HP pool

### Special Cards
- **Fireball** - Deal damage to all adjacent monsters
- **Teleport** - Swap position with any card on board
- **Poison** - Monster takes damage over multiple turns
- **Chest** - Contains random loot (weapon, gold, or trap!)

### Trap Cards
- **Spike Trap** - Deals flat damage when stepped on
- **Curse** - Reduces ATK temporarily
- **Pit** - Instant death if HP below threshold
