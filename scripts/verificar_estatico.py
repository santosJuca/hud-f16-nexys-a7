#!/usr/bin/env python3
"""P3A structural checks only; NOT an HDL elaboration or FPGA validation."""
from pathlib import Path
import re
import sys
import xml.etree.ElementTree as ET

root = Path(__file__).resolve().parents[1]
rtl = (root/"hud/rtl/top_reticula.sv").read_text()
xdc = (root/"hud/constraints/nexys_a7_reticula.xdc").read_text()
mig = ET.parse(root/"mig/mig_a.prj")

checks = {
    "MIG instanciado": bool(re.search(r"\bddr2_ui_smoke_top\b[\s\S]{0,650}\bu_ui_test\s*\(", rtl)),
    "HUD VGA original preservado": "sd_video_background" in rtl and "sd_sector_buffer" in rtl,
    "clock E3": bool(re.search(r"PACKAGE_PIN\s+E3\b", xdc)),
    "clock E3 usado no MIG": ".sys_clk_i(clk)" in rtl,
    "reset independente C12": bool(re.search(r"PACKAGE_PIN\s+C12\b", xdc)),
    "clock 200 MHz com MMCM": "MMCME2_BASE" in rtl and ".CLKOUT0(clk200_raw)" in rtl,
    "quatro LEDs exclusivos": all(f"DDR2_STATUS_LED[{i}]" in rtl for i in range(4)),
    "clock raiz nao hierarquico": "create_clock -name {u_ui_test/u_mig/sys_clk_i}" in xdc,
    "nenhum caminho DDR2 em scene_rgb": "assign DDR2_STATUS_LED[3] = smoke_error;" in rtl,
}
for name, ok in checks.items():
    print(("PASS" if ok else "FAIL") + ": " + name)

assigned = {}
for line in xdc.splitlines():
    if line.lstrip().startswith("#"):
        continue
    match = re.search(r"\bPACKAGE_PIN\s+(\w+)", line)
    if match:
        assigned.setdefault(match.group(1), []).append(line.strip())
duplicate = {pin: lines for pin,lines in assigned.items() if len(lines)>1}
# The DDR2 clock is E3 and shares the actual HDL clock port (not an extra pad).
mempins = {}
for pin in mig.iter("Pin"):
    name, loc = pin.attrib.get("name", ""), pin.attrib.get("PADName", "")
    if name.startswith("ddr2") and loc:
        mempins[loc] = name
collision = {pin:(name,assigned[pin]) for pin,name in mempins.items() if pin in assigned}
print("MIG DDR2 pins:", len(mempins))
print("HUD/P3A pins:", len(assigned))
print("Duplicate top pins:", duplicate)
print("DDR2 physical pin conflicts:", collision)
if not all(checks.values()) or duplicate or collision:
    sys.exit(1)
print("P3A_STATIC_CHECKS_PASS (not synthesized)")
