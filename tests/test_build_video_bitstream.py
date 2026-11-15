import contextlib
import io
import json
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest
from unittest.mock import patch

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / 'tools'))
import build_video_bitstream as build


class BuildVideoTest(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        self.saved = dict(device='card.img', reference='HUDVIDEO.BIN', sha256='video',
                          mbr_sha256='mbr', lba=1234, file_sectors=77,
                          width=160, height=120, fps=1, sequence_id='sequence')
        self.map = self.root / 'map.json'
        self.map.write_text(json.dumps(self.saved))

    def test_portable_build_and_mounting_profile(self):
        for mounting, script in [('original', 'build_sd_video.tcl'),
                ('mpu-left90-mag-right90-front180-hdg-plus90', 'build_attitude_capture.tcl'),
                ('mpu-left90-mag-right90-front180-hdg-minus90', 'build_attitude_capture.tcl')]:
            with self.subTest(mounting=mounting), \
                    patch.object(sys, 'argv', ['build', str(self.root/'out'), '--map', str(self.map),
                                              '--mounting', mounting]), \
                    patch.object(build.shutil, 'which', return_value='/tools/vivado'), \
                    patch.object(build, 'inspect', return_value=self.saved), \
                    patch.object(build.subprocess, 'run') as run:
                run.return_value.returncode = 0
                self.assertEqual(build.main(), 0)
                command = run.call_args.args[0]
                self.assertEqual(command[0], '/tools/vivado')
                self.assertTrue(any(arg.endswith('/scripts/'+script) for arg in command))
                args = command[command.index('-tclargs')+1:]
                self.assertEqual(len(args), 8 if mounting=='original' else 9)
                self.assertEqual(args[-1], 'mapped' if mounting=='original' else mounting)
                self.assertIn('1234', command)

    def test_changed_map_blocks_vivado(self):
        with patch.object(sys, 'argv', ['build', str(self.root/'out'), '--map', str(self.map)]), \
                patch.object(build.shutil, 'which', return_value='/tools/vivado'), \
                patch.object(build, 'inspect', return_value={**self.saved, 'lba': 1235}), \
                patch.object(build.subprocess, 'run') as run, \
                contextlib.redirect_stderr(io.StringIO()) as errors:
            with self.assertRaises(SystemExit) as caught:
                build.main()
            self.assertEqual(caught.exception.code, 2)
            self.assertIn('Mapa mudou: lba', errors.getvalue())
            run.assert_not_called()

    def synthesis_args(self, script, mounting, half, kind):
        root = Path(__file__).resolve().parents[1]
        harness = self.root/'capture.tcl'
        harness.write_text('''
proc set_param {args} {}
proc create_project {args} {}
proc read_verilog {args} {}
proc read_xdc {args} {}
proc synth_design {args} {puts $args; exit 0}
set script [lindex $argv 0]
set argv [lrange $argv 1 end]
source $script
''')
        return subprocess.run(['tclsh', str(harness), str(root/'scripts'/script),
            str(self.root/'out'), '1000', '13501', str(half), '320', '30',
            str(root/'tests/hud_aircraft_64.hex'), kind, *([mounting] if mounting else [])],
            text=True, capture_output=True)

    def test_compass_rotation_reaches_synthesis_without_changing_other_generics(self):
        effective = []
        for suffix in ('plus90', 'minus90'):
            result = self.synthesis_args('build_attitude_capture.tcl',
                'mpu-left90-mag-right90-front180-hdg-'+suffix, 125, 'mapped')
            self.assertEqual(result.returncode, 0, result.stderr)
            args = result.stdout.split()
            effective.append(dict(args[i+1].split('=', 1) for i, arg in enumerate(args)
                                  if arg == '-generic'))
            (self.root/'out').rmdir()
        before, after = effective
        self.assertEqual(set(before), set(after))
        self.assertEqual({k for k in before if before[k] != after[k]},
                         {'MAG_INVERTER_X', 'MAG_INVERTER_Y'})
        self.assertEqual(after['MAG_INVERTER_X'], '1')
        self.assertEqual(after['MAG_INVERTER_Y'], '1')

    def test_unqualified_spi_is_rejected_before_creating_build(self):
        for script, mounting in [('build_sd_video.tcl', None),
                ('build_attitude_capture.tcl', 'mpu-left90-mag-right90-front180-hdg-minus90')]:
            for half in (1, 2):
                for kind in ('simulation', 'mapped'):
                    with self.subTest(script=script, half=half, kind=kind):
                        result = self.synthesis_args(script, mounting, half, kind)
                        self.assertNotEqual(result.returncode, 0)
                        self.assertIn('Perfil fora do limite', result.stderr)
                        self.assertFalse((self.root/'out').exists())


if __name__ == '__main__':
    unittest.main()
