-- Witcher Quick Loot: settings and logic. Run on every launch by the shared loader in testtools.lua.

-- Hotkey: one engine key name (see README), or false to leave it unbound.
-- A bound key no longer reaches the game, so the mod does the key's normal job itself where it can:
-- with SPACE, it still pauses and unpauses the game outside the loot window.
local LOOT_ALL_KEY = "SPACE"

-- Pause/unpause with the hotkey when no loot window is open (the normal Space behaviour).
-- Set to false if you bind the mod to a key that should do nothing outside the loot window.
local PAUSE_OUTSIDE_LOOT = true

-- Developer console: lets the ` character open the console.
local ENABLE_CONSOLE = false

-- Called by lootall.ncs whenever the hotkey is pressed.
function QuickLoot_TakeAllOrPause()
    local gui = g_GuiInGame
    if not gui then return end

    -- Inventory open: Take all in loot mode; in shops and storage do nothing, as before.
    local inventory = gui.lm_pNewInventoryPanel
    if inventory and inventory.lm_bActive then
        if inventory:IsLootOpen() and inventory.lm_pTransferPanel then
            inventory.lm_pTransferPanel:TransferAll()
        end
        return
    end

    -- Otherwise send the same pause toggle as the game's own Space key. Unpausing always works;
    -- pausing is skipped while another panel (map, journal, ...) is open, like the vanilla key.
    if PAUSE_OUTSIDE_LOOT and g_pClientExoApp and (gui.lm_bUserPause or not gui:IsAnyPanelOpen()) then
        g_pClientExoApp:TogglePauseRequest()
    end
end

if ENABLE_CONSOLE then
    ModHooks_EnableConsole()
end

ModHooks_BindScripts({ lootall = LOOT_ALL_KEY })
