#!/usr/bin/env python

# ==================================================
# Welcome to the DotPub!
#
# Maintainer:
#   KevInZhao <hellozhaowenkai@gmail.com>
# Description:
#   Serve fruity dotfiles for brew fans!
# Note:
#   You need Python 3.9 or greater to run the following script.
# Sections:
#   - Test and Debug
# Repository:
#   - [DotPub](https://github.com/hellozhaowenkai/dotpub/)
# References:
#   - [Mackup](https://github.com/lra/mackup/)
#   - [Dotbot](https://github.com/anishathalye/dotbot/)
# ==================================================


import subprocess


# ==================================================
# Test and Debug
# ==================================================


def run(
    command,
):
    return subprocess.Popen(command)


def main():
    command = [
        "python",
        "publican.py",
        # "-v",
        # "menu",
        # "order",
        # "cancel",
        # "tab",
        "-h",
        # "vim",
        # "--all",
        # "--simplify",
    ]
    run(command).communicate()


if __name__ == "__main__":
    main()
