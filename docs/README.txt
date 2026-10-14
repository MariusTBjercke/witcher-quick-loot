WITCHER QUICK LOOT
"Take all" hotkey for The Witcher: Enhanced Edition (1.5, Steam / GOG)
=====================================================================================

Press Space in the loot window instead of clicking the "Take all" button. No external
program, no AutoHotkey, no trainer - everything runs inside the game's own script engine.

  SPACE  ->  Take all (only while a loot window is open)

It does exactly what the button does. It only acts while the inventory is open in loot
mode: in shops, in storage and everywhere else the key does nothing, so it can never buy
a shop's whole stock (tested in a shop).


INSTALLATION
------------
1. Copy the "Data" and "System" folders into your game folder, e.g.
     ...\steamapps\common\The Witcher Enhanced Edition\
   (merge with the existing folders).
2. Start the game. That's it - the hotkey is bound automatically on every launch.

Files installed:
  Data\Override\QuickLoot\              compiled script (.ncs) + its source (.nss)
  System\Scripts\quickloot_hook.lua     settings (hotkey, console)
  System\Scripts\testtools.lua          shared startup loader (see COMPATIBILITY)


CONFIGURATION
-------------
Open System\Scripts\quickloot_hook.lua in a text editor:

  local LOOT_ALL_KEY = "SPACE"   -- one engine key name, see below; false = unbound

When you change the key, the old key is unbound automatically on the next launch.

What the hotkey can be (limits of the engine's own "bindkey" command):
- One key, with no modifiers. Shift+Space and similar do not work.
- Only the engine's key names are accepted (case does not matter):
    A-Z, 0-9, F1-F12, NUMPAD0-NUMPAD9, NUMPADPLUS, NUMPADMINUS, NUMPADMULTIPLY,
    NUMPADDIVIDE, NUMPADDECIMAL, NUMPADENTER, INSERT, DELETE, HOME, END, PAGEUP,
    PAGEDOWN, PRINTSCREEN, LEFT_ARROW, RIGHT_ARROW, UP_ARROW, DOWN_ARROW, SPACE,
    TAB, BACK, RETURN, ESC, LEFTSHIFT, RIGHTSHIFT, LEFTCTRL, RIGHTCTRL, LEFTALT,
    RIGHTALT, MINUS, EQUALS, LBRACKET, RBRACKET, BACKSLASH, SEMICOLON, APOSTROPHE,
    GRAVE, COMMA, PERIOD, FORWARDSLASH, MOUSE_BUTTON0-2, JOYSTICK_BUTTON0-1
- Not available: CapsLock, extra mouse buttons (4/5), most gamepad buttons.
- Pick a key the game does not use. SPACE is free with the default controls, and so
  are V, B, N, K, O, P, Y, F4, F6, F7, F8, F10, F11, F12, 0, 9, the numpad keys,
  Insert, Home, End, Delete. Binding a key the game already uses is untested.

Tested: SPACE on the Steam version. The other names come from the engine's key table
and should work the same, but have not been tried one by one.


UNINSTALL
---------
1. Delete Data\Override\QuickLoot and System\Scripts\quickloot_hook.lua.
2. Also delete System\Scripts\testtools.lua, unless Witcher Speed Toggle is installed
   (it uses the same file).
3. Optionally delete System\keybinding.ini (the engine's saved key macros).


COMPATIBILITY / NOTES
---------------------
- System\Scripts\testtools.lua is a shared loader: the retail game runs it on startup
  but does not ship it. Witcher Speed Toggle 1.1.0+ ships the identical file, so the
  two mods can be installed in any order. Speed Toggle 1.0.0 ships an older version of
  that file - installing it after this mod turns the loot hotkey off, so update it.
  A mod from another author that replaces testtools.lua would break the hotkey - merge
  the two files by hand.
- Tested on the Steam version (1.5.0.1304) with DXVK.

HOW IT WORKS
------------
The game's startup Lua script calls PlayFile("testtools"), which is missing in the
retail release. This mod provides it as a small shared loader that runs
quickloot_hook.lua, which binds the key with the engine's built-in "bindkey" console
command to "runscript lootall". That NWScript calls the loot panel's own TransferAll()
(the function behind the "Take all" button) through RunClientLua, guarded by IsLootOpen().
