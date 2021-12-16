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
  # for Linux
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
else
  if [[ "$(uname -m)" == "x86_64" ]]; then
    # for macOS (Darwin) with Intel CPU (x86_64)
    eval "$(/usr/local/bin/brew shellenv)"
  else
    # for macOS (Darwin) with Apple Silicon CPU (arm64)
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
fi

#
# [pyenv](https://github.com/pyenv/pyenv/)
#

# Run the output of `pyenv init --path` to enable shims.
eval "$(pyenv init --path)"
