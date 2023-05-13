# ==================================================
# `.zshrc` is sourced in interactive shells.
#
# Maintainer:
#   KevInZhao <hellozhaowenkai@gmail.com>
# Description:
#   Personal preference .zshrc file.
# Note:
#   It should contain commands to set up aliases, functions, options, key bindings, etc.
# Sections:
#   - Oh-My-Zsh Configuration
#   - Plugins Configuration
#   - Zsh Configuration
#   - Custom Configuration
#   - Formulae Configuration
# Repository:
#   - [DotPub](https://github.com/hellozhaowenkai/dotpub/)
# References:
#   - [What to put in your startup files](https://zsh.sourceforge.io/Guide/zshguide02.html)
#   - [Options](http://zsh.sourceforge.net/Doc/Release/Options.html)
#   - [Zsh Line Editor](http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html)
#   - [Template](~/.oh-my-zsh/templates/zshrc.zsh-template)
# ==================================================


# ==================================================
# Oh-My-Zsh Configuration
# ==================================================

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ZSH_THEME="robbyrussell"

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

# Uncomment one of the following lines to change the auto-update behavior.
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
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
  colored-man-pages
)

# Enable Oh-My-Zsh.
source $ZSH/oh-my-zsh.sh


# ==================================================
# Plugins Configuration
# ==================================================

# Load plugins installed by Homebrew.
source $HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $HOMEBREW_PREFIX/share/zsh-history-substring-search/zsh-history-substring-search.zsh

# Allow Ctrl-P/Ctrl-N for navigate history integrated with zsh-history-substring-search.
bindkey -M viins "^p" history-substring-search-up
bindkey -M viins "^n" history-substring-search-down

# Allow Ctrl-]/Ctrl-[ for partially accept the suggestion up to the point that the cursor moves to.
bindkey -M viins "^]" vi-forward-word
bindkey -M viins "^[" vi-backward-kill-word

# Make the switch between modes quicker when using vi-mode.
export KEYTIMEOUT=1

# ==================================================
# Zsh Configuration
# ==================================================

#
# Changing Directories.
#

# Don't push multiple copies of the same directory onto the directory stack.
setopt PUSHD_IGNORE_DUPS

#
# Completion.
#

# On an ambiguous completion, instead of listing possibilities or beeping, insert the first match immediately.
setopt MENU_COMPLETE

#
# History.
#

# The name of the file in which command history is saved.
export HISTFILE=~/.zsh_history
# The maximum number of lines contained in the history file.
export HISTFILESIZE=500
# The number of commands that are loaded into memory from the history file.
export HISTSIZE=500
# The number of commands that are stored in the zsh history file.
export SAVEHIST=500

# Add `|` to output redirections in the history.
setopt HIST_ALLOW_CLOBBER
# Remove superfluous blanks from each command line being added to the history list.
setopt HIST_REDUCE_BLANKS
# Remove command lines from the history list when the first character on the line is a space, or when one of the expanded aliases contains a leading space.
setopt HIST_IGNORE_SPACE
# If a new command line being added to the history list duplicates an older one, the older command is removed from the list (even if it is not the previous event).
setopt HIST_FIND_NO_DUPS
# When writing out the history file, older commands that duplicate newer ones are omitted.
setopt HIST_SAVE_NO_DUPS
# If a new command line being added to the history list duplicates an older one, the older command is removed from the list (even if it is not the previous event).
setopt HIST_IGNORE_ALL_DUPS
# Save each command's beginning timestamp (in seconds since the epoch) and the duration (in seconds) to the history file.
setopt EXTENDED_HISTORY
# This option is a variant of `INC_APPEND_HISTORY` in which, where possible, the history entry is written out to the file after the command is finished, so that the time taken by the command is recorded correctly in the history file in `EXTENDED_HISTORY` format.
setopt INC_APPEND_HISTORY_TIME

# Disable history when not use iTerm.
if [[ "$LC_TERMINAL" != "iTerm2" ]]; then
  # Do read old history from file.
  fc -RI
  # Do not write new history to file.
  unset HISTORY HISTFILE HISTSAVE HISTZONE HISTORY HISTLOG
fi


# ==================================================
# Custom Configuration
# ==================================================

# If `MANPATH` is set, `man` uses it as the path to search for manual page files.
# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment.
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# You may need to manually set your timezone environment.
export TZ=Asia/Shanghai

# You may need to manually set your display environment.
# export DISPLAY=:0.0

# Preferred editor for local and remote sessions.
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR="vim"
else
  export EDITOR="nvim"
fi

# Compilation flags.
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the `$ZSH_CUSTOM` folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases:
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"


# ==================================================
# Formulae Configuration
# ==================================================

#
# [acme.sh](https://acme.sh/)
#

# Enable alias.
[[ -s "$HOME/.acme.sh/acme.sh.env" ]] && . "$HOME/.acme.sh/acme.sh.env"

#
# [neofetch](https://github.com/dylanaraps/neofetch/)
#

# Show information when use iTerm, only for local sessions.
if [[ "$TERM_PROGRAM" == "iTerm.app" ]]; then
  neofetch
fi

#
# [powerlevel10k](https://github.com/romkatv/powerlevel10k/)
#

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Enable Powerlevel10k theme.
source $HOMEBREW_PREFIX/opt/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit `~/.p10k.zsh`.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

#
# [fzf](https://github.com/junegunn/fzf/)
#

# Enable fuzzy auto-completion.
[[ $- == *i* ]] && source "$HOMEBREW_PREFIX/opt/fzf/shell/completion.zsh" 2> /dev/null

# Enable key bindings.
source "$HOMEBREW_PREFIX/opt/fzf/shell/key-bindings.zsh"

#
# [zoxide](https://github.com/ajeetdsouza/zoxide/)
#

# Add zoxide to your shell.
eval "$(zoxide init zsh)"

#
# [nvm](https://github.com/nvm-sh/nvm/)
#

# Ensure that the NVM_DIR does not contain a trailing slash.
export NVM_DIR="$HOME/.nvm"

# This loads nvm.
[[ -s "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" ]] && . "$HOMEBREW_PREFIX/opt/nvm/nvm.sh"
# This loads nvm bash_completion.
[[ -s "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" ]] && . "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm"

# Use TaoBao mirror.
# export NVM_NODEJS_ORG_MIRROR="https://registry.npmmirror.com/binary.html?path=node/"

#
# [pyenv](https://github.com/pyenv/pyenv/)
#

# Define environment variable PYENV_ROOT to point to the path where Pyenv will store its data.
export PYENV_ROOT="$HOME/.pyenv"
# Add the pyenv executable to your PATH if it's not already there.
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"

# Use TaoBao mirror.
# export PYTHON_BUILD_MIRROR_URL="https://registry.npmmirror.com/binary.html?path=python/"
# If set, does not append the SHA2 checksum of the file to the mirror URL.
# export PYTHON_BUILD_MIRROR_URL_SKIP_CHECKSUM=1

# Use TUNA mirror for Anaconda temporarily,
# or you can download package then move it to `~/.pyenv/cache/` by yourself.
# export PYTHON_BUILD_MIRROR_URL="https://mirrors.tuna.tsinghua.edu.cn/anaconda/archive/"

# Add `pyenv` into your shell by running the output of `pyenv init -` to enable autocompletion and all subcommands.
eval "$(pyenv init -)"
# Add `pyenv-virtualenv` to your shell to enable auto-activation of virtualenvs.
eval "$(pyenv virtualenv-init -)"
