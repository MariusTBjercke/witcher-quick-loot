-- Witcher Quick Loot: settings. Run on every launch by the shared loader in testtools.lua.

-- Hotkey that presses "Take all" while a loot window is open: one engine key name (see README),
-- or false to leave it unbound.
local LOOT_ALL_KEY = "SPACE"

-- Developer console: lets the ` character open the console (needed only to recompile the script).
local ENABLE_CONSOLE = false

if ENABLE_CONSOLE then
    ModHooks_EnableConsole()
end

ModHooks_BindScripts({ lootall = LOOT_ALL_KEY })
