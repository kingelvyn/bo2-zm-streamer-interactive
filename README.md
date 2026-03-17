## Streamer Mod V0 (BO2 Zombies – Plutonium) WIP

Mod for streamers to make their BO2 zombies experience more interactive. Connects Twitch events directly to in-game rewards in BO2 Zombies on Plutonium. Tested only on Solo play. Inspired by @jamesaff mod (not publicly available).

### Status
Core functionality complete. Twitch integration working via native Node.js (no Streamer.bot required).

### What this mod does

- **Twitch Integration** — follows, subs, resubs, gift subs, and cheers all trigger a wheel spin
- **Spin the wheel** — weighted random reward selection
- **Rewards**:
  - Points (small/large)
  - Random weapon from a per-map weapon pool
  - Random perk from a perk pool
  - Powerups: Max Ammo, Insta-Kill, Fire Sale, Nuke, Carpenter, 2X Points
  - All Perks
- **Extras**:
  - Reward notification text in-game
  - Per-player cooldown
  - Fallback reward if selected reward fails
  - Manual spin via keybind (actionslot 1) for testing

### Requirements

- [Plutonium T6](https://plutonium.pw/) with a dedicated server
- [t6-gsc-utils](https://github.com/alicealys/t6-gsc-utils) plugin (place in `Plutonium/plugins/`)
- Node.js 18+
- A Twitch Developer Application ([dev.twitch.tv](https://dev.twitch.tv/console))

### Setup

1. Clone this repo
2. Copy `src/` contents to `%localappdata%/Plutonium/storage/t6/raw/scripts/zm/`
3. In the `bridge/` folder run `npm install`
4. Copy `bridge/.env.example` to `bridge/.env` and fill in your credentials
5. Run your dedicated server with `-experimental-utils` flag
6. Run `node bridge/bridge.js`

### File layout
```
bridge/         # Node.js Twitch bridge + queue consumer
src/            # GSC mod scripts (drop into Plutonium storage)
  streamer_mod/
    maps/       # Per-map weapon/perk pools
    wheel/      # Reward definitions and dispatch
```

### Environment Variables

Create `bridge/.env` with:
```
CLIENT_ID=
CLIENT_SECRET=
BROADCASTER_USERNAME=
RCON_PASSWORD=
```
```

Also create a `bridge/.env.example` file with empty values so other users know what's needed without exposing your secrets:
```
CLIENT_ID=
CLIENT_SECRET=
BROADCASTER_USERNAME=
RCON_PASSWORD=
ACCESS_TOKEN=
REFRESH_TOKEN=