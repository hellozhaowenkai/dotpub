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

  if [[ $1 == tuna ]] {
    # Use tuna mirror.
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

#
# NPM stuff.
#

# Private npm registry and web for Company.
alias z-npm-taobao="npm --registry=https://registry.npm.taobao.org \
  --cache=$HOME/.npm/.cache/cnpm \
  --disturl=https://npm.taobao.org/mirrors/node \
  --userconfig=$HOME/.cnpmrc"

# Fetch all outdated npm global packages list.
alias z-npm-update="npm -g outdated --depth=0 --parseable | cut -d: -f2"

# Upgrade outdated npm global packages.
function z-npm-upgrade {
  for package ($(npm-update)) {
    echo "upgrading $package"
    npm -g install $package
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
      scp -r $host:~/Public/Shared/* ~/Public/Shared/
      ;;

    (push)
      scp -r ~/Public/Shared/* $host:~/Public/Shared/
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
  local remote_branch=$(date "+%Y%m%d-%H%M%S")
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
  local right_hour=21
  (($+1)) && right_hour=$1
  local right_minute=30
  (($+2)) && right_minute=$2
  local right_date=$(date -R -v -1d -v "$right_hour"H -v "$right_minute"M)

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
  git filter-branch -f --env-filter '
    GIT_AUTHOR_NAME=KevInZhao
    GIT_COMMITTER_NAME=KevInZhao
    GIT_COMMITTER_DATE="$(git log --pretty=format:'%ad' --max-count=1 $GIT_COMMIT)"
  ' -- --all

  return 0
}

#
# Fzf stuff.
#

# To install useful key bindings and fuzzy completion.
alias z-fzf-install="/usr/local/opt/fzf/install"

#
# MySQL stuff.
#

# Installation.
alias z-mysql-install="mysql_secure_installation"
