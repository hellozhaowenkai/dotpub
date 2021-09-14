# ==================================================
# `.zprofile' is sourced in login shells, before `.zshrc'.
#
# Maintainer:
#   KevInZhao <hellozhaowenkai@gmail.com>
# Description:
#   Personal preference .zprofile file.
# Note:
#   It should contain commands that should be executed only in login shells.
# Sections:
#   - Formulae Configuration
# Repository:
#   - [DotPub](https://github.com/hellozhaowenkai/dotpub/)
# References:
#   - [What to put in your startup files](https://zsh.sourceforge.io/Guide/zshguide02.html)
# ==================================================


# ==================================================
# Formulae Configuration
# ==================================================

#
# [homebrew](https://brew.sh/)
#

# Add Homebrew to your PATH.
if [[ "$(uname -s)" == "Linux" ]]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
else
  eval "$(brew shellenv)"
fi

#
# [pyenv](https://github.com/pyenv/pyenv/)
#

# Run the output of `pyenv init --path` to enable shims.
eval "$(pyenv init --path)"
