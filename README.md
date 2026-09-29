<div align="center">

# CP2077 Achievement Logic

**A standalone, read-only CET utility for inspecting Cyberpunk 2077's internal achievement layer.**

![Cyberpunk 2077 2.31](https://img.shields.io/badge/Cyberpunk%202077-2.31-00e5ff?style=for-the-badge)
![CET](https://img.shields.io/badge/CET-Required-fcee0a?style=for-the-badge)
![Read Only](https://img.shields.io/badge/Read%20Only-Yes-fcee0a?style=for-the-badge)
![Lua](https://img.shields.io/badge/Lua-100%25-fcee0a?style=for-the-badge)

</div>

---

CP2077 Achievement Logic reads Cyberpunk 2077's own achievement records through Cyber Engine Tweaks and exports the available data to a text file for analysis.

The utility reads `gamedataAchievement_Record` entries directly from the game and identifies the active service reported by `gameAchievementSystem`. It does not unlock achievements, change achievement progress, or modify save data.

The generated report includes the game's internal achievement IDs, display names, descriptions, localization keys, record classes, a compact lookup table, and a section containing achievement records useful for progression research.

---

## Features

- Reads Cyberpunk 2077's internal achievement records
- Exports the complete achievement catalog available through CET
- Records internal TweakDB achievement IDs
- Records display names and descriptions
- Records display-name and description localization keys
- Records REDengine record classes
- Identifies the active achievement service
- Generates a compact achievement lookup table
- Includes selected records useful for progression research
- Read-only
- Does not modify achievements or save data

---

## Installation

Place the `CP2077-Achievement-Logic` folder into:

```text
Cyberpunk 2077\bin\x64\plugins\cyber_engine_tweaks\mods
```

The folder should contain:

```text
init.lua
```

---

## Usage

Launch Cyberpunk 2077 and allow Cyber Engine Tweaks to initialize.

The utility automatically reads the game's achievement records and generates:

```text
AchievementProbe.txt
```

in the mod folder.

Reloading CET mods will regenerate the report.

---

## Requirements

- Cyberpunk 2077
- Cyber Engine Tweaks

---

## Compatibility

CP2077 Achievement Logic reads Cyberpunk 2077's own achievement layer rather than relying on a hardcoded storefront achievement list.

The utility reports whichever achievement service the running game exposes through `gameAchievementSystem`.

---

## Credits

Created by Big2What.

Developed as a standalone research utility during work on Cynosure Terminal.
