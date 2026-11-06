#!/usr/bin/env python3
"""Reconfere mapa FAT32 em modo somente leitura e executa build local; nao programa a placa."""
import argparse
import json
from pathlib import Path
import subprocess
import shutil
from map_sd_video import inspect


def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('output',type=Path)
    p.add_argument('--map',required=True,type=Path)
    p.add_argument('--read-half',type=int,choices=(125,50,25,13,6,5,4),default=125)
    p.add_argument('--mounting', choices=('original', 'mpu-left90-mag-right90',
        'mpu-left90-mag-right90-front180', 'mpu-left90-mag-right90-front180-hdg-plus90',
        'mpu-left90-mag-right90-front180-hdg-minus90'),
        default='original', help='Perfil de montagem conferido; nao altera o mapa do cartao')
    a=p.parse_args()
    root=Path(__file__).resolve().parents[1]
    vivado=shutil.which('vivado')
    try:
        if vivado is None:
            raise ValueError('Vivado nao encontrado no PATH; carregue settings64.sh da instalacao')
        saved=json.loads(a.map.read_text())
        current=inspect(Path(saved['device']),Path(saved['reference']))
        for field in ('sha256','mbr_sha256','lba','file_sectors','width','height','fps','sequence_id'):
            if current[field]!=saved[field]:
                raise ValueError('Mapa mudou: '+field)
        if a.output.exists():
            raise ValueError('Diretorio de build ja existe')
        build_script='build_sd_video.tcl' if a.mounting=='original' else 'build_attitude_capture.tcl'
        command=[str(vivado),'-mode','batch','-nojournal','-nolog','-source',str(root/'scripts'/build_script),
                 '-tclargs',str(a.output.resolve()),str(current['lba']),str(current['file_sectors']),
                 str(a.read_half),str(current['width']),str(current['fps']),str(root/'tests/hud_aircraft_64.hex'),'mapped']
        if a.mounting!='original':
            command.append(a.mounting)
        return subprocess.run(command,cwd=root).returncode
    except (OSError,ValueError,KeyError) as exc:
        p.exit(2,str(exc)+'\n')


if __name__=='__main__':
    raise SystemExit(main())
