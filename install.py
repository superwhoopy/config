"""TODO"""

import argparse
import os
import sys

from functools import partial
from pathlib import Path

import colorama

################################################################################

CREATE_LINKS = {
    # shell configuration
    'zsh/zshrc': '.zshrc',
    'zsh/zshenv': '.zshenv',

    'aliases': '.aliases',
    'starship.toml': '.config/starship.toml',

    # git configuration
    'git/config': '.gitconfig',
    ('git/config.win' if os.name == 'nt'
     else 'git/config.linux'): '.gitconfig.os',
    'git/gitignore_global': '.gitignore_global',

    # ctags
    'conf.ctags': ('ctags.d/conf.ctags' if os.name == 'nt'
                   else '.config/ctags/conf.ctags'),

    # markdownlint
    'mdlrc': '.mdlrc',
}

CREATE_LINKS_WIN = {
    'glaze-wm': '.glaze-wm',
    'glzr': '.glzr'
}

CREATE_LINKS_NUX = {
    # i3
    'i3': '.config/i3',
    'i3status': '.config/i3status',
    'rofi': '.config/rofi',
    'lxterminal': '.config/lxterminal'
}

HERE = Path(__file__).parent.resolve()
################################################################################

HERE = Path(__file__).parent

_verbosity: bool = False

class Colors:
    OKBLUE = colorama.Fore.BLUE
    OKCYAN = colorama.Fore.CYAN
    OKGREEN = colorama.Fore.GREEN
    WARNING = colorama.Fore.YELLOW
    FAIL = colorama.Fore.RED
    ENDC = colorama.Style.RESET_ALL

def _cprint(msg: str, color):
    print(color + msg + Colors.ENDC)

warn = partial(_cprint, color=Colors.WARNING)
error = partial(_cprint, color=Colors.FAIL)

def info(msg):
    if _verbosity:
        _cprint(msg, color=Colors.OKBLUE)

################################################################################

def parse_args():
    """docstring for parse_args"""
    parser = argparse.ArgumentParser()

    parser.add_argument('--verbose', action='store_true')
    parser.add_argument('-n', '--dry-run', action='store_true')
    parser.add_argument('-f', '--force-overwrite', action='store_true',
                        help="""When the symlink to create exists already and is
                        a file, this option forces the removal of the file.
                        Without this option, the default behavior is to do
                        nothing, and leave the file as it  is""")

    return parser.parse_args()


def link_exists(src: Path, dst: Path):
    """Tell if the file `dst` exists and is a symlink to `src`"""
    return dst.is_symlink() and dst.resolve() == src.resolve()


def main():
    """docstring for main"""
    colorama.init()

    args = parse_args()
    global _verbosity
    _verbosity = args.verbose

    retcode = 0
    all_links = CREATE_LINKS.copy()
    all_links.update(CREATE_LINKS_WIN if os.name == 'nt' else CREATE_LINKS_NUX)

    # sanity check: look for files that are not listed

    # create symlinks
    created, skipped, errors = 0, 0, 0
    print(f'Installing {len(all_links)} files and directories...')
    if args.dry_run:
        info('--dry-run is set: nothing will actually happen - relax')

    for src, dst in all_links.items():
        src, dst = HERE / Path(src), Path.home() / Path(dst)

        if not src.exists():
            warn(f'source file {src} does not exist: skipping')
            errors += 1
            continue
        elif link_exists(src, dst):
            info(f'link exists, nothing to be done: {src} --> {dst}')
            skipped += 1
            continue
        elif dst.exists():
            warn(f'destination file exists: {dst}')
            if args.force_overwrite:
                warn('  replacing existing file with a symlink (-f)')
                if not args.dry_run:
                    dst.unlink()
            else:
                warn('  skipping: consider using --force-overwrite')
                continue

        print(f'creating link: {src} --> {dst}')
        try:
            if not args.dry_run:
                dst.parent.mkdir(parents=True, exist_ok=True)
                os.symlink(str(src.resolve()), str(dst.resolve()),
                           target_is_directory=src.is_dir())
        except OSError as exc:
            retcode = 1
            error(f'  FAILED! {str(exc)}')
            continue
        else:
            created += 1


    print(f'\n{created} new link(s), {skipped} skipped, {errors} error(s)')

    return retcode


if __name__ == '__main__':
    sys.exit(main())
