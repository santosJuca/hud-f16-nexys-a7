#!/usr/bin/env python3
"""Cria uma imagem regular de teste; nunca grava um dispositivo ou arquivo existente."""
import argparse
import hashlib
import os
from pathlib import Path

parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument("output", type=Path)
args = parser.parse_args()
payload = bytes(i % 256 ^ 0xA5 for i in range(512))
# O_EXCL também recusa links e dispositivos preexistentes.
fd = os.open(args.output, os.O_WRONLY | os.O_CREAT | os.O_EXCL, 0o600)
with os.fdopen(fd, "wb") as stream:
    stream.seek(2048 * 512)
    stream.write(payload)
data = args.output.read_bytes()
assert len(data) == 2049 * 512 and data[2048 * 512:] == payload
print(f"{hashlib.sha256(data).hexdigest()}  {args.output}")
