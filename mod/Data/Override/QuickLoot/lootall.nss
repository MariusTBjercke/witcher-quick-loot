//------------------------------------------------------------------------------------------------------------------------
// lootall.nss - hotkey entry point for Witcher Quick Loot.
// The logic lives in Lua (QuickLoot_TakeAllOrPause in System\Scripts\quickloot_hook.lua), so it can be
// changed without recompiling: Take all in the loot window, otherwise the key's normal pause.
// Bound to a hotkey by System\Scripts\quickloot_hook.lua (default: SPACE).
// tools/build_lootall_ncs.py writes the matching .ncs without needing the game's compiler.
//------------------------------------------------------------------------------------------------------------------------

void main()
{
    RunClientLua("QuickLoot_TakeAllOrPause()");
}
