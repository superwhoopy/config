"""TODO"""

import argparse
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
    # Windows terminal
    'windowsterminal-settings.json': 'AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json',
}

CREATE_LINKS_NUX = {
    # i3
    'i3': '.config/i3',
    'i3status': '.config/i3status',
    'rofi': '.config/rofi'
}

################################################################################

def parse_args():
    """docstring for parse_args"""
    parser = argparse.ArgumentParser(
        # TODO
    )

    return parser.parse_args()

def main():
    """docstring for main"""
    args = parse_args()

    retcode = 0
    all_links = CREATE_LINKS | (CREATE_LINKS_WIN if os.name == 'nt' else
                                CREATE_LINKS_NUX)

    # create symlinks
    for src, dst in all_links.items():
        src, dst = Path(src), Path(dst)
        print(f'creating link: {src} --> {dst}')
        try:
            os.symlink(str(src), str(dst), target_is_directory=src.is_dir())
        except OSError as exc:
            retcode = 1
            print(f'  FAILED! {str(exc)}')

    return retcode


if __name__ == '__main__':
    sys.exit(main())
