"""TODO"""

import argparse
import re
import subprocess
from pathlib import Path
from functools import partial

import colorama


HERE = Path(__file__).parent
INSTALLED_TXT = HERE / 'installed.txt'
SCOOP_OUT_RE = re.compile(r'^(?P<package>\w+)\s+\d+.*$')

class Colors:
    OKBLUE = colorama.Fore.BLUE
    OKCYAN = colorama.Fore.CYAN
    OKGREEN = colorama.Fore.GREEN
    WARNING = colorama.Fore.YELLOW
    FAIL = colorama.Fore.RED
    ENDC = colorama.Style.RESET_ALL

def _cprint(msg: str, color):
    print(color + msg + Colors.ENDC)

info = partial(_cprint, color=Colors.OKBLUE)
warn = partial(_cprint, color=Colors.WARNING)
error = partial(_cprint, color=Colors.FAIL)



def set_str(s: frozenset[str]) -> str:
    return '\n'.join(f'  - {i}' for i in s)

def get_scoop_installed() -> frozenset[str]:
    """Returns a set with the names of installed scoop packages"""
    scoop_out = subprocess.run(
        ['scoop.cmd', 'list'], check=True, capture_output=True
    ).stdout.decode()
    return frozenset(
        match['package']
        for line in scoop_out.split('\n')
        if (match := SCOOP_OUT_RE.match(line)) is not None
    )


def read_recorded() -> frozenset[str]:
    with INSTALLED_TXT.open('r') as installed_f:
        return frozenset(line.strip() for line in installed_f.readlines())


def inspect(installed, recorded):
    if installed == recorded:
        print('  all good.')
        return

    print()

    if extraneous := installed - recorded:
        warn(f'⚠  Installed but not recorded:\n{set_str(extraneous)}')
        info(f'Run `scoop-sync record` to record {len(extraneous)} '
              'missing packages')
        print()

    if (missing := recorded - installed):
        warn(f'⚠  Recorded but not installed:\n{set_str(missing)}')
        info(f'Run `scoop-sync install` to install {len(missing)} '
              'missing packages')
        print()


def record(installed, recorded):
    missing = installed - recorded
    with INSTALLED_TXT.open('a') as installedf:
        installedf.write('\n'.join(missing))
    print(f'Recorded {len(missing)} new packages in {INSTALLED_TXT}')


def install(installed, recorded):
    missing = recorded - installed
    if not missing:
        info('Nothing to do')
        return

    ans = input(f'Installing {len(missing)} packages. Continue? (y/N)')
    if ans.strip().lower() != 'y':
        return

    subprocess.run(
        ['scoop.cmd', 'install'] + list(missing), check=True
    )


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    subparsers = parser.add_subparsers(required=True)

    inspect_parser = subparsers.add_parser('inspect')
    inspect_parser.set_defaults(func=inspect)

    record_parser = subparsers.add_parser('record')
    record_parser.set_defaults(func=record)

    install_parser = subparsers.add_parser('install')
    install_parser.set_defaults(func=install)

    args = parser.parse_args()

    info('Inspecting scoop packages…')
    installed = get_scoop_installed()
    recorded = read_recorded()
    args.func(installed, recorded)


if __name__ == "__main__":
    main()
