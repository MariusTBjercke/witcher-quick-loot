# Witcher Quick Loot

A **Take all** hotkey for the loot window in **The Witcher: Enhanced Edition**. Press Space instead of reaching for the button with the mouse. Outside the loot window Space still pauses the game as before. There is no external program, AutoHotkey or trainer: everything runs inside the game's own script engine.

| Key | Where | Action |
|---|---|---|
| `Space` | Loot window | Take all |
| `Space` | Shop or storage | Nothing (it can never buy a shop's whole stock) |
| `Space` | Anywhere else | Pause / unpause, exactly like the game's own Space |

- **Take all** calls the same game function as the button.
- **Pause** sends the same pause toggle the game's Space key sends, so the pause menu and unpausing behave as in the vanilla game. As in vanilla, Space does not pause while another panel (map, journal, …) is open.
- All three cases were tested in game.

> **Also part of [Witcher Engine Fix](https://github.com/MariusTBjercke/witcher-enginefix).** Since Engine Fix 0.6.0 the same hotkey is built in (`[qol] quick_loot` in its ini). If you use Engine Fix, you do not need this mod. Keeping both is fine: while Quick Loot is installed, its settings are used and Engine Fix stays out of the way.

## Requirements

- The Witcher: Enhanced Edition, patch **1.5** (Steam or GOG, Director's Cut). Tested on Steam 1.5.0.1304.

## Installation

1. Download `WitcherQuickLoot-<version>.zip` from [Releases](https://github.com/MariusTBjercke/witcher-quick-loot/releases).
2. Extract the `Data` and `System` folders into your game folder and merge them with the existing ones, for example:
   `...\steamapps\common\The Witcher Enhanced Edition\`
3. Start the game. The hotkey is bound automatically on every launch.

Updating from 1.0.0: copy the new files over the old ones. That gives Space its pause back.

Files installed:

| Path | Purpose |
|---|---|
| `Data\Override\QuickLoot\` | Compiled hotkey script (`.ncs`) and its source (`.nss`) |
| `System\Scripts\quickloot_hook.lua` | Settings and the Take all / pause logic |
| `System\Scripts\testtools.lua` | Shared startup loader (see [Compatibility](#compatibility)) |

## Configuration

Edit `System\Scripts\quickloot_hook.lua`:

```lua
local LOOT_ALL_KEY = "SPACE"     -- one engine key name, see below; false leaves it unbound
local PAUSE_OUTSIDE_LOOT = true  -- the hotkey pauses/unpauses outside the loot window
local ENABLE_CONSOLE = false     -- true enables the developer console (` character)
```

When you change the key, the old key is unbound automatically on the next launch. If you move Take all to a key that should do nothing outside the loot window, set `PAUSE_OUTSIDE_LOOT = false`.

### What the hotkey can be

The hotkey uses the engine's own `bindkey` command, which has these limits:

- **A bound key no longer reaches the game.** The engine runs the binding *instead of* the key's normal action. That is why this mod performs Space's pause itself.
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
- **Other keys may have hidden jobs too.** Keys missing from the game's control settings can still be hard-wired. Space (pause) is one of them. With the default controls, `V B N K O P Y`, `F4 F6 F7 F8 F10 F11 F12`, `0 9`, the numpad keys, and `INSERT HOME END DELETE` are not in the control settings, but they have not each been checked for hard-wired actions.

What has been tested: `SPACE` on the Steam version.

## Uninstall

1. Delete `Data\Override\QuickLoot` and `System\Scripts\quickloot_hook.lua`.
2. Also delete `System\Scripts\testtools.lua`, unless [Witcher Speed Toggle](https://github.com/MariusTBjercke/witcher-speed-toggle) or [Witcher Engine Fix](https://github.com/MariusTBjercke/witcher-enginefix) is installed, because they use the same file.
3. Delete `System\keybinding.ini`, or remove its `SPACE runscript lootall` line. Otherwise the engine keeps the binding and Space stays without pause. With Witcher Engine Fix 0.6.0 or newer installed, skip this step: Engine Fix replaces the line on the next start.

## Compatibility

- `System\Scripts\testtools.lua` is a shared loader. It is the only Lua file the game runs on startup that the retail release does not ship. [Witcher Speed Toggle](https://github.com/MariusTBjercke/witcher-speed-toggle) (1.2.1 or newer) and [Witcher Engine Fix](https://github.com/MariusTBjercke/witcher-enginefix) ship the identical file (loader version 2), so the mods can be installed in any order. Speed Toggle **1.0.0** ships an older, single-mod version of that file: installing it after this mod turns the loot hotkey off. Speed Toggle 1.1.0 to 1.2.0 and Quick Loot 1.0.1 and older ship loader version 1, which does not run Engine Fix's hook: installing one of them after Engine Fix turns off its load/save-menu fix. Update both mods to the latest version. A mod from another author that replaces `testtools.lua` would break the hotkey; merge the two files by hand.
- **Witcher Engine Fix 0.6.0+** has this hotkey built in, under other names (`ef_lootall`, `EngineFix_QuickLoot`). When `quickloot_hook.lua` is installed, Engine Fix binds nothing and this mod's settings count, whichever was installed first; its log says `qol 4 (quick loot hotkey): Witcher Quick Loot is installed`. Both cases were tested in game.

## How it works

The game's startup Lua script (`startup.luc`) calls `g_Lua:PlayFile("testtools")`, but the retail release has no such file. This mod provides it as a small shared loader, which runs `quickloot_hook.lua`. The hook binds the key with the engine's built-in `bindkey` console command to `runscript lootall`. That one-line NWScript calls the Lua function `QuickLoot_TakeAllOrPause()` defined in the hook:

- In the loot window it calls the loot panel's own `TransferAll()`, the function behind the **Take all** button, guarded by `IsLootOpen()`.
- Elsewhere it calls `g_pClientExoApp:TogglePauseRequest()`. That is the engine's own pause toggle, the same one the Space key reaches.

Because the logic is in Lua, it can be changed without recompiling the script.

## Building a release

```powershell
powershell -File tools\package-release.ps1
```

This writes `dist\WitcherQuickLoot-<version>.zip`. The version is taken from `CHANGELOG.md`. `lootall.ncs` can be regenerated without the game with `python -I tools\build_lootall_ncs.py mod\Data\Override\QuickLoot\lootall.ncs`.

## License

[MIT](LICENSE). The Witcher is a trademark of CD PROJEKT S.A. This is an unofficial fan mod.
