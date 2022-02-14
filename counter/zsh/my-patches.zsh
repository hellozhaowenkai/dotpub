#!/usr/bin/env zsh

# ==================================================
# Such customization `*.zsh' files will be loaded the last.
#
# Maintainer:
#   KevInZhao <hellozhaowenkai@gmail.com>
# Description:
#   Personal preference *.zsh file.
# Note:
#   Files on the `$ZSH_CUSTOM` directory will be automatically loaded by the init script, in alphabetical order.
# Sections:
#   - Custom Configuration
# Repository:
#   - [DotPub](https://github.com/hellozhaowenkai/dotpub/)
# References:
#   - [Z shell](https://zsh.sourceforge.io/)
#   - [Oh-My-Zsh](https://github.com/ohmyzsh/ohmyzsh/)
#   - [Zsh Guide](https://zshguide.readthedocs.io/)
# ==================================================


# ==================================================
# Custom Configuration
# ==================================================

#
# Oh-My-Zsh stuff.
#

# Installation.
function z-omz-install {
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

  return 0
}

#
# Homebrew stuff.
#

# Installation.
function z-brew-install {
  if [[ "$(uname -s)" == "Linux" ]] {
    # Dependencies for Debian or Ubuntu.
    sudo apt-get install build-essential procps curl file git
  } else {
    # Command Line Tools (CLT) for Xcode.
    xcode-select --install
  }

  if [[ $1 == "tuna" ]] {
    # Use TUNA mirror.
    git clone --depth=1 https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/install.git ~/brew-tuna
    /bin/bash ~/brew-tuna/install.sh
    rm -rf ~/brew-tuna
  } else {
    # The script explains what it will do and then pauses before it does it.
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  }

  # You’re done! Try installing a package:
  brew install hello

  return 0
}

# Set TUNA mirror.
function z-tuna-set {
  export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"
  git -C "$(brew --repo)" remote set-url origin https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git

  export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git"
  if [[ "$(uname -s)" == "Linux" ]] {
    brew tap --custom-remote --force-auto-update homebrew/core               https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git
    brew tap --custom-remote --force-auto-update homebrew/command-not-found  https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-command-not-found.git
  } else {
    brew tap --custom-remote --force-auto-update homebrew/core               https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git
    brew tap --custom-remote --force-auto-update homebrew/cask               https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-cask.git
    brew tap --custom-remote --force-auto-update homebrew/cask-fonts         https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-cask-fonts.git
    brew tap --custom-remote --force-auto-update homebrew/cask-drivers       https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-cask-drivers.git
    brew tap --custom-remote --force-auto-update homebrew/cask-versions      https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-cask-versions.git
    brew tap --custom-remote --force-auto-update homebrew/command-not-found  https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-command-not-found.git
  }

  brew update

  return 0
}

# Unset TUNA mirror.
function z-tuna-unset {
  unset HOMEBREW_BREW_GIT_REMOTE
  git -C "$(brew --repo)" remote set-url origin https://github.com/Homebrew/brew.git

  unset HOMEBREW_CORE_GIT_REMOTE
  if [[ "$(uname -s)" == "Linux" ]] {
    brew tap --custom-remote --force-auto-update homebrew/core               https://github.com/Homebrew/homebrew-core.git
    brew tap --custom-remote --force-auto-update homebrew/command-not-found  https://github.com/Homebrew/homebrew-command-not-found.git
  } else {
    brew tap --custom-remote --force-auto-update homebrew/core               https://github.com/Homebrew/homebrew-core.git
    brew tap --custom-remote --force-auto-update homebrew/cask               https://github.com/Homebrew/homebrew-cask.git
    brew tap --custom-remote --force-auto-update homebrew/cask-fonts         https://github.com/Homebrew/homebrew-cask-fonts.git
    brew tap --custom-remote --force-auto-update homebrew/cask-drivers       https://github.com/Homebrew/homebrew-cask-drivers.git
    brew tap --custom-remote --force-auto-update homebrew/cask-versions      https://github.com/Homebrew/homebrew-cask-versions.git
    brew tap --custom-remote --force-auto-update homebrew/command-not-found  https://github.com/Homebrew/homebrew-command-not-found.git
  }

  brew update

  return 0
}

# Install all my formulae via brew.
function z-formulae-install {
  if [[ $1 == "tuna" ]] {
    export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"
    export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git"
    export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles/"
  }

  brew update --preinstall

  for formula ($(python publican.py menu -as)) {
    echo ""
    echo "installing $formula"
    brew install $formula
    echo "done"
  }

  return 0
}

#
# NPM stuff.
#

# Private npm registry and web for Company.
alias z-npm-taobao="npm --registry=https://registry.npmmirror.com \
  --cache=$HOME/.npm/.cache/cnpm/ \
  --disturl=https://npmmirror.com/mirrors/node/ \
  --userconfig=$HOME/.cnpmrc"

# Fetch all outdated npm global packages list.
alias z-npm-update="npm -g outdated --depth=0 --parseable | cut -d: -f2"

# Upgrade outdated npm global packages.
function z-npm-upgrade {
  for package ($(z-npm-update)) {
    echo ""
    echo "upgrading $package"

    if [[ $1 == "taobao" ]] {
      z-npm-taobao -g install $package
    } else {
      npm -g install $package
    }

    echo "done"
  }

  return 0
}

#
# Remote stuff.
#

# Work together with other machines.
function z-share {
  local host=dell
  local action=pull
  if (($+2)) {
    host=$1
    action=$2
  } else {
    echo "error: place specify both host and action!"
    return 1
  }

  echo "host: $host"
  echo "action: $action"
  case $action {
    (pull)
      scp -r $host:'%HomePath%/Public/Shared/*' ~/Public/Shared/
      ;;

    (push)
      scp -r ~/Public/Shared/* $host:'%HomePath%/Public/Shared/'
      ;;

    (*)
      echo "error: $action, action not found!"
      return 1
      ;;
  }

  return 0
}

#
# Git stuff.
#

# Git LFS requires global configuration changes once per-machine.
alias z-git-lfs-install="git lfs install"

# Easy push.
function z-git-push {
  local remote_branch=kev-$(date "+%Y%m%d-%H%M%S")
  (($+1)) && remote_branch=$1

  echo "remote_branch: $remote_branch"
  git push origin HEAD:$remote_branch

  return 0
}

# Easy pull.
function z-git-pull {
  local remote_branch=master
  (($+1)) && remote_branch=$1

  echo "remote_branch: $remote_branch"
  git remote prune origin && git pull --rebase origin $remote_branch:

  return 0
}

# Easy fetch.
function z-git-fetch {
  local remote_branch=master
  (($+1)) && remote_branch=$1

  local local_branch=$(date "+%Y%m%d-%H%M%S")
  (($+2)) && local_branch=$2

  echo "remote_branch: $remote_branch"
  echo "local_branch: $local_branch"
  echo "start..." \
    && git remote prune origin \
    && git fetch --depth=1 origin $remote_branch:$local_branch \
    && git checkout $local_branch \
  && echo "done."

  return 0
}

# Easy commit.
function z-git-commit {
  local adjust_day=1
  (($+1)) && adjust_day=$1
  local right_hour=21
  (($+2)) && right_hour=$2
  local right_minute=30
  (($+3)) && right_minute=$3
  local right_date=$(date -R -v -"$adjust_day"d -v "$right_hour"H -v "$right_minute"M)

  [[ -z $right_date ]] && return 1

  echo "right_date: $right_date"
  echo "start..." \
    && export GIT_AUTHOR_DATE="$right_date" \
    && export GIT_COMMITTER_DATE="$right_date" \
    && git commit \
  && echo "done."

  return 0
}

# Easy amend.
function z-git-amend {
  local right_date=$(git log --pretty=format:"%ad" HEAD -1)

  echo "right_date: $right_date"
  echo "start..." \
    && export GIT_COMMITTER_DATE="$right_date" \
    && git commit --amend \
  && echo "done."

  return 0
}

# Easy organize.
function z-git-organize {
  local range=--all
  (($+1)) && range=$1

  # <commit_start>..<commit_end> -> (<commit_start>, <commit_end>]
  # e.g. `<commit_id>..HEAD`, `origin..HEAD`
  echo "range: $range"
  git filter-branch -f --env-filter '
    GIT_AUTHOR_NAME=KevInZhao
    GIT_COMMITTER_NAME=KevInZhao
    GIT_COMMITTER_DATE="$(git log --pretty=format:'%ad' --max-count=1 $GIT_COMMIT)"
  ' -- $range

  return 0
}

#
# Fzf stuff.
#

# To install useful key bindings and fuzzy completion.
alias z-fzf-install="$HOMEBREW_PREFIX/opt/fzf/install"

#
# MySQL stuff.
#

# Installation.
alias z-mysql-install="mysql_secure_installation"

#
# Python stuff.
#

# Say good bye to Pyhton 2.
alias python="python3"
alias pip="pip3"

#
# Poetry stuff.
#

# Enable tab completion.
alias z-poetry-insatll="poetry completions zsh > $HOMEBREW_PREFIX/share/zsh/site-functions/_poetry"

#
# Powerlevel10k stuff.
#

# Installation for Homebrew.
alias z-p10k-install="brew install romkatv/powerlevel10k/powerlevel10k"

#
# .DS_Store stuff.
#

function z-ds-delete {
  if [[ $1 == "" ]] {
    echo "folder: $(pwd), start..."

    # Delete a DS_Store file for a specific folder.
    find . –name '.DS_Store' –type f –delete
  } elif [[ $1 == "--all" ]] {
    echo "folder: /, start..."

    # Delete all DS_Store files from your Mac.
    sudo find / -name '.DS_Store' -depth -exec rm {} \;
  } else {
    echo 'error: only accpet `--all` argument!'
    return 1
  }

  echo "done."
  return 0
}

#
# X11 stuff.
#

# Enable trusted X11 forwarding.
alias xssh="open --hide -a XQuartz && ssh -Y"

# Test.
function z-xssh-test {
  local host=dell
  (($+1)) && host=$1

  echo "host: $host"
  xssh $host 'echo "hello, world" | xclip -selection clipboard'

  return 0
}
