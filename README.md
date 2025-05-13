# RXT Store Robbery Script

A clean and synced **store robbery system** for ESX, QBCore, and standalone FiveM servers. Works with all configured stores, includes NPC reactions, cop alerts, zone checks, and full reward logic.

---

## Features

- Syncs with multiple stores
- Works with ESX, QBCore, and standalone
- Optional `ox_target` support
- Cop blip + sound alert on robbery
- Custom cooldown & robbery duration
- NPC shopkeeper panic animations
- Configurable rewards (money/items)
- Cancel if player leaves the area

---

## Dependencies

- [`ox_target`](https://github.com/overextended/ox_target) (recommended)
- `ox_lib` (for notifications)
- `ox_inventory` or cash system
- ESX Legacy or QBCore (auto-detected)

---

## Installation

1. **Drag & Drop** the folder `rxt_store_robbery` into your `resources` directory.
2. Add this to your `server.cfg`:
