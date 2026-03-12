## Streamer Mod V1 (BO2 Zombies – Plutonium)

Simple spin-based reward system for BO2 Zombies on Plutonium.

### What this script does

- **Spin trigger input** via a `trigger_use` with `targetname` `streamer_spin_trig`.
- **Weighted reward selection** from a configurable reward table.
- **Rewards**:
  - Points (small/medium/large)
  - Random weapon from a weapon pool
  - Random perk from a perk pool
  - Powerups: max ammo, insta-kill, fire sale
- **Extras**:
  - Reward notification text (`iprintlnbold`)
  - Per-player cooldown
  - Invalid reward rerolls (e.g. already has perk/weapon)

### File layout

Place this folder here (which you already have if you’re reading this):

- `t6/scripts/zm/streamer-mod/streamer_mod.gsc`

### Including the script in a map / mod

You must:

1. **Include the script** in the GSC that your map/mod uses (for example your map’s main zombies script):

   ```c
   #include "scripts/zm/streamer-mod/streamer_mod.gsc"
   ```

2. **Thread the init function** from your map’s `main()` (or equivalent init function):

   ```c
   main()
   {
       // your existing init...
       level thread streamer_mod_init();
   }
   ```

3. **Add a trigger in the map** (Radiant):
   - Make a `trigger_use` where players will spin.
   - Set `targetname` to `streamer_spin_trig`.

When a player uses that trigger, they will perform a spin and receive a reward.

### Customizing rewards

Open `streamer_mod.gsc` and edit:

- **Weights & cooldown**
  - `streamer_setup_rewards()` – change reward weights.
  - `level.streamer_spin_cooldown_ms` in `streamer_mod_init()` – change per-player cooldown (ms).

- **Weapon pool**
  - In `streamer_reward_random_weapon()`:
    - Replace `level.streamer_weapon_pool` entries with valid weapon names for your mod/map.

- **Perk pool**
  - In `streamer_reward_random_perk()`:
    - Replace `level.streamer_perk_pool` entries with the perk identifiers you actually use.

- **Points API**
  - In `streamer_reward_points()`:
    - Adjust to match your scoring functions (e.g. `zm_add_points`, `zm_score_update`, etc.).

- **Powerup behavior**
  - In `streamer_reward_powerup()` / `streamer_spawn_powerup()`:
    - Swap to your own powerup spawning helpers if your project uses a different system.

Once those are set to real weapon/perk/powerup names and your scoring API, the mod should be ready to test in-game.

