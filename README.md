# Witcher Quick Loot

A **Take all** hotkey for the loot window in **The Witcher: Enhanced Edition**. Press Space instead of reaching for the button with the mouse. There is no external program, AutoHotkey or trainer: everything runs inside the game's own script engine.

| Key | Action |
|---|---|
| `Space` | Take all (only while a loot window is open) |

- It does exactly what the **Take all** button does, by calling the same game function.
- It only acts while the inventory is open in **loot** mode. In shops, in storage and everywhere else the key does nothing, so it can never buy a shop's whole stock (tested in a shop).

## Requirements

- The Witcher: Enhanced Edition, patch **1.5** (Steam or GOG, Director's Cut). Tested on Steam 1.5.0.1304.

## Installation

1. Download `WitcherQuickLoot-<version>.zip` from [Releases](https://github.com/MariusTBjercke/witcher-quick-loot/releases).
2. Extract the `Data` and `System` folders into your game folder and merge them with the existing ones, for example:
   `...\steamapps\common\The Witcher Enhanced Edition\`
3. Start the game. The hotkey is bound automatically on every launch.

Files installed:

| Path | Purpose |
|---|---|
| `Data\Override\QuickLoot\` | Compiled script (`.ncs`) and its source (`.nss`) |
| `System\Scripts\quickloot_hook.lua` | Settings: hotkey and console |
| `System\Scripts\testtools.lua` | Shared startup loader (see [Compatibility](#compatibility)) |

## Configuration

Edit `System\Scripts\quickloot_hook.lua`:

```lua
local LOOT_ALL_KEY = "SPACE"  -- one engine key name, see below; false leaves it unbound
local ENABLE_CONSOLE = false  -- true enables the developer console (` character)
```

When you change the key, the old key is unbound automatically on the next launch.

### What the hotkey can be

The hotkey uses the engine's own `bindkey` command, which has these limits:

- **One key, with no modifiers.** Combinations such as Shift+Space are not supported.
- **Only the engine's key names are accepted.** Case does not matter:
  - `A`–`Z`, `0`–`9`, `F1`–`F12`
  - `NUMPAD0`–`NUMPAD9`, `NUMPADPLUS`, `NUMPADMINUS`, `NUMPADMULTIPLY`, `NUMPADDIVIDE`, `NUMPADDECIMAL`, `NUMPADENTER`
  - `INSERT`, `DELETE`, `HOME`, `END`, `PAGEUP`, `PAGEDOWN`, `PRINTSCREEN`
  - `LEFT_ARROW`, `RIGHT_ARROW`, `UP_ARROW`, `DOWN_ARROW`
  - `SPACE`, `TAB`, `BACK`, `RETURN`, `ESC`
  - `LEFTSHIFT`, `RIGHTSHIFT`, `LEFTCTRL`, `RIGHTCTRL`, `LEFTALT`, `RIGHTALT`
  - `MINUS`, `EQUALS`, `LBRACKET`, `RBRACKET`, `BACKSLASH`, `SEMICOLON`, `APOSTROPHE`, `GRAVE`, `COMMA`, `PERIOD`, `FORWARDSLASH`
  - `MOUSE_BUTTON0`–`MOUSE_BUTTON2`, `JOYSTICK_BUTTON0`, `JOYSTICK_BUTTON1`
- **Not available:** CapsLock, extra mouse buttons (4/5) and most gamepad buttons. The engine has no names for them.
- **Pick a key the game does not use.** `SPACE` is free with the default controls. So are `V B N K O P Y`, `F4 F6 F7 F8 F10 F11 F12`, `0 9`, the numpad keys, and `INSERT HOME END DELETE`. Binding a key the game already uses has not been tested. Expect both the game's action and the loot to happen.

What has been tested: `SPACE` on the Steam version. The other names come from the engine's key table and should work the same, but they have not been tried one by one.

## Uninstall

1. Delete `Data\Override\QuickLoot` and `System\Scripts\quickloot_hook.lua`.
2. Also delete `System\Scripts\testtools.lua`, unless [Witcher Speed Toggle](https://github.com/MariusTBjercke/witcher-speed-toggle) is installed, because it uses the same file.
3. Optionally delete `System\keybinding.ini`, which holds the engine's saved key macros.

## Compatibility

- `System\Scripts\testtools.lua` is a shared loader. It is the only Lua file the game runs on startup that the retail release does not ship. [Witcher Speed Toggle](https://github.com/MariusTBjercke/witcher-speed-toggle) (1.1.0 or newer) ships the identical file, so the two mods can be installed in any order. Speed Toggle **1.0.0** ships an older, single-mod version of that file: installing it after this mod turns the loot hotkey off, so update it to 1.1.0. A mod from another author that replaces `testtools.lua` would break the hotkey; merge the two files by hand.

## How it works

The game's startup Lua script (`startup.luc`) calls `g_Lua:PlayFile("testtools")`, but the retail release has no such file. This mod provides it as a small shared loader, which runs `quickloot_hook.lua`. The hook binds the key with the engine's built-in `bindkey` console command to `runscript lootall`. That NWScript uses `RunClientLua` to call the loot panel's own `TransferAll()`, the function behind the **Take all** button, guarded by `IsLootOpen()`.

## Building a release

```powershell
powershell -File tools\package-release.ps1
```

This writes `dist\WitcherQuickLoot-<version>.zip`. The version is taken from `CHANGELOG.md`.

## License

[MIT](LICENSE). The Witcher is a trademark of CD PROJEKT S.A. This is an unofficial fan mod.
