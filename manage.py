#!/usr/bin/env python
"""Dotfiles' command-line utility for administrative tasks."""

import json
import pathlib
import argparse
import logging


VERSION = "1.0.0"

ROOT_PATH = pathlib.Path(__file__).resolve().parent

FORMULAE_DIRNAME = "formulae"
FORMULAE_PATH = ROOT_PATH / FORMULAE_DIRNAME
SUPPORTED_FORMULAE = [child.name for child in FORMULAE_PATH.iterdir() if child.is_dir()]

BACKUPS_DIRNAME = "backups"
BACKUPS_PATH = ROOT_PATH / BACKUPS_DIRNAME

FORMULA_INFO_FILENAME = "formula-info.json"


def get_target_formulae(args):
    if args.all:
        return SUPPORTED_FORMULAE

    elif args.formulae:
        right, wrong = [], []
        for formula in args.formulae:
            container = right if formula in SUPPORTED_FORMULAE else wrong
            container.append(formula)

        if wrong:
            logging.error(f"those formulae {wrong} are not supported!")

        return right

    else:
        logging.error(
            f"please chose at last one formula from {SUPPORTED_FORMULAE} to manage!"
        )
        return []


def get_formula_info(info_path):
    with info_path.open() as fp:
        formula_info = json.load(fp)

    # assert jsonschema.validate(instance, schema)
    return formula_info


def init_backup(formula):
    backup_dir_path = BACKUPS_PATH / formula
    backup_dir_path.mkdir(parents=True, exist_ok=True)
    for backup_path in backup_dir_path.iterdir():
        backup_path.unlink()


def yield_dotfile(formula):
    custom_dir_path = FORMULAE_PATH / formula
    backup_dir_path = BACKUPS_PATH / formula

    formula_info = get_formula_info(custom_dir_path / FORMULA_INFO_FILENAME)
    for (pattern, path_segments) in formula_info["path"].items():
        for custom_path in custom_dir_path.glob(pattern):
            if custom_path.match(FORMULA_INFO_FILENAME):
                continue

            system_path = pathlib.Path(*path_segments, custom_path.name).expanduser()
            backup_path = backup_dir_path / custom_path.name

            yield {
                "custom": custom_path,
                "system": system_path,
                "backup": backup_path,
            }


def mount_dotfile(custom, system, backup=None):
    logging.info(f"{custom.name}: doing resolve...")
    if system.resolve() == custom:
        return False

    logging.info(f"{custom.name}: doing backup...")
    if system.is_symlink():
        backup.symlink_to(system.resolve())
        system.unlink()
    elif system.is_file():
        system.replace(backup)
    elif system.exists():
        logging.error(f"{system.name}: unknown existed backup dotfile!")
        return False

    logging.info(f"{custom.name}: doing mount...")
    system.symlink_to(custom)

    return True


def mount_formula(formula):
    logging.info(f"{formula}: mount start...")

    init_backup(formula)
    for config in yield_dotfile(formula):
        mount_dotfile(config["custom"], config["system"], config["backup"])

    logging.info(f"{formula}: mount done.")


def mount_handler(args):
    formulae = get_target_formulae(args)
    for formula in formulae:
        mount_formula(formula)


def add_mount_parser(subparsers):
    """create the parser for the `mount` command"""

    mount_parser = subparsers.add_parser(
        "mount",
        description="Mount your formulae config files.",
        help="mount your formulae config files",
    )
    mount_parser.add_argument(
        "formulae",
        type=str,
        nargs="*",
        metavar="formulae",
        # choices=SUPPORTED_FORMULAE,
        help="chose the formulae those you want to manage",
    )
    mount_parser.add_argument(
        "--all",
        action="store_true",
        help="manage all of the formulae those be supported default",
    )
    mount_parser.set_defaults(func=mount_handler)
    return mount_parser


def unmount_dotfile(custom, system, backup=None):
    logging.info(f"{custom.name}: doing resolve...")
    if system.resolve() != custom:
        return False

    logging.info(f"{custom.name}: doing unmount...")
    system.unlink(missing_ok=True)

    logging.info(f"{custom.name}: doing backup...")
    if backup.is_symlink():
        system.symlink_to(backup.resolve())
    elif backup.is_file():
        backup.replace(system)
    elif backup.exists():
        logging.error(f"{backup.name}: unknown existed backup dotfile!")
        return False

    return True


def unmount_formula(formula):
    logging.info(f"{formula}: unmount start...")

    for config in yield_dotfile(formula):
        unmount_dotfile(config["custom"], config["system"], config["backup"])
    init_backup(formula)

    logging.info(f"{formula}: unmount done.")


def unmount_handler(args):
    formulae = get_target_formulae(args)
    for formula in formulae:
        unmount_formula(formula)


def add_unmount_parser(subparsers):
    """create the parser for the `unmount` command"""

    unmount_parser = subparsers.add_parser(
        "unmount",
        description="Unmount your formulae config files.",
        help="unmount your formulae config files",
    )
    unmount_parser.add_argument(
        "formulae",
        type=str,
        nargs="*",
        metavar="formulae",
        # choices=SUPPORTED_FORMULAE,
        help="chose the formulae those you want to manage",
    )
    unmount_parser.add_argument(
        "--all",
        action="store_true",
        help="manage all of the formulae those be supported default",
    )
    unmount_parser.set_defaults(func=unmount_handler)
    return unmount_parser


def init_sub_parser(parser):
    """create the sub-level parser"""

    subparsers = parser.add_subparsers(
        title="subcommands",
        metavar="action",
        description="Chose the action you want to execute.",
    )
    return subparsers


def init_top_parser():
    """create the top-level parser"""

    parser = argparse.ArgumentParser(
        description="KevInZhao's dotfiles manager.",
        epilog=f"%(prog)s, version: {VERSION}; author: KevInZhao.",
    )
    parser.add_argument(
        "-v",
        "--version",
        action="version",
        version=VERSION,
    )
    return parser


def main():
    """Run administrative tasks."""

    logging.basicConfig(format="%(levelname)s: %(message)s", level=logging.INFO)

    parser = init_top_parser()
    subparsers = init_sub_parser(parser)

    add_mount_parser(subparsers)
    add_unmount_parser(subparsers)

    # parse the args and call whatever function was selected
    args = parser.parse_args()
    args.func(args)


if __name__ == "__main__":
    main()
