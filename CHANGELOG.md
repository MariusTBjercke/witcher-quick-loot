# Changelog

## 1.0.2

- Shared loader version 2: also runs Witcher Engine Fix's hook (`enginefix_hook`). `testtools.lua` is now identical in Witcher Speed Toggle 1.2.1 and Witcher Engine Fix, so installing this mod after Engine Fix no longer turns off Engine Fix's load/save-menu fix.

## 1.0.1

- Fixed: Space no longer lost its pause. A bound key never reaches the game, so outside the loot window the hotkey now sends the game's own pause toggle (`TogglePauseRequest`). In shops and storage it still does nothing.
- The Take all / pause logic moved to Lua (`QuickLoot_TakeAllOrPause` in `quickloot_hook.lua`); new setting `PAUSE_OUTSIDE_LOOT`.
- Docs: keys missing from the game's control settings can still be hard-wired, like Space.

## 1.0.0

- First release: Space presses "Take all" while a loot window is open, and does nothing anywhere else.
- The hotkey is bound automatically at startup and can be changed in `System\Scripts\quickloot_hook.lua`. A key that is changed there is unbound on the next launch.
- Ships the shared `testtools.lua` loader (loader version 1), identical in Witcher Speed Toggle 1.1.0.
