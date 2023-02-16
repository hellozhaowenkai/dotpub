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


import os
import json
import pathlib
import argparse
import logging


# ==================================================
# Constants
# ==================================================


VERSION = "1.3.9"

ROOT_PATH = pathlib.Path(__file__).resolve().parent

COUNTER_DIRNAME = "counter"
COUNTER_PATH = ROOT_PATH / COUNTER_DIRNAME

BACKUPS_DIRNAME = "backups"
BACKUPS_PATH = ROOT_PATH / BACKUPS_DIRNAME

FORMULA_FLAG = "\uF7A5"  # Nerd Fonts: nf-mdi-glass_mug
FORMULA_INFO_FILENAME = "formula-info.json"
SUPPORTED_FORMULAE = sorted(
    [child.name for child in COUNTER_PATH.iterdir() if child.is_dir()]
)

LOGS_DIRNAME = "logs"
LOGS_PATH = ROOT_PATH / LOGS_DIRNAME
LOGS_FILENAME = "dotpub.log"
LOGGER = logging.getLogger()
SIMPLIFY = False
NORMAL = -1
LEFT_JUST_WIDTH = 15

ANSWERS = {"init_backups": None}


# ==================================================
# Utilities
# ==================================================


class ProgramError(Exception):
    pass


def log(message, level=NORMAL, disabled=False):
    """Colored output by ANSI escape codes."""

    color_map = {
        NORMAL: 4,  # Blue
        logging.INFO: 2,  # Green
        logging.WARNING: 3,  # Yellow
        logging.ERROR: 1,  # Red
    }

    print(f"\033[3{color_map[level]}m", end="", flush=True)
    print(message) if (level <= NORMAL or disabled) else LOGGER.log(level, message)
    print("\033[0m", end="", flush=True)


def get_target_formulae(args):
    if args.all:
        return SUPPORTED_FORMULAE

    if args.formulae:
        right, wrong = [], []
        for formula in args.formulae:
            container = right if formula in SUPPORTED_FORMULAE else wrong
            container.append(formula)

        if wrong:
            log(f"those formulae {wrong} are not supported.", logging.WARNING)
        return right

    log("please chose at last one formula to manage.", logging.ERROR)
    raise ProgramError()


def get_formula_info(formula):
    info_path = COUNTER_PATH / formula / FORMULA_INFO_FILENAME

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
            for sub_value in value:
                assert isinstance(sub_value, str), message
        # assert jsonschema.validate(formula_info, formula_info_schema), message

    except FileNotFoundError:
        log(f"{info_path}: file not found.", logging.ERROR)
    except json.decoder.JSONDecodeError:
        log(f"{info_path}: JSON decode error.", logging.ERROR)
    except KeyError as e:
        log(f"{info_path}: key {e} not found.", logging.ERROR)
    except AssertionError as e:
        log(f"{info_path}: format error, {e}.", logging.ERROR)

    else:
        return formula_info

    raise ProgramError()


def request_confirm(question_flag):
    message = """request confirm:
    Y): yes, do it and no need asking again for the same question anyway.
    y): yes, do it but just for this time.
    N): no, don't do it and no need asking again for the same question anyway.
    n): no, don't do it but just for this time.
    exit): exit, I will check it by myself.
(type your answer then press <Enter>): """
    answer = input(message)

    if answer == "exit":
        log(f"program exited by user.", logging.INFO)
        exit(0)
    elif answer == "Y":
        ANSWERS[question_flag] = True
        return True
    elif answer == "y":
        return True
    elif answer == "N":
        ANSWERS[question_flag] = False
        return False
    elif answer == "n":
        return False
    else:
        log(f"{answer}: unknown input, please type again.", logging.WARNING)
        return request_confirm(question_flag)


def init_backups(formula):
    backup_dir_path = BACKUPS_PATH / formula
    backup_dir_path.mkdir(parents=True, exist_ok=True)
    backup_paths = list(backup_dir_path.iterdir())

    if len(backup_paths) > 0:
        question_flag = "init_backups"
        log(f"question: {backup_dir_path} is not empty, do you want to empty it anyway?", logging.WARNING)
        if ANSWERS[question_flag] is None:
            answer = request_confirm(question_flag)
        else:
            answer = ANSWERS[question_flag]
        log(f"answer: {'yes' if answer else 'no'}.", logging.INFO)

        if not answer:
            return

    for backup_path in backup_paths:
        backup_path.unlink()


def path_resolver(path_segments: list[str]):
    for (index, value) in enumerate(path_segments):
        if not value.startswith("$"):
            continue

        if (env_value := os.environ.get(value[1:])) is not None:
            path_segments[index] = env_value
        else:
            log(
                f"{value}: unknown environment variable, please checkout your path section specified in {FORMULA_INFO_FILENAME}.",
                logging.WARNING,
            )
            return None

    return pathlib.Path(*path_segments).expanduser()


def yield_dotfiles(formula, formula_info):
    counter_dir_path = COUNTER_PATH / formula

    yielded_dotfiles = set()
    for (pattern, path_segments) in formula_info.get("path", {}).items():
        if (system_dir_path := path_resolver(path_segments)) is None:
            continue

        for counter_path in counter_dir_path.glob(pattern):
            if counter_path.match(".DS_Store"):
                continue
            if counter_path.match(FORMULA_INFO_FILENAME):
                continue
            if counter_path.is_dir():
                continue

            if counter_path.is_symlink():
                log(
                    f"{counter_path}: symlinked dotfile is not supported",
                    logging.WARNING,
                )
                continue
            else:
                counter_path = counter_path.resolve()

            if counter_path in yielded_dotfiles:
                log(
                    f"{counter_path}: duplicate dotfile, please checkout your path section specified in {FORMULA_INFO_FILENAME}.",
                    logging.WARNING,
                )
                continue

            if not str(counter_path).startswith(str(counter_dir_path)):
                log(
                    f"{counter_path}: outside dotfile, please checkout your path specified in {FORMULA_INFO_FILENAME}.",
                    logging.WARNING,
                )
                continue

            yielded_dotfiles.add(counter_path)

            system_path = system_dir_path / counter_path.name
            backup_path = BACKUPS_PATH / formula / counter_path.name

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
        "-a",
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

    parser.set_defaults(formulae=[], handler=handler)
    return parser


# ==================================================
# Menu Command
# ==================================================


def list_formula(formula):
    log(f"{FORMULA_FLAG} {formula}")

    formula_info = get_formula_info(formula)

    if formula_info.get("disabled", False):
        log(f"disabled:".ljust(LEFT_JUST_WIDTH) + "True", logging.ERROR, True)

    for info in ["name", "version", "description", "website"]:
        print(f"{info}:".ljust(LEFT_JUST_WIDTH) + formula_info.get(info, "Not found."))

    print("")


def add_list_parser(subparsers):
    """Create the parser for the `menu` command."""

    parser = subparsers.add_parser(
        "menu",
        description="List the supported formulae.",
        help="list the supported formulae",
    )

    parser.add_argument(
        "-s",
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
    log(f"{counter.name}: doing resolve...", logging.INFO)
    if system.resolve() == counter:
        return False

    log(f"{counter.name}: doing backup...", logging.INFO)
    if system.is_symlink():
        backup.symlink_to(system.resolve())
        system.unlink()
    elif system.is_file():
        system.replace(backup)
    elif system.exists():
        log(f"{system.name}: unknown existed backup dotfile.", logging.ERROR)
        return False
    else:
        log(f"{system}: system file not exists.", logging.WARNING)
        system.parent.mkdir(parents=True, exist_ok=True)

    log(f"{counter.name}: doing mount...", logging.INFO)
    system.symlink_to(counter)

    return True


def mount_formula(formula):
    log(f"{FORMULA_FLAG} {formula}")

    formula_info = get_formula_info(formula)

    if formula_info.get("disabled", False):
        log(f"disabled:".ljust(LEFT_JUST_WIDTH) + "True", logging.ERROR, True)
        log(f"this formula `{formula}` is disabled.", logging.WARNING)
        print("")
        return

    log(f"{formula}: mount start...", logging.INFO)

    init_backups(formula)
    for config in yield_dotfiles(formula, formula_info):
        mount_dotfile(config["counter"], config["system"], config["backup"])

    log(f"{formula}: mount done.", logging.INFO)
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
    log(f"{counter.name}: doing resolve...", logging.INFO)
    if system.resolve() != counter:
        return False

    log(f"{counter.name}: doing unmount...", logging.INFO)
    system.unlink(missing_ok=True)

    log(f"{counter.name}: doing backup...", logging.INFO)
    if backup.is_symlink():
        system.symlink_to(backup.resolve())
    elif backup.is_file():
        backup.replace(system)
    elif backup.exists():
        log(f"{backup.name}: unknown existed backup dotfile.", logging.ERROR)
        return False
    else:
        log(f"{backup}: backup file not exists.", logging.WARNING)

    return True


def unmount_formula(formula):
    log(f"{FORMULA_FLAG} {formula}")

    formula_info = get_formula_info(formula)

    if formula_info.get("disabled", False):
        log(f"disabled:".ljust(LEFT_JUST_WIDTH) + "True", logging.ERROR, True)
        log(f"this formula `{formula}` is disabled.", logging.WARNING)
        print("")
        return

    log(f"{formula}: unmount start...", logging.INFO)

    for config in yield_dotfiles(formula, formula_info):
        unmount_dotfile(config["counter"], config["system"], config["backup"])
    init_backups(formula)

    log(f"{formula}: unmount done.", logging.INFO)
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
    print(r"@ dotfile:".ljust(LEFT_JUST_WIDTH), end="")
    print(counter.name)

    print(r"# counter:".ljust(LEFT_JUST_WIDTH), end="")
    if not SIMPLIFY:
        print(counter)
        print(r"# status:".ljust(LEFT_JUST_WIDTH), end="")
    log("enabled", logging.INFO, True)

    print(r"$ system:".ljust(LEFT_JUST_WIDTH), end="")
    if not SIMPLIFY:
        print(system)
        print(r"$ status:".ljust(LEFT_JUST_WIDTH), end="")
    if system.is_symlink() or system.is_file():
        if system.resolve() == counter:
            log("mounted", logging.INFO, True)
        else:
            log("not-mounted", logging.WARNING, True)
    elif system.exists():
        log("unknown-file", logging.ERROR, True)
    else:
        log("not-exists", logging.WARNING, True)

    print(r"% backup:".ljust(LEFT_JUST_WIDTH), end="")
    if not SIMPLIFY:
        print(backup)
        print(r"% status:".ljust(LEFT_JUST_WIDTH), end="")
    if backup.is_symlink() or backup.is_file():
        log("backed-up", logging.INFO, True)
    elif backup.exists():
        log("unknown-file", logging.ERROR, True)
    else:
        log("not-exists", logging.WARNING, True)

    print("")


def status_formula(formula):
    log(f"{FORMULA_FLAG} {formula}")

    formula_info = get_formula_info(formula)

    if formula_info.get("disabled", False):
        log(f"disabled:".ljust(LEFT_JUST_WIDTH) + "True", logging.ERROR, True)
    print("")

    for config in yield_dotfiles(formula, formula_info):
        status_dotfile(config["counter"], config["system"], config["backup"])

    print("")


def add_status_parser(subparsers):
    """Create the parser for the `tab` command."""

    parser = subparsers.add_parser(
        "tab",
        description="Show the supported formulae status.",
        help="show the supported formulae status",
    )

    parser.add_argument(
        "-s",
        "--simplify",
        action="store_true",
        help="simplifies the output",
    )

    def pre_processor(args):
        global SIMPLIFY
        SIMPLIFY = args.simplify

    parser = build_common_cmd(parser, status_formula, pre_processor=pre_processor)
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
        description="Serve fruity dotfiles for brew fans!",
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
    try:
        main()
    except KeyboardInterrupt:
        print("")
        log(f"program interrupted by user.", logging.ERROR)
        exit(1)
    except ProgramError:
        log(f"program exited by self.", logging.ERROR)
        exit(1)
    else:
        exit(0)
