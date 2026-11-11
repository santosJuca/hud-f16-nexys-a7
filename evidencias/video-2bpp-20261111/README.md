# Evidencias da candidata 640x480 2 bpp (simulacao, sem placa)

- `logs/`: baseline SPI (25/25), suite Icarus 2 bpp/RGB332 (21/21, commit 73c91ff), top_reticula 2 bpp (PASS, 2 de 12 modos, commit 61a7f19) e lint Verilator (bpp8 base x experimental, bpp2).
- `top_2bpp_modo0.png`, `top_2bpp_modo1.png`: saida VGA simulada do top completo (HUD real + fundo 2 bpp sintetico).
- `previa-sintetica/`: previa e comparacoes de uma fonte SINTETICA (nao e o video real).
  Regenerar: `cd tools && python3 convert_video_nv2bpp.py <dir-novo> --synthetic --seconds 10`.
- Stubs de XPM/unisim foram usados nas simulacoes Icarus; repetir com XPM/unisims oficiais (xsim).

Proximo passo na maquina com o video: ver secao E de `VIDEO_640x480_2BPP.md`.
