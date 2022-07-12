from pathlib import Path
from solid import scad_render_to_file
import os
import tempfile
import re

LIBS_RE = re.compile("^(include <)[^>]+libs/(.*>;)")


def render(scad_object, filename=None, segments=60):
    if filename is None:
        filename = _output_filename()

    with tempfile.TemporaryDirectory() as tmp:
        tmp_filename = os.path.join(tmp, "file.scad")
        scad_render_to_file(
            scad_object, tmp_filename, file_header=f"$fn = {segments};\n\n"
        )

        with open(filename, "w") as out:
            with open(tmp_filename, "r") as input:
                for line in input.readlines():
                    line = LIBS_RE.sub("\\1\\2", line)
                    out.write(line)


def _output_filename():
    # try to get the filename of the calling module
    import __main__

    if hasattr(__main__, "__file__"):
        # not called from a terminal
        calling_file = Path(__main__.__file__).absolute()
        return calling_file.with_suffix(".scad")
    else:
        return "expsolid_out.scad"
