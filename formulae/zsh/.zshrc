# =======================
# Oh-My-Zsh Configuration
# =======================

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# Caution: this setting can cause issues with multiline prompts (zsh 5.7.1 and newer seem to work)
# See https://github.com/ohmyzsh/ohmyzsh/issues/5765
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
HIST_STAMPS="yyyy-mm-dd"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  # git
  vi-mode
)

source $ZSH/oh-my-zsh.sh


# =======================
# Plugins Configuration
# =======================

# Load plugins installed by brew
source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/local/share/zsh-history-substring-search/zsh-history-substring-search.zsh

# Allow ctrl-p/ctrl-n for navigate history integrated with zsh-history-substring-search
bindkey -M viins "^p" history-substring-search-up
bindkey -M viins "^n" history-substring-search-down


# =======================
# Zsh Configuration
# =======================

## [History](http://zsh.sourceforge.net/Doc/Release/Options.html#History)
# The name of the file in which command history is saved.
export HISTFILE=~/.zsh_history
# The maximum number of lines contained in the history file.
export HISTFILESIZE=500
# The number of commands to remember in the command history.
export HISTSIZE=500

# Add `|` to output redirections in the history.
setopt HIST_ALLOW_CLOBBER
# If a new command line being added to the history list duplicates an older one, the older command is removed from the list (even if it is not the previous event).
setopt HIST_IGNORE_ALL_DUPS
# Remove superfluous blanks from each command line being added to the history list.
setopt HIST_REDUCE_BLANKS


# =======================
# User Configuration
# =======================

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR="vim"
else
  export EDITOR="code"
fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

alias cnpm="npm --registry=https://registry.npm.taobao.org \
  --cache=$HOME/.npm/.cache/cnpm \
  --disturl=https://npm.taobao.org/mirrors/node \
  --userconfig=$HOME/.cnpmrc"

function shared() {
  if [[ "$2" == "pull" ]] {
    scp -r $1:~/Public/Shared/* ~/Public/Shared/
  }
  if [[ "$2" == "push" ]] {
    scp -r ~/Public/Shared/* $1:~/Public/Shared/
  }
}

function git-push() {
  if (($+1)) {
    git push origin HEAD:$1
  } else {
    local now=$(date "+%Y%m%d-%H%M%S")
    git push origin HEAD:$now
  }
}
function git-pull() {
  git pull --rebase origin $1:
}
function git-fetch() {
  local now=$(date "+%Y%m%d-%H%M%S")
  git remote prune origin && git fetch --depth=1 origin $1:$now && git checkout $now
}

alias npm-update="npm -g outdated --depth=0 --parseable | cut -d: -f2"
function npm-upgrade() {
  for package (`update-npm`) {
    echo $package
    npm -g install $package
  }
}


# =======================
# Formulae Configuration
# =======================

## [homebrew](https://brew.sh/)
# Use tuna mirror
export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git"
export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles/bottles"

## [nvm](https://github.com/nvm-sh/nvm/)
# Ensure that the NVM_DIR does not contain a trailing slash
export NVM_DIR="$HOME/.nvm"
# This loads nvm
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"
# This loads nvm bash_completion
[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && . "/usr/local/opt/nvm/etc/bash_completion.d/nvm"
# Use taobao mirror
export NVM_NODEJS_ORG_MIRROR="https://npm.taobao.org/mirrors/node/"

## [pyenv](https://github.com/pyenv/pyenv/)
# Use taobao mirror
export PYTHON_BUILD_MIRROR_URL_SKIP_CHECKSUM=1
export PYTHON_BUILD_MIRROR_URL="https://npm.taobao.org/mirrors/python/"
# Use tuna mirror for anaconda temporarily
# export PYTHON_BUILD_MIRROR_URL="https://mirrors.tuna.tsinghua.edu.cn/anaconda/archive/"
# Or you can download package then move it to `~/.pyenv/cache/` by yourself

# Add pyenv init to your shell to enable shims and autocompletion.
# Please make sure this is placed toward the end of the shell configuration file since it manipulates PATH during the initialization.
if command -v pyenv 1>/dev/null 2>&1; then
  # eval "$(pyenv init -)"  # This may be slow.
  eval "$(pyenv init - --no-rehash)"  # This may be fast.
fi

## [starship](https://starship.rs/)
# Add init scripts
eval "$(starship init zsh)"
