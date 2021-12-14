"""TODO"""

import argparse
import enum
import os
import sys

from pathlib import Path

################################################################################

CREATE_LINKS = {
    # shell configuration
    'zsh/zshrc': '.zshrc',
    'aliases': '.aliases',
    'starship.toml': '.config/starship.toml',

    # git configuration
    'git/config': '.gitconfig',
    'git/gitignore_global': '.gitignore_global',

    # ctags
    'conf.ctags': ('ctags.d/conf.ctags' if os.name == 'nt'
                   else '.config/ctags/conf.ctags'),
}

CREATE_LINKS_WIN = {
}

CREATE_LINKS_NUX = {
    # i3
    'i3': '.config/i3',
    'i3status': '.config/i3status',
    'rofi': '.config/rofi'
}

HERE = Path(__file__).parent

################################################################################

class VerbosityLevel(enum.Enum):
    DEFAULT = 0
    VERBOSE = 1

verbosity: VerbosityLevel = VerbosityLevel.DEFAULT


def parse_args():
    """docstring for parse_args"""
    parser = argparse.ArgumentParser(
        # TODO
    )

    return parser.parse_args()


def link_exists(src: Path, dst: Path):
    """TODO"""
    return dst.is_symlink() and dst.resolve() == src.resolve()


def main():
    """docstring for main"""
    args = parse_args()

    retcode = 0
    all_links = CREATE_LINKS | (CREATE_LINKS_WIN if os.name == 'nt' else
                                CREATE_LINKS_NUX)

    # sanity check: look for files that are not listed

    # create symlinks
    created, skipped, errors = 0, 0, 0
    for src, dst in all_links.items():
        src, dst = HERE / Path(src), Path.home() / Path(dst)

        if not src.exists():
            print(f'warning! source file {src} does not exist: skipping')
            errors += 1
            continue
        elif link_exists(src, dst):
            print(f'link exists, nothing to be done: {src} --> {dst}')
            skipped += 1
            continue
        elif dst.exists():
            print(f'warning! destination file exists: {dst} will be overwritten')
            dst.unlink()

        print(f'creating link: {src} --> {dst}')
        try:
            dst.parent.mkdir(parents=True, exist_ok=True)
            os.symlink(str(src), str(dst), target_is_directory=src.is_dir())
        except OSError as exc:
            retcode = 1
            print(f'  FAILED! {str(exc)}')
            continue
        else:
            created += 1


    print(f'\n{created} new links, {skipped} skipped, {errors} errors')

    return retcode


if __name__ == '__main__':
    sys.exit(main())
