"""Installation script: from a file install.json that gives a list of
source/destination paths relative to resp. the source and the installation
directory, create symbolic links."""

import argparse
import os
import sys
import tomlkit as tomllib
from pathlib import Path

HERE = Path(__file__).parent

INSTALL_FILE = 'install.toml'

def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('source_dir', type=Path)
    parser.add_argument('install_dir', type=Path)
    parser.add_argument('-f', '--force',
                        help="""Overwrite destination file if it exists""",
                        action='store_true')
    args = parser.parse_args()

    # sanity checks
    assert args.source_dir.is_dir()
    assert args.install_dir.is_dir()

    # use absolute paths
    source_dir = args.source_dir.resolve()
    install_dir = args.install_dir.resolve()
    install_file = source_dir / INSTALL_FILE
    assert install_file.is_file()

    # load JSON file
    print(f'reading from file {install_file}')
    with install_file.open('rb') as install_file_fd:
        install_dict = tomllib.load(install_file_fd)

    # create the symlinks
    for src, dst in install_dict.items():
        src_fullpath: Path = source_dir / src
        dst_fullpath: Path = install_dir / dst
        if args.force and dst_fullpath.exists():
            print(f'file exists: remove {dst_fullpath}')
            dst_fullpath.unlink()
        print(f'create symlink {src} ▶ {dst}')
        os.symlink(src_fullpath, dst_fullpath)

    print('Done')
    return 0

if __name__ == '__main__':
    sys.exit(main())
