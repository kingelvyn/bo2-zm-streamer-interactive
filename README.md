## Streamer Mod V1 (BO2 Zombies – Plutonium) WIP

Mod for streamers to make their BO2 zombies experience more "interactive". Ideally will be connected to common streaming platforms (Twitch, Youtube, etc.). Tested only on Solo play. Inspired by @jamesaff mod (it is not publicly available)

### WIP
Basic functionality complete (mostly), searching for better alternatives to make this easily accessible.

### What this script does

- **Spin the wheel function** 
- **Weighted reward selection**
- **Rewards**:
  - Points (small/large)
  - Random weapon from a weapon pool
  - Random perk from a perk pool
  - Powerups: max ammo, insta-kill, fire sale
  - Receive all perks
- **Extras**:
  - Reward notification text
  - Per-player cooldown
  - Invalid reward rerolls (e.g. already has perk/weapon, obtain fallback reward)
- **Twitch Integration**:
  - Uses [Streamer.bot](https://streamer.bot/) for live twitch events
  - Currently uses a script to check how many spins are in queue, executes them 1 at a time


### File layout

Clone this repo into your `t6/mods/` folder for simplest installation.



