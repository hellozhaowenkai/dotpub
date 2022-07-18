![Social Preview](https://repository-images.githubusercontent.com/380521993/394c2d67-915b-40ac-bfa7-901f93a4f4a1)

# DotPub

[![Maintainer](https://img.shields.io/badge/Maintainer-KevInZhao-42b983.svg)](https://github.com/hellozhaowenkai/)
[![Version](https://img.shields.io/github/v/tag/hellozhaowenkai/dotpub?label=Version)](https://github.com/hellozhaowenkai/dotpub/tags/)
[![Python](https://img.shields.io/badge/Python-%3E%3D3.9-success)](https://www.python.org/)
[![Code Style](https://img.shields.io/badge/Code%20Style-black-000000.svg)](https://github.com/psf/black/)
[![License](https://img.shields.io/github/license/hellozhaowenkai/dotpub?label=License)](LICENSE)
[![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-2.0-4baaaa.svg)](CODE_OF_CONDUCT.md)

🍻 Serve fruity dotfiles for brew fans! 🤩

- [Quickstart](#quickstart)
- [Usage](#usage)
- [What does it do?](#what-does-it-do)
- [References](#references)
- [Contributing](#contributing)
- [License](#license)

## Quickstart

DotPub makes mounting your dotfiles as easy as drinking:

> NOTE: You need Python 3.9 or greater to run the script below.

```bash
# Find the DotPub.
git clone https://github.com/hellozhaowenkai/dotpub.git

# Into the DotPub.
cd dotpub

# Then order a cup of drink from the publican.
python publican.py order vim

# Or just have a taste of all drinks we served!
python publican.py order --all
```

> NOTE: I'll regularly add new configurations so keep an eye on this repository as it grows and optimizes.

## Usage

```man
usage: publican.py [-h] [-v] action ...

Serve fruity dotfiles for brew fans!

optional arguments:
  -h, --help     show this help message and exit
  -v, --version  show program's version number and exit

subcommands:
  Chose the action you want to execute.

  action
    menu         list the supported formulae
    order        mount your formulae config files
    cancel       unmount your formulae config files
    tab          show the supported formulae status
```

### Menu (List)

```man
usage: publican.py menu [-h] [-s] [-a] [formulae ...]

List the supported formulae.

positional arguments:
  formulae        chose the formulae those you want to manage

optional arguments:
  -h, --help      show this help message and exit
  -s, --simplify  simplifies the output
  -a, --all       manage all of the formulae those be supported default
```

> Want to work with brew?<br>
> Try `brew info $(python publican.py menu -as)` now!

### Order (Mount)

```man
usage: publican.py order [-h] [-a] [formulae ...]

Mount your formulae config files.

positional arguments:
  formulae    chose the formulae those you want to manage

optional arguments:
  -h, --help  show this help message and exit
  -a, --all   manage all of the formulae those be supported default
```

### Cancel (Unmount)

```man
usage: publican.py cancel [-h] [-a] [formulae ...]

Unmount your formulae config files.

positional arguments:
  formulae    chose the formulae those you want to manage

optional arguments:
  -h, --help  show this help message and exit
  -a, --all   manage all of the formulae those be supported default
```

### Tab (Status)

```man
usage: publican.py tab [-h] [-s] [-a] [formulae ...]

Show the supported formulae status.

positional arguments:
  formulae        chose the formulae those you want to manage

optional arguments:
  -h, --help      show this help message and exit
  -s, --simplify  simplifies the output
  -a, --all       manage all of the formulae those be supported default
```

## What does it do?

Let's take `Vim` as an example.

All Vim stuff are store in `counter/vim/` folder:

- `formula-info.json` tell us where the config files should put to.
- others such as `.vimrc` are all Vim's config files.

### Mount

1. `rm backups/vim/*`
2. `mv ~/.vimrc backups/vim/.vimrc`
3. `ln -s counter/vim/.vimrc ~/.vimrc`

### Unmount

1. `rm ~/.vimrc`
2. `mv backups/vim/.vimrc ~/.vimrc`
3. `rm backups/vim/*`

## References

The idea is inspired by:

- [Mackup](https://github.com/lra/mackup/): Keep your application settings in sync.
- [Dotbot](https://github.com/anishathalye/dotbot/): A tool that bootstraps your dotfiles.

The social preview is designed by:

- [Canva](https://www.canva.com/): Collaborate & Create Amazing Graphic Design for Free
- [Figma](https://www.figma.com/): The Collaborative Interface Design Tool

Thanks to all of them!

## Contributing

Thanks for taking the time to contribute! Please check out our [Contributing Guidelines](CONTRIBUTING.md) for ways to offer feedback and contribute.

Trying to report a possible security vulnerability? Please check out our [Security Policy](SECURITY.md) for guidelines about how to proceed.

This project and everyone participating in it is governed by the [Contributor Covenant Code of Conduct](CODE_OF_CONDUCT.md).

## License

Licensed under the GNU Affero General Public License, Version 3.0.
See [`LICENSE`](LICENSE) and [`NOTICE`](NOTICE) for complete details.
