#!/usr/bin/env python

# ==================================================
# Welcome to the DotPub!
#
# Maintainer:
#   KevInZhao <hellozhaowenkai@gmail.com>
# Description:
#   Serve fruity dotfiles for Homebrew formulae to everyone in the DotPub!
# Note:
#   You need Python 3.9 or greater to run the following script.
# Sections:
#   - Constants
#   - Utilities
#   - Menu Command
#   - Order Command
#   - Cancel Command
#   - Tab Command
#   - Main
# Repository:
#   - [DotPub](https://github.com/hellozhaowenkai/dotpub/)
# References:
#   - [Mackup](https://github.com/lra/mackup/)
#   - [Dotbot](https://github.com/anishathalye/dotbot/)
# ==================================================


import json
import pathlib
import argparse
import logging


# ==================================================
# Constants
# ==================================================


VERSION = "1.1.0"

ROOT_PATH = pathlib.Path(__file__).resolve().parent

COUNTER_DIRNAME = "counter"
COUNTER_PATH = ROOT_PATH / COUNTER_DIRNAME

BACKUPS_DIRNAME = "backups"
BACKUPS_PATH = ROOT_PATH / BACKUPS_DIRNAME

FORMULA_INFO_FILENAME = "formula-info.json"
SUPPORTED_FORMULAE = sorted(
    [child.name for child in COUNTER_PATH.iterdir() if child.is_dir()]
)

LOGS_DIRNAME = "logs"
LOGS_PATH = ROOT_PATH / LOGS_DIRNAME
LOGS_FILENAME = "dotpub.log"
LOGGER = logging.getLogger()


# ==================================================
# Utilities
# ==================================================


def get_target_formulae(args):
    if args.all:
        return SUPPORTED_FORMULAE

    if args.formulae:
        right, wrong = [], []
        for formula in args.formulae:
            container = right if formula in SUPPORTED_FORMULAE else wrong
            container.append(formula)

        if wrong:
            LOGGER.warning(f"those formulae {wrong} are not supported.")
        return right

    LOGGER.error("please chose at last one formula to manage.")
    exit(1)


def get_formula_info(info_path):

    try:
        with info_path.open() as fp:
            formula_info = json.load(fp)

        # Validate formula info.
        message = "`path` should be a dict whit a glob pattern as key and a pathlike list as value"
        path = formula_info["path"]
        assert isinstance(path, dict), message
        for (key, value) in path.items():
            assert isinstance(key, str), message
            assert isinstance(value, list), message
        # assert jsonschema.validate(formula_info, formula_info_schema), message

    except FileNotFoundError:
        LOGGER.error(f"{info_path}: File not found.")
    except json.decoder.JSONDecodeError:
        LOGGER.error(f"{info_path}: JSON decode error.")
    except KeyError as e:
        LOGGER.error(f"{info_path}: Key {e} not found.")
    except AssertionError as e:
        LOGGER.error(f"{info_path}: Format error, {e}.")

    else:
        return formula_info
    return exit(1)


def init_backups(formula):
    backup_dir_path = BACKUPS_PATH / formula
    backup_dir_path.mkdir(parents=True, exist_ok=True)
    for backup_path in backup_dir_path.iterdir():
        backup_path.unlink()


def yield_dotfile(formula):
    counter_dir_path = COUNTER_PATH / formula
    backup_dir_path = BACKUPS_PATH / formula

    formula_info = get_formula_info(counter_dir_path / FORMULA_INFO_FILENAME)
    for (pattern, path_segments) in formula_info.get("path", {}).items():
        for counter_path in counter_dir_path.glob(pattern):
            if counter_path.match(FORMULA_INFO_FILENAME):
                continue

            system_path = pathlib.Path(*path_segments, counter_path.name).expanduser()
            backup_path = backup_dir_path / counter_path.name

            yield {
                "counter": counter_path,
                "system": system_path,
                "backup": backup_path,
            }


def build_common_cmd(parser, action, pre_processor=None, post_processor=None):
    parser.add_argument(
        "formulae",
        type=str,
        nargs="*",
        metavar="formulae",
        # choices=SUPPORTED_FORMULAE,
        help="chose the formulae those you want to manage",
    )
    parser.add_argument(
        "--all",
        action="store_true",
        help="manage all of the formulae those be supported default",
    )

    def handler(args):
        if pre_processor is not None:
            pre_processor(args)

        formulae = get_target_formulae(args)
        for formula in formulae:
            action(formula)

        if post_processor is not None:
            post_processor(args)

        exit(0)

    parser.set_defaults(formulae=[], handler=handler)
    return parser


# ==================================================
# Menu Command
# ==================================================


def list_formula(formula):
    print("▶", f"{formula}")

    formula_info = get_formula_info(COUNTER_PATH / formula / FORMULA_INFO_FILENAME)
    for info in ["name", "version", "description", "website"]:
        print(f"{info}:", formula_info.get(info, "Not found."))

    print("")


def add_list_parser(subparsers):
    """Create the parser for the `menu` command."""

    parser = subparsers.add_parser(
        "menu",
        description="List the supported formulae.",
        help="list the supported formulae",
    )

    parser.add_argument(
        "--simplify",
        action="store_true",
        help="simplifies the output",
    )

    def pre_processor(args):
        if args.simplify:
            formulae = get_target_formulae(args)
            print(" ".join(formulae))
            exit(0)

    parser = build_common_cmd(parser, list_formula, pre_processor=pre_processor)
    return parser


# ==================================================
# Order Command
# ==================================================


def mount_dotfile(counter, system, backup=None):
    LOGGER.info(f"{counter.name}: doing resolve...")
    if system.resolve() == counter:
        return False

    LOGGER.info(f"{counter.name}: doing backup...")
    if system.is_symlink():
        backup.symlink_to(system.resolve())
        system.unlink()
    elif system.is_file():
        system.replace(backup)
    elif system.exists():
        LOGGER.error(f"{system.name}: unknown existed backup dotfile.")
        return False
    else:
        LOGGER.warning(f"{system}: system file not exists.")
        system.parent.mkdir(parents=True, exist_ok=True)

    LOGGER.info(f"{counter.name}: doing mount...")
    system.symlink_to(counter)

    return True


def mount_formula(formula):
    print("▶", f"{formula}")
    LOGGER.info(f"{formula}: mount start...")

    init_backups(formula)
    for config in yield_dotfile(formula):
        mount_dotfile(config["counter"], config["system"], config["backup"])

    LOGGER.info(f"{formula}: mount done.")
    print("")


def add_mount_parser(subparsers):
    """Create the parser for the `order` command."""

    parser = subparsers.add_parser(
        "order",
        description="Mount your formulae config files.",
        help="mount your formulae config files",
    )

    parser = build_common_cmd(parser, mount_formula)
    return parser


# ==================================================
# Cancel Command
# ==================================================


def unmount_dotfile(counter, system, backup=None):
    LOGGER.info(f"{counter.name}: doing resolve...")
    if system.resolve() != counter:
        return False

    LOGGER.info(f"{counter.name}: doing unmount...")
    system.unlink(missing_ok=True)

    LOGGER.info(f"{counter.name}: doing backup...")
    if backup.is_symlink():
        system.symlink_to(backup.resolve())
    elif backup.is_file():
        backup.replace(system)
    elif backup.exists():
        LOGGER.error(f"{backup.name}: unknown existed backup dotfile.")
        return False
    else:
        LOGGER.warning(f"{backup}: backup file not exists.")

    return True


def unmount_formula(formula):
    print("▶", f"{formula}")
    LOGGER.info(f"{formula}: unmount start...")

    for config in yield_dotfile(formula):
        unmount_dotfile(config["counter"], config["system"], config["backup"])
    init_backups(formula)

    LOGGER.info(f"{formula}: unmount done.")
    print("")


def add_unmount_parser(subparsers):
    """Create the parser for the `cancel` command."""

    parser = subparsers.add_parser(
        "cancel",
        description="Unmount your formulae config files.",
        help="unmount your formulae config files",
    )

    parser = build_common_cmd(parser, unmount_formula)
    return parser


# ==================================================
# Tab Command
# ==================================================


def status_dotfile(counter, system, backup=None):
    print("@", f"dotfile: {counter.name}")

    print("#", f"counter: {counter}")
    counter_status = "supported"
    print("#", f"status: {counter_status}")

    print("$", f"system: {system}")
    if system.is_symlink() or system.is_file():
        if system.resolve() == counter:
            system_status = "mounted"
        else:
            system_status = "not-mounted"
    elif system.exists():
        system_status = "unknown-file"
    else:
        system_status = "not-exists"
    print("$", f"status: {system_status}")

    print("%", f"backup: {backup}")
    if backup.is_symlink() or backup.is_file():
        backup_status = "backed-up"
    elif backup.exists():
        backup_status = "unknown-file"
    else:
        backup_status = "not-exists"
    print("%", f"status: {backup_status}")

    print("")


def status_formula(formula):
    print("▶", f"{formula}")

    for config in yield_dotfile(formula):
        status_dotfile(config["counter"], config["system"], config["backup"])

    print("")


def add_status_parser(subparsers):
    """Create the parser for the `tab` command."""

    parser = subparsers.add_parser(
        "tab",
        description="Show the supported formulae status.",
        help="show the supported formulae status",
    )

    parser = build_common_cmd(parser, status_formula)
    return parser


# ==================================================
# Main
# ==================================================


def init_sub_parser(parser):
    """Create the sub-level parser."""

    subparsers = parser.add_subparsers(
        title="subcommands",
        metavar="action",
        description="Chose the action you want to execute.",
    )
    return subparsers


def init_top_parser():
    """Create the top-level parser."""

    parser = argparse.ArgumentParser(
        description="Serve fruity dotfiles for Homebrew formulae to everyone in the DotPub!",
        epilog=f"%(prog)s, version: {VERSION}, maintainer: KevInZhao.",
    )
    parser.add_argument(
        "-v",
        "--version",
        action="version",
        version=VERSION,
    )
    return parser


def init_logger():
    global LOGGER

    LOGGER.setLevel(logging.INFO)
    formatter = logging.Formatter("%(asctime)s - %(levelname)s: %(message)s")

    stream_handler = logging.StreamHandler()
    stream_handler.setFormatter(formatter)
    LOGGER.addHandler(stream_handler)

    file_handler = logging.FileHandler(str(LOGS_PATH / LOGS_FILENAME))
    file_handler.setFormatter(formatter)
    LOGGER.addHandler(file_handler)


def main():
    """Run administrative tasks."""

    init_logger()

    parser = init_top_parser()
    subparsers = init_sub_parser(parser)

    add_list_parser(subparsers)
    add_mount_parser(subparsers)
    add_unmount_parser(subparsers)
    add_status_parser(subparsers)

    # Parse the arguments and call whatever function was selected.
    args = parser.parse_args()
    args.handler(args)


if __name__ == "__main__":
    main()
