#!/usr/bin/env python
"""Just for test."""

import subprocess


def run(command):
    return subprocess.Popen(command)


def main():
    command = [
        "python",
        "manage.py",
        # "-v",
        "mount",
        # "unmount",
        # "-h",
        "pip",
        # "--all",
    ]
    run(command).communicate()


if __name__ == "__main__":
    main()
