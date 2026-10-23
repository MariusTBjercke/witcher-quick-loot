WITCHER QUICK LOOT
"Take all" hotkey for The Witcher: Enhanced Edition (1.5, Steam / GOG)
=====================================================================================

Press Space in the loot window instead of clicking the "Take all" button. Outside the
loot window Space still pauses the game as before. No external program, no AutoHotkey,
no trainer - everything runs inside the game's own script engine.

  SPACE in the loot window      ->  Take all
  SPACE in a shop or storage    ->  nothing (it can never buy a shop's whole stock)
  SPACE anywhere else           ->  pause / unpause, exactly like the game's own Space

Take all calls the same game function as the button. Pause sends the same pause toggle
the game's Space key sends; as in vanilla, it does not pause while another panel (map,
journal, ...) is open. All three cases were tested in game.


INSTALLATION
------------
1. Copy the "Data" and "System" folders into your game folder, e.g.
     ...\steamapps\common\The Witcher Enhanced Edition\
   (merge with the existing folders).
2. Start the game. That's it - the hotkey is bound automatically on every launch.

Updating from 1.0.0: copy the new files over the old ones. That gives Space its pause back.

Files installed:
  Data\Override\QuickLoot\              hotkey script (.ncs) + its source (.nss)
  System\Scripts\quickloot_hook.lua     settings + the Take all / pause logic
  System\Scripts\testtools.lua          shared startup loader (see COMPATIBILITY)


CONFIGURATION
-------------
Open System\Scripts\quickloot_hook.lua in a text editor:

  local LOOT_ALL_KEY = "SPACE"     -- one engine key name, see below; false = unbound
  local PAUSE_OUTSIDE_LOOT = true  -- the hotkey pauses/unpauses outside the loot window

When you change the key, the old key is unbound automatically on the next launch. If
you move Take all to a key that should do nothing outside the loot window, set
PAUSE_OUTSIDE_LOOT = false.

What the hotkey can be (limits of the engine's own "bindkey" command):
- A bound key no longer reaches the game: the engine runs the binding INSTEAD of the
  key's normal action. That is why this mod performs Space's pause itself.
- One key, with no modifiers. Shift+Space and similar do not work.
- Only the engine's key names are accepted (case does not matter):
    A-Z, 0-9, F1-F12, NUMPAD0-NUMPAD9, NUMPADPLUS, NUMPADMINUS, NUMPADMULTIPLY,
    NUMPADDIVIDE, NUMPADDECIMAL, NUMPADENTER, INSERT, DELETE, HOME, END, PAGEUP,
    PAGEDOWN, PRINTSCREEN, LEFT_ARROW, RIGHT_ARROW, UP_ARROW, DOWN_ARROW, SPACE,
    TAB, BACK, RETURN, ESC, LEFTSHIFT, RIGHTSHIFT, LEFTCTRL, RIGHTCTRL, LEFTALT,
    RIGHTALT, MINUS, EQUALS, LBRACKET, RBRACKET, BACKSLASH, SEMICOLON, APOSTROPHE,
    GRAVE, COMMA, PERIOD, FORWARDSLASH, MOUSE_BUTTON0-2, JOYSTICK_BUTTON0-1
- Not available: CapsLock, extra mouse buttons (4/5), most gamepad buttons.
- Keys missing from the game's control settings can still be hard-wired, like Space
  (pause). V, B, N, K, O, P, Y, F4, F6, F7, F8, F10, F11, F12, 0, 9, the numpad keys,
  Insert, Home, End and Delete are not in the default control settings, but have not
  each been checked for hard-wired actions.

Tested: SPACE on the Steam version.


UNINSTALL
---------
1. Delete Data\Override\QuickLoot and System\Scripts\quickloot_hook.lua.
2. Also delete System\Scripts\testtools.lua, unless Witcher Speed Toggle or Witcher
   Engine Fix is installed (they use the same file).
3. Delete System\keybinding.ini, or remove its "SPACE runscript lootall" line.
   Otherwise the engine keeps the binding and Space stays without pause.


COMPATIBILITY / NOTES
---------------------
- System\Scripts\testtools.lua is a shared loader: the retail game runs it on startup
  but does not ship it. Witcher Speed Toggle 1.2.1+ and Witcher Engine Fix
  (https://github.com/MariusTBjercke/witcher-enginefix) ship the identical file
  (loader version 3 since Speed Toggle 1.2.2 and Engine Fix 0.7.1), so the mods can
  be installed in any order. Version 3 binds the hotkey again after "Full screen" or
  the resolution is changed in the options. Speed Toggle 1.0.0
  ships an older version of that file - installing it after this mod turns the loot
  hotkey off. Speed Toggle 1.1.0 to 1.2.0 and Quick Loot 1.0.1 and older ship loader
  version 1, which does not run Engine Fix's hook - installing one of them after
  Engine Fix turns off its load/save-menu fix. Update both mods to the latest version.
  A mod from another author that replaces testtools.lua would break the hotkey - merge
  the two files by hand.
- Tested on the Steam version (1.5.0.1304) with DXVK.

HOW IT WORKS
------------
The game's startup Lua script calls PlayFile("testtools"), which is missing in the
retail release. This mod provides it as a small shared loader that runs
quickloot_hook.lua, which binds the key with the engine's built-in "bindkey" console
command to "runscript lootall". That one-line NWScript calls the Lua function
QuickLoot_TakeAllOrPause() in the hook: in the loot window it calls the loot panel's
own TransferAll() (the "Take all" button), elsewhere g_pClientExoApp:TogglePauseRequest()
(the engine's own pause toggle, the same one the Space key reaches).
