# DotPub

🍻 Serve fruity dotfiles for Homebrew formulae to everyone in the DotPub! 🤩

- [Quickstart](#quickstart)
- [Usage](#usage)
- [What does it do](#what-does-it-do)
- [References](#references)
- [License](#license)

## Quickstart

DotPub makes mounting your dotfiles as easy as drinking:

> Note: You need Python 3.9 or greater to run the command below.

```bash
# Find the DotPub.
git clone https://github.com/hellozhaowenkai/dotpub/

# In to the DotPub.
cd dotpub

# Then order a cup of drink from the publican.
python publican.py order vim

# Or drink all things we served.
python publican.py order --all
```

## Usage

```man
usage: publican.py [-h] [-v] action ...

Serve fruity dotfiles for Homebrew formulae to everyone in the DotPub!

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
usage: publican.py menu [-h] [--all] [formulae ...]

List the supported formulae.

positional arguments:
  formulae    chose the formulae those you want to manage

optional arguments:
  -h, --help  show this help message and exit
  --all       manage all of the formulae those be supported default
```

### Order (Mount)

```man
usage: publican.py order [-h] [--all] [formulae ...]

Mount your formulae config files.

positional arguments:
  formulae    chose the formulae those you want to manage

optional arguments:
  -h, --help  show this help message and exit
  --all       manage all of the formulae those be supported default
```

### Cancel (Unmount)

```man
usage: publican.py cancel [-h] [--all] [formulae ...]

Unmount your formulae config files.

positional arguments:
  formulae    chose the formulae those you want to manage

optional arguments:
  -h, --help  show this help message and exit
  --all       manage all of the formulae those be supported default
```

### Tab (Status)

```man
usage: publican.py tab [-h] [--all] [formulae ...]

Show the supported formulae status.

positional arguments:
  formulae    chose the formulae those you want to manage

optional arguments:
  -h, --help  show this help message and exit
  --all       manage all of the formulae those be supported default
```

## What does it do

Let's take Vim as an example.

All Vim stuff are store in `dotpub/counter/vim` folder:

- `formula-info.json` tell us where the config files should put to.
- others such as `.vimrc` are all Vim's config files.

### Mount

1. `rm dotpub/backups/vim/*`
2. `mv ~/.vimrc dotpub/backups/vim/.vimrc`
3. `ln -s dotpub/counter/vim/.vimrc ~/.vimrc`

### Unmount

1. `rm ~/.vimrc`
2. `mv dotpub/backups/vim/.vimrc ~/.vimrc`
3. `rm dotpub/backups/vim/*`

## References:

Thanks to:

- [Mackup](https://github.com/lra/mackup/)
- [Dotbot](https://github.com/anishathalye/dotbot/)

## License

Licensed under the GNU Affero General Public License, Version 3.0.
