"""Writes lootall.ncs by hand: main() { RunClientLua("<LUA_CALL>"); }

The game's own compiler (console: compile <path>.nss) needs debug mode. This script emits the
same bytecode it produces for this one-line script, so the .ncs can be rebuilt without the game.
Usage: python -I tools/build_lootall_ncs.py <output .ncs>
"""
import struct
import sys

LUA_CALL = "QuickLoot_TakeAllOrPause()"
ACTION_RUNCLIENTLUA = 0x02D2  # index of RunClientLua in System\Scripts\nwscriptdefn.nss

code = b"".join([
    b"\x1e\x00" + struct.pack(">i", 8),                       # JSR +8 -> main
    b"\x20\x00",                                              # RETN
    b"\x04\x05" + struct.pack(">H", len(LUA_CALL)) + LUA_CALL.encode("ascii"),  # CONSTS
    b"\x05\x00" + struct.pack(">HB", ACTION_RUNCLIENTLUA, 1),  # ACTION RunClientLua, 1 arg
    b"\x20\x00",                                              # RETN
])
header = b"NCS V1.0" + b"B"
ncs = header + struct.pack(">I", len(header) + 4 + len(code)) + code

open(sys.argv[1], "wb").write(ncs)
print(f"wrote {sys.argv[1]} ({len(ncs)} bytes)")
