//------------------------------------------------------------------------------------------------------------------------
// lootall.nss - presses "Take all" in the loot window from a hotkey.
// Does nothing unless the inventory is open in loot mode, so it can never buy everything in a shop.
// Bound to a hotkey by System\Scripts\quickloot_hook.lua (default: SPACE).
//------------------------------------------------------------------------------------------------------------------------

void main()
{
    RunClientLua(
        "local p = g_GuiInGame and g_GuiInGame.lm_pNewInventoryPanel " +
        "if p and p.lm_bActive and p:IsLootOpen() and p.lm_pTransferPanel then " +
        "p.lm_pTransferPanel:TransferAll() end");
}
