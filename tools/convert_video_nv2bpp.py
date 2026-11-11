#!/usr/bin/env python3
"""Converte video para HUDVIDEO.BIN 640x480, visao noturna verde, 2 bpp indexado (4 tons).

Experimental. Cria somente um diretorio NOVO; nunca altera a entrada.

Formato (HUDVID1, version=1, fmt=2):
  * setor 0: cabecalho de 512 bytes (mesma estrutura do RGB332) + paleta RGB332
    de 4 entradas nos bytes 56..59; bytes 60..511 zerados.
  * quadros brutos sem cabecalho, 76.800 bytes cada (exatamente 150 setores), a partir
    do setor 1. Linha y ocupa os bytes y*160 .. y*160+159.
  * cada byte guarda 4 pixels consecutivos da mesma linha: bits 7:6 = pixel x%4==0,
    5:4 = pixel 1, 3:2 = pixel 2, 1:0 = pixel 3 (byte = y*160 + x//4).
"""
import argparse
import binascii
import hashlib
import json
from pathlib import Path
import stat
import subprocess
import tempfile
import uuid

import numpy as np

from convert_video_for_fpga import HEADER, MAGIC, FMT_INDEXED2, PALETTE_OFFSET, parse_header

WIDTH, HEIGHT = 640, 480
FRAME_BYTES = WIDTH*HEIGHT//4
SECTORS_PER_FRAME = FRAME_BYTES//512
# Indice 0 preto, 1 verde muito escuro, 2 verde medio (terreno), 3 verde claro (detalhes).
# Verde maximo (G=7 -> 12'h0F0) fica reservado a simbologia do HUD.
DEFAULT_PALETTE = (0x00, 0x04, 0x0C, 0x10)
# Fracoes globais de luminancia (calculadas uma vez para o video inteiro).
DEFAULT_QUANTILES = (0.40, 0.75, 0.94)
DEFAULT_THRESHOLDS = (64, 128, 192)
DEFAULT_HYSTERESIS = 6


def rgb332_to_rgb12(value):
    """Mesma expansao do sd_video_background (RTL) para 4 bits por canal."""
    r, g, b = value >> 5 & 7, value >> 2 & 7, value & 3
    return (r << 1 | r >> 2) << 8 | (g << 1 | g >> 2) << 4 | (b << 2 | b)


def rgb12_to_rgb24(value):
    return bytes(((value >> s) & 15)*17 for s in (8, 4, 0))


def pack_indices(indices):
    """indices: array (480, 640) com valores 0..3 -> 76.800 bytes."""
    idx = np.asarray(indices, dtype=np.uint8)
    if idx.shape != (HEIGHT, WIDTH) or idx.max(initial=0) > 3:
        raise ValueError('Quadro indexado invalido')
    q = idx.reshape(HEIGHT, WIDTH//4, 4)
    return ((q[..., 0] << 6) | (q[..., 1] << 4) | (q[..., 2] << 2) | q[..., 3]).astype(np.uint8).tobytes()


def unpack_indices(frame):
    if len(frame) != FRAME_BYTES:
        raise ValueError('Quadro 2 bpp deve ter 76.800 bytes')
    b = np.frombuffer(frame, dtype=np.uint8).reshape(HEIGHT, WIDTH//4)
    return np.stack([(b >> 6) & 3, (b >> 4) & 3, (b >> 2) & 3, b & 3], axis=-1).reshape(HEIGHT, WIDTH)


def decode_rgb24(frame, palette):
    lut = np.array([list(rgb12_to_rgb24(rgb332_to_rgb12(p))) for p in palette], dtype=np.uint8)
    return lut[unpack_indices(frame)]


def quantize(luma, thresholds):
    t1, t2, t3 = thresholds
    l = luma.astype(np.int16)
    return ((l >= t1).astype(np.uint8) + (l >= t2) + (l >= t3)).astype(np.uint8)


def quantize_stable(luma, thresholds, previous, hysteresis):
    """Quantizacao com histerese temporal deterministica por pixel (reduz cintilacao)."""
    if previous is None or hysteresis == 0:
        return quantize(luma, thresholds)
    l = luma.astype(np.int16)
    low = quantize(np.clip(l - hysteresis, 0, 255), thresholds)
    high = quantize(np.clip(l + hysteresis, 0, 255), thresholds)
    return np.clip(previous, low, high).astype(np.uint8)


def probe(source):
    out = subprocess.run(['ffprobe', '-v', 'error', '-print_format', 'json', '-show_format',
                          '-show_streams', '-select_streams', 'v:0', str(source)],
                         stdout=subprocess.PIPE, stderr=subprocess.PIPE, check=True).stdout
    data = json.loads(out)
    s = data['streams'][0]
    sar = s.get('sample_aspect_ratio', '1:1')
    if sar in ('0:1', 'N/A'):
        sar = '1:1'
    num, den = (int(v) for v in sar.split(':'))
    rate_n, rate_d = (int(v) for v in s.get('avg_frame_rate', '0/1').split('/'))
    return dict(codec=s.get('codec_name'), width=int(s['width']), height=int(s['height']),
                sample_aspect_ratio=sar,
                display_aspect=round(int(s['width'])*num/(int(s['height'])*den), 6),
                fps=round(rate_n/rate_d, 6) if rate_d else None,
                duration_s=float(data['format'].get('duration', 'nan')),
                bytes=int(data['format'].get('size', 0)), pix_fmt=s.get('pix_fmt'))


def active_area(display_aspect, framing):
    """Retangulo ativo (x0, y0, w, h) apos escala sem distorcao."""
    if framing == 'crop' or abs(display_aspect - 4/3) < 1e-6:
        return 0, 0, WIDTH, HEIGHT
    if display_aspect > 4/3:
        h = int(round(WIDTH/display_aspect/2))*2
        return 0, (HEIGHT-h)//2, WIDTH, h
    w = int(round(HEIGHT*display_aspect/2))*2
    return (WIDTH-w)//2, 0, w, HEIGHT


def video_filter(framing, denoise, area):
    x0, y0, w, h = area
    chain = [f'scale={w}:{h}:flags=area,setsar=1'] if framing == 'letterbox' else \
        [f'scale={WIDTH}:{HEIGHT}:flags=area:force_original_aspect_ratio=increase',
         f'crop={WIDTH}:{HEIGHT}', 'setsar=1']
    if denoise:
        chain.append('hqdn3d=3:2:6:6')
    if framing == 'letterbox':
        chain.append(f'pad={WIDTH}:{HEIGHT}:{x0}:{y0}:black')
    return chain


def ffmpeg_inputs(source, synthetic, synthetic_size, start, seconds, fps):
    if synthetic:
        args = ['-f', 'lavfi', '-i', f'testsrc2=size={synthetic_size}:rate={fps}']
    else:
        args = (['-ss', str(start)] if start else []) + ['-i', str(source)]
    if seconds is not None:
        args += ['-t', str(seconds)]
    return args


def read_luma(inputs, filters, fps, max_frames=None):
    cmd = ['ffmpeg', '-v', 'error', '-nostdin', '-threads', '2', *inputs, '-an',
           '-vf', ','.join([f'fps={fps}', *filters, 'format=gray']),
           '-pix_fmt', 'gray', '-f', 'rawvideo', 'pipe:1']
    errors = tempfile.TemporaryFile()
    proc = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=errors)
    count = 0
    try:
        while max_frames is None or count < max_frames:
            raw = proc.stdout.read(WIDTH*HEIGHT)
            if not raw:
                break
            if len(raw) != WIDTH*HEIGHT:
                raise ValueError('Quadro de luminancia incompleto')
            count += 1
            yield np.frombuffer(raw, dtype=np.uint8).reshape(HEIGHT, WIDTH)
    finally:
        if proc.poll() is None:
            proc.kill()
        proc.wait()
        proc.stdout.close()
        if proc.returncode not in (0, -9) and max_frames is None:
            errors.seek(0)
            raise ValueError('FFmpeg falhou: '+errors.read().decode(errors='replace'))
        errors.close()
    return cmd


def calibrate(source, info, framing, denoise, area, samples, quantiles):
    """Limiares globais a partir de quadros espalhados pelo video inteiro."""
    x0, y0, w, h = area
    duration = info['duration_s']
    hist = np.zeros(256, dtype=np.int64)
    filters = video_filter(framing, denoise=False, area=area)
    for k in range(samples):
        t = duration*(k+0.5)/samples
        for luma in read_luma(['-ss', f'{t:.3f}', '-i', str(source)], filters, 30, max_frames=1):
            hist += np.bincount(luma[y0:y0+h, x0:x0+w].ravel(), minlength=256)
    cdf = np.cumsum(hist)/max(1, hist.sum())
    th = [int(np.searchsorted(cdf, q))+1 for q in quantiles]
    th = [min(max(v, 1), 255) for v in th]
    for i in (1, 2):
        th[i] = max(th[i], th[i-1]+1)
    return tuple(th), hist


def convert(output, source=None, synthetic=False, synthetic_size='1280x720', seconds=10.0,
            start=0.0, fps=30, framing='letterbox', palette=DEFAULT_PALETTE,
            thresholds=None, quantiles=DEFAULT_QUANTILES, calib_samples=48,
            hysteresis=DEFAULT_HYSTERESIS, denoise=True, preview=True, comparisons=(0, 90, 180, 270)):
    if len(palette) != 4 or len(set(palette)) != 4 or not all(0 <= p <= 255 for p in palette):
        raise ValueError('Paleta deve ter 4 entradas RGB332 distintas')
    if not 1 <= fps <= 60 or framing not in ('letterbox', 'crop'):
        raise ValueError('Perfil invalido')
    if synthetic:
        w, h = (int(v) for v in synthetic_size.split('x'))
        info = dict(codec='lavfi testsrc2 (sintetico)', width=w, height=h, sample_aspect_ratio='1:1',
                    display_aspect=round(w/h, 6), fps=fps, duration_s=seconds, bytes=0, pix_fmt=None)
        origin = f'FFmpeg testsrc2 {synthetic_size} (sintetico local, NAO e o video real)'
        source_sha = None
    else:
        if source is None or not stat.S_ISREG(Path(source).lstat().st_mode):
            raise ValueError('Entrada deve ser arquivo regular')
        source = Path(source).resolve()
        info = probe(source)
        origin = str(source)
        digest = hashlib.sha256()
        with source.open('rb') as s:
            for block in iter(lambda: s.read(1 << 20), b''):
                digest.update(block)
        source_sha = digest.hexdigest()
    area = active_area(info['display_aspect'], framing)
    x0, y0, aw, ah = area
    histogram = None
    if thresholds is None:
        if synthetic:
            thresholds = DEFAULT_THRESHOLDS
            threshold_origin = 'fixos (sintetico)'
        else:
            thresholds, histogram = calibrate(source, info, framing, denoise, area, calib_samples, quantiles)
            threshold_origin = f'quantis globais {list(quantiles)} sobre {calib_samples} quadros do video inteiro'
    else:
        threshold_origin = 'informados pelo usuario'
    thresholds = tuple(int(t) for t in thresholds)
    if not 0 < thresholds[0] < thresholds[1] < thresholds[2] <= 255:
        raise ValueError('Limiares devem ser crescentes em 1..255')

    output = Path(output)
    output.mkdir(mode=0o700)
    target = output/'HUDVIDEO.BIN'
    filters = video_filter(framing, denoise, area)
    inputs = ffmpeg_inputs(source, synthetic, synthetic_size, start, seconds, fps)
    sequence = uuid.uuid4().bytes
    frames, counts = [], np.zeros(4, dtype=np.int64)
    counts_active = np.zeros(4, dtype=np.int64)
    previous = None
    mask = np.zeros((HEIGHT, WIDTH), dtype=bool)
    mask[y0:y0+ah, x0:x0+aw] = True
    flips = []
    with target.open('xb') as out:
        out.write(bytes(512))
        for luma in read_luma(inputs, filters, fps):
            idx = quantize_stable(luma, thresholds, previous, hysteresis)
            idx[~mask] = 0  # faixas de letterbox sempre no indice 0 (preto)
            if previous is not None:
                flips.append(float(np.count_nonzero(idx != previous))/idx.size)
            previous = idx
            packed = pack_indices(idx)
            if 512+(len(frames)+1)*FRAME_BYTES > 0xffffffff:
                raise ValueError('Arquivo excede limite FAT32/RTL de 32 bits')
            out.write(packed)
            counts += np.bincount(idx.ravel(), minlength=4)
            counts_active += np.bincount(idx[mask].ravel(), minlength=4)
            frames.append({'index': len(frames), 'sha256': hashlib.sha256(packed).hexdigest(),
                           'sector_crc16': [f'{binascii.crc_hqx(packed[i:i+512], 0):04X}'
                                            for i in range(0, FRAME_BYTES, 512)]})
        if len(frames) < 2:
            raise ValueError('Video exige pelo menos dois quadros')
        total = 512+len(frames)*FRAME_BYTES
        header = bytearray(HEADER.pack(MAGIC, 1, 512, WIDTH, HEIGHT, fps, FMT_INDEXED2, len(frames),
                                       FRAME_BYTES, FRAME_BYTES, total, 1, sequence)+bytes(448))
        header[PALETTE_OFFSET:PALETTE_OFFSET+4] = bytes(palette)
        out.seek(0)
        out.write(header)
    whole = hashlib.sha256()
    with target.open('rb') as stream:
        for block in iter(lambda: stream.read(1 << 20), b''):
            whole.update(block)
    parsed = parse_header(bytes(header))
    palette_info = [{'index': i, 'rgb332': f'{p:02X}', 'rgb12': f'{rgb332_to_rgb12(p):03X}',
                     'rgb24': rgb12_to_rgb24(rgb332_to_rgb12(p)).hex().upper()}
                    for i, p in enumerate(palette)]
    (output/'palette.json').write_text(json.dumps({
        'entries': palette_info, 'hud_symbology_rgb12': '0F0',
        'nota': 'Verde maximo (G=7, 12h0F0) reservado ao HUD; video usa G<=4.'}, indent=2)+'\n')
    active_pixels = int(mask.sum())*len(frames)
    manifest = {**parsed, 'sha256': whole.hexdigest(), 'source': origin, 'source_sha256': source_sha,
                'source_probe': info, 'synthetic': synthetic, 'start_s': start, 'seconds': seconds,
                'framing': framing, 'active_area_xywh': list(area),
                'framing_note': ('sem faixas (fonte 4:3 ou recorte central)' if area == (0, 0, WIDTH, HEIGHT)
                                 else f'letterbox: faixas pretas (indice 0) fora de {list(area)}; sem recorte'),
                'thresholds_luma': list(thresholds), 'threshold_origin': threshold_origin,
                'hysteresis_luma': hysteresis, 'denoise': 'hqdn3d=3:2:6:6' if denoise else None,
                'ffmpeg_filters': [f'fps={fps}', *filters, 'format=gray'],
                'index_histogram': [int(c) for c in counts],
                'index_fraction_active': [round(float(c)/max(1, active_pixels), 4) for c in counts_active],
                'mean_pixel_change_fraction': round(float(np.mean(flips)), 5) if flips else 0.0,
                'pixel_order': 'byte=y*160+x//4; bits7:6=x%4==0, 5:4=1, 3:2=2, 1:0=3',
                'sectors_per_frame': SECTORS_PER_FRAME,
                'required_bytes_per_second': FRAME_BYTES*fps,
                'palette': palette_info, 'frames': frames, 'physical_validation': False}
    if histogram is not None:
        manifest['calibration_histogram'] = [int(v) for v in histogram]
    (output/'metadata.json').write_text(json.dumps(manifest, indent=2)+'\n')
    if preview:
        render_preview(output, palette, fps)
        render_comparisons(output, inputs, filters, fps, palette, comparisons, framing, area)
    return manifest


def render_preview(output, palette, fps):
    data = (output/'HUDVIDEO.BIN').read_bytes()
    count = parse_header(data[:512])['frame_count']
    cmd = ['ffmpeg', '-v', 'error', '-nostdin', '-f', 'rawvideo', '-pixel_format', 'rgb24',
           '-video_size', f'{WIDTH}x{HEIGHT}', '-framerate', str(fps), '-i', 'pipe:0',
           '-c:v', 'libx264', '-preset', 'veryfast', '-crf', '16', '-pix_fmt', 'yuv420p',
           str(output/'previa_nv2bpp.mp4')]
    proc = subprocess.Popen(cmd, stdin=subprocess.PIPE)
    for i in range(count):
        frame = data[512+i*FRAME_BYTES:512+(i+1)*FRAME_BYTES]
        proc.stdin.write(decode_rgb24(frame, palette).tobytes())
    proc.stdin.close()
    if proc.wait() != 0:
        raise ValueError('Falha ao gerar previa')


def hud_mock(rgb):
    """Simbologia ficticia em 12'h0F0 apenas para avaliar legibilidade (nao e captura VGA)."""
    img = rgb.copy()
    g = np.array([0, 255, 0], dtype=np.uint8)
    img[238:241, 160:280] = g
    img[238:241, 360:480] = g
    img[200:280, 318:321] = g
    for y in (180, 300):
        img[y:y+2, 250:300] = g
        img[y:y+2, 340:390] = g
    img[20:22, 220:420] = g
    for x in range(220, 421, 20):
        img[22:30, x:x+2] = g
    return img


def render_comparisons(output, inputs, filters, fps, palette, wanted, framing, area):
    from PIL import Image, ImageDraw
    data = (output/'HUDVIDEO.BIN').read_bytes()
    count = parse_header(data[:512])['frame_count']
    wanted = sorted({i for i in wanted if i < count})
    rgb_filters = [f for f in filters if not f.startswith('hqdn3d')]
    cmd = ['ffmpeg', '-v', 'error', '-nostdin', *inputs, '-an',
           '-vf', ','.join([f'fps={fps}', *rgb_filters, 'format=rgb24']),
           '-pix_fmt', 'rgb24', '-f', 'rawvideo', 'pipe:1']
    proc = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.DEVNULL)
    index, made = 0, []
    while wanted and index <= wanted[-1]:
        raw = proc.stdout.read(WIDTH*HEIGHT*3)
        if len(raw) != WIDTH*HEIGHT*3:
            break
        if index in wanted:
            orig = np.frombuffer(raw, dtype=np.uint8).reshape(HEIGHT, WIDTH, 3)
            nv = decode_rgb24(data[512+index*FRAME_BYTES:512+(index+1)*FRAME_BYTES], palette)
            canvas = Image.new('RGB', (WIDTH*3+20, HEIGHT+24), (40, 40, 40))
            for k, (img, label) in enumerate(((orig, 'origem escalada (sem distorcao)'),
                                              (nv, '2 bpp, 4 tons (decodificado do .BIN)'),
                                              (hud_mock(nv), '+ simbologia ficticia 0F0 (legibilidade)'))):
                canvas.paste(Image.fromarray(img), (k*(WIDTH+10), 24))
                ImageDraw.Draw(canvas).text((k*(WIDTH+10)+4, 6), label, fill=(230, 230, 230))
            name = output/f'comparacao_q{index:05d}.png'
            canvas.save(name)
            made.append(name.name)
        index += 1
    proc.kill()
    proc.wait()
    proc.stdout.close()
    return made


def main():
    p = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    p.add_argument('output', type=Path, help='diretorio novo (nao pode existir)')
    src = p.add_mutually_exclusive_group(required=True)
    src.add_argument('--input', type=Path)
    src.add_argument('--synthetic', action='store_true')
    p.add_argument('--synthetic-size', default='1280x720')
    p.add_argument('--seconds', type=float, default=10.0, help='duracao; use --full para o video inteiro')
    p.add_argument('--full', action='store_true')
    p.add_argument('--start', type=float, default=0.0)
    p.add_argument('--fps', type=int, default=30)
    p.add_argument('--framing', choices=('letterbox', 'crop'), default='letterbox')
    p.add_argument('--palette', default=','.join(f'{v:02X}' for v in DEFAULT_PALETTE),
                   help='4 entradas RGB332 em hexadecimal, indice 0..3')
    p.add_argument('--thresholds', help='t1,t2,t3 de luminancia (padrao: calibracao global)')
    p.add_argument('--calib-samples', type=int, default=48)
    p.add_argument('--hysteresis', type=int, default=DEFAULT_HYSTERESIS)
    p.add_argument('--no-denoise', action='store_true')
    p.add_argument('--no-preview', action='store_true')
    a = p.parse_args()
    try:
        info = convert(a.output, a.input, a.synthetic, a.synthetic_size,
                       None if a.full else a.seconds, a.start, a.fps, a.framing,
                       tuple(int(v, 16) for v in a.palette.split(',')),
                       tuple(int(v) for v in a.thresholds.split(',')) if a.thresholds else None,
                       DEFAULT_QUANTILES, a.calib_samples, a.hysteresis, not a.no_denoise,
                       not a.no_preview and not a.full)
        print(json.dumps({k: v for k, v in info.items() if k not in ('frames', 'calibration_histogram')}, indent=2))
    except (OSError, ValueError, subprocess.CalledProcessError) as exc:
        p.exit(2, str(exc)+'\n')


if __name__ == '__main__':
    main()
