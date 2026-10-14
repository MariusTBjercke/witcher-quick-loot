# AGENTS.md

Notes for agents and maintainers. User-facing docs are in `README.md` and `docs/README.txt` (the README shipped inside the zip).

This mod is the sibling of [witcher-speed-toggle](https://github.com/MariusTBjercke/witcher-speed-toggle), locally at `C:\Users\micro\source\repos\witcher-speed-toggle`. Its `AGENTS.md` holds the full reverse-engineering notes: the console, the script compiler, `bindkey` and `keybinding.ini`, the Ghidra addresses, and the startup hook. They are not repeated here.

## Project at a glance

A mod for The Witcher: Enhanced Edition 1.5 that adds a hotkey (default Space) which presses **Take all** in the loot window.

| Path | What |
|---|---|
| `mod/` | Mirrors the game folder. Copy its contents into the game folder to install. |
| `mod/Data/Override/QuickLoot/lootall.nss` | The script: one `RunClientLua` call |
| `mod/Data/Override/QuickLoot/lootall.ncs` | **Compiled** script. It is committed because compiling needs the game, so keep it in sync with the `.nss`. |
| `mod/System/Scripts/testtools.lua` | **Shared loader**, byte-identical with witcher-speed-toggle's |
| `mod/System/Scripts/quickloot_hook.lua` | This mod's settings (key, console). It calls `ModHooks_BindScripts({ lootall = KEY })` |
| `docs/README.txt` | The README shipped in the zip, renamed README_WitcherQuickLoot.txt so it cannot clash with sibling mods |
| `docs/local/` | Git-ignored local notes (Nexus draft) |
| `tools/package-release.ps1` | Builds `dist/WitcherQuickLoot-<version>.zip` (version from `CHANGELOG.md`) |
| `tools/luac50dis.py` | Lua 5.0 disassembler for the game's `.luc` files |

## Build, test, release

- **Compile** (needs the game). Set `ENABLE_CONSOLE = true` in the installed `quickloot_hook.lua`, start the game, type `` ` ``, then run `compile ..\Data\Override\QuickLoot\lootall.nss`. **Check where the `.ncs` lands.** During development it once ended up in `Data\Override\` instead of next to the source. A stray copy there would also load, so move it into `QuickLoot\` and delete the `.ndb`. Restart the game to pick up a recompiled script.
- **Test:** open a loot window and press Space. The items should move exactly as with the button. Space must do nothing outside a loot window, and nothing in a shop or in storage. Outside a loot window and in a shop were confirmed in game for 1.0.0. Test from a clean install of the zip with no `System\keybinding.ini`.
- **Package and release:** `powershell -File tools\package-release.ps1`, then `gh release create vX.Y.Z dist\WitcherQuickLoot-X.Y.Z.zip ...`.

## Findings

- The loot window is the inventory panel in transfer mode: `g_GuiInGame.lm_pNewInventoryPanel`, in `System\Scripts\gui_new_inventory.luc`. Its sub-panel `lm_pTransferPanel` (`CGuiNewTransferPanel`) has `TransferAll()`. That function calls `g_GuiInGame:Inv_TransferAllItemsToPlayer(container, skinning)` and equips what fits, and it is what the **Take all** button ends up calling. The path is `gui_defs_inv_v2.luc` → `OnClick = g_GuiLayoutManager:PerformButtonAction('TransferAllButton')` → a closure that calls `transferPanel:TransferAll()`.
- `CGuiNewInventoryPanel:IsLootOpen()` compares a file-local transfer status with `TRANSFER_STATUS_LOOT`. The other statuses are `NONE`, `STORE`, `STORAGE` and `TRANSFERALL`, so checking it keeps the hotkey out of shops and storage. `lm_bActive` tells whether the inventory is open at all.
- `gui_new_inv_autoloot.luc` (`lm_pNewInvAutoLootPanel`, `Inv_AutoTransferAll`) is a different, timed auto-transfer panel. It is not the window with the button.
- Key macros (`bindkey`) still fire while the inventory GUI is open. This was confirmed in game.

## Shared loader rules

- `mod/System/Scripts/testtools.lua` must stay **byte-identical** across all mods that ship it. The game's Lua cannot list a folder (there is no `CFileFind` or directory binding), so the loader names every hook in `HOOKS`. A new mod that uses the loader adds its hook name there; then bump the "loader version" comment and release every mod that ships the loader.
- In a hook's settings, `false` unbinds a key. `nil` drops the entry from the table, so a previous binding is never cleaned up.
