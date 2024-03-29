#!/usr/bin/env zsh

# ==================================================
# Such customization `*.zsh` files will be loaded the last.
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
function z-install-omz {
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

  return 0
}

#
# Homebrew stuff.
#

# Use TUNA mirror.
function z-use-tuna {
  export HOMEBREW_API_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles/api/"
  export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles/"
  export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"
  export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git"
  export HOMEBREW_PIP_INDEX_URL="https://pypi.tuna.tsinghua.edu.cn/simple/"

  return 0
}

# Installation.
function z-install-brew {
  if [[ "$(uname -s)" == "Linux" ]] {
    # Dependencies for Debian or Ubuntu.
    sudo apt-get install build-essential procps curl file git
  } else {
    # Command Line Tools (CLT) for Xcode.
    xcode-select --install
  }

  if [[ $1 == "tuna" ]] {
    z-use-tuna
  }

  # The script explains what it will do and then pauses before it does it.
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # You're done! Try installing a package:
  brew install hello

  return 0
}

#
# NPM stuff.
#

# Private npm registry and web for Company.
alias z-npm-taobao="npm --registry=https://registry.npmmirror.com/ \
  --cache=$HOME/.npm/.cache/cnpm/ \
  --disturl=https://npmmirror.com/mirrors/node/ \
  --userconfig=$HOME/.cnpmrc"

# Fetch all outdated npm global packages list.
alias z-npm-update="npm outdated --location=global --depth=0 --parseable | cut -d: -f2"

# Upgrade outdated npm global packages.
function z-npm-upgrade {
  for package ($(z-npm-update)) {
    echo ""
    echo "upgrading $package"

    if [[ $1 == "taobao" ]] {
      z-npm-taobao install --location=global $package
    } else {
      npm install --location=global $package
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
  local host=my-vps
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
alias z-lfs-init="git lfs install"

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
  local remote_branch=main
  (($+1)) && remote_branch=$1

  echo "remote_branch: $remote_branch"
  git remote prune origin
  if [[ $1 == "-f" ]] {
    git fetch --all && git reset --hard origin/$remote_branch && git pull
  } else {
    git pull --rebase origin $remote_branch:
  }

  return 0
}

# Easy fetch.
function z-git-fetch {
  local remote_branch=main
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

# Easy track all branches from all remotes.
function z-git-track-all {
  local remote_name=origin

  if [[ $1 == "-m" ]] {
    # Multiple remotes.
    git branch -r | grep -v '\->' | sed "s,\x1B\[[0-9;]*[a-zA-Z],,g" | while read remote_branch; do git branch --track "${remote_branch/\//@}" "$remote_branch"; done
  } else {
    # Only one remote by the name of `origin`.
    git branch -r | grep -v '\->' | sed "s,\x1B\[[0-9;]*[a-zA-Z],,g" | while read remote_branch; do git branch --track "${remote_branch#origin/}" "$remote_branch"; done
  }

  git fetch --all
  git pull --all

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
alias z-set-fzf="$HOMEBREW_PREFIX/opt/fzf/install"

#
# MySQL stuff.
#

# MySQL initialize.
alias z-init-mysql="mysql_secure_installation"

#
# Python stuff.
#

# Say goodbye to Python 2.
alias python="python3"
alias pip="pip3"

#
# Anaconda stuff.
#

# Anaconda initialize.
function z-init-anaconda {
  # >>> conda initialize >>>
  # !! Contents within this block are managed by 'conda init' !!
  __conda_setup="$('/opt/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
  if [ $? -eq 0 ]; then
    eval "$__conda_setup"
  else
    if [ -f "/opt/anaconda3/etc/profile.d/conda.sh" ]; then
      . "/opt/anaconda3/etc/profile.d/conda.sh"
    else
      export PATH="/opt/anaconda3/bin:$PATH"
    fi
  fi
  unset __conda_setup
  # <<< conda initialize <<<

  return 0
}

#
# Poetry stuff.
#

# Enable tab completion.
alias z-set-poetry="poetry completions zsh > $HOMEBREW_PREFIX/share/zsh/site-functions/_poetry"

#
# .DS_Store stuff.
#

# See [here](https://support.apple.com/en-us/HT208209/).
alias z-disable-ds="defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool TRUE"
alias z-enable-ds="defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool FALSE"

# See [here](https://www.switchingtomac.com/macos/what-is-a-ds_store-file-and-how-to-remove-it/).
function z-delete-ds {
  if [[ $1 == "" ]] {
    echo "folder: $(pwd), start..."

    # Delete all DS_Store files in the current directory.
    find . -name '.DS_Store' -type f -depth -print -exec rm {} \;
  } elif [[ $1 == "--root" ]] {
    echo "folder: /, start..."

    # Delete all DS_Store files from your Mac.
    sudo find / -name '.DS_Store' -type f -depth -print -exec rm {} \;
  } else {
    echo 'error: only accpet `--root` argument!'
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
function z-test-xssh {
  local host=my-vps
  (($+1)) && host=$1

  echo "host: $host"
  xssh $host 'echo "hello, world" | xclip -selection clipboard'

  return 0
}
