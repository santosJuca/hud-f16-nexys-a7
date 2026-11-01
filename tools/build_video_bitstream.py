#!/usr/bin/env python3
"""Reconfere mapa FAT32 em modo somente leitura e executa build local; nao programa a placa."""
import argparse
import json
from pathlib import Path
import subprocess
from map_sd_video import inspect


def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('output',type=Path)
    p.add_argument('--map',required=True,type=Path)
    p.add_argument('--read-half',type=int,choices=(125,50,25,13,6,5,4),default=125)
    a=p.parse_args()
    root=Path(__file__).resolve().parents[1]
    vivado=Path('/home/santojuca/AMD/2026.1/Vivado/bin/vivado')
    try:
        saved=json.loads(a.map.read_text())
        current=inspect(Path(saved['device']),Path(saved['reference']))
        for field in ('sha256','mbr_sha256','lba','file_sectors','width','height','fps','sequence_id'):
            if current[field]!=saved[field]:
                raise ValueError('Mapa mudou: '+field)
        if a.output.exists():
            raise ValueError('Diretorio de build ja existe')
        command=[str(vivado),'-mode','batch','-nojournal','-nolog','-source',str(root/'scripts/build_sd_video.tcl'),
                 '-tclargs',str(a.output.resolve()),str(current['lba']),str(current['file_sectors']),
                 str(a.read_half),str(current['width']),str(current['fps']),str(root/'tests/hud_aircraft_64.hex'),'mapped']
        return subprocess.run(command,cwd=root).returncode
    except (OSError,ValueError,KeyError) as exc:
        p.exit(2,str(exc)+'\n')


if __name__=='__main__':
    raise SystemExit(main())
