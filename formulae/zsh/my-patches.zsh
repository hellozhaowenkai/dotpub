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
#   - [Oh My Zsh](https://github.com/ohmyzsh/ohmyzsh/)
#   - [Zsh Guide](https://zshguide.readthedocs.io/)
# ==================================================


# ==================================================
# Custom Configuration
# ==================================================

#
# NPM stuff.
#

# CNPM: Private npm registry and web for Company.
alias cnpm="npm --registry=https://registry.npm.taobao.org \
  --cache=$HOME/.npm/.cache/cnpm \
  --disturl=https://npm.taobao.org/mirrors/node \
  --userconfig=$HOME/.cnpmrc"

# Fetch all outdated npm global packages list.
alias npm-update="npm -g outdated --depth=0 --parseable | cut -d: -f2"

# Upgrade outdated npm global packages.
function npm-upgrade {
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
function share {
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

# Easy push.
function git-push {
  local remote_branch=$(date "+%Y%m%d-%H%M%S")
  (($+1)) && remote_branch=$1

  echo "remote_branch: $remote_branch"
  git push origin HEAD:$remote_branch

  return 0
}

# Easy pull.
function git-pull {
  local remote_branch=master
  (($+1)) && remote_branch=$1

  echo "remote_branch: $remote_branch"
  git remote prune origin && git pull --rebase origin $remote_branch:

  return 0
}

# Easy fetch.
function git-fetch {
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
