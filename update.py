"""Prompt the user for an update every `UPDATE_INTERVAL`. This script does not
actually perform the update, it only returns an error code if an update is
needed, or 0 if not.
"""

import sys

from datetime import datetime, timedelta
from pathlib import Path

LAST_UPDATE_FILE = Path.home() / '.config/.last_update'
"""Timestamp file used to mark the last time a global update was performed"""

PENDING_UPDATE_LOCKFILE = Path.home() / '.config/.pending_fullupdate'
"""Lockfile that indicates that a pending update was interrupted"""

UPDATE_INTERVAL = timedelta(days=1)
"""Time interval without update prompt"""

def main():
    """docstring for main"""
    if PENDING_UPDATE_LOCKFILE.exists():
        print(f"Update in progress. If not, remove {PENDING_UPDATE_LOCKFILE} "
              "manually")
        return 0

    try:
        last_update = LAST_UPDATE_FILE.stat().st_mtime
    except FileNotFoundError:
        last_update = 0

    delta = datetime.now() - datetime.fromtimestamp(last_update)
    if delta > UPDATE_INTERVAL:
        ans = input(f"Last global update was {delta.days} day(s) ago. "
                    "Want to update? (Y/n)\n")
        if ans.strip().lower() in ('y', ''):
            return 1

    # no need to update: return 0
    return 0

if __name__ == '__main__':
    sys.exit(main())
