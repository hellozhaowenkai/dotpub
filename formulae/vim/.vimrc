" ==================================================
" Kevin's Vim is KeVim.
"
" Maintainer:
"   KevInZhao <hellozhaowenkai@gmail.com>
" Description:
"   Personal preference .vimrc / init.vim file.
" Note:
"   The following configuration works for both Vim and Neovim.
" Sections:
"   - Setups
"   - Plugins
"   - Settings
"   - Functions
"   - Commands
"   - Mappings
" Repository:
"   - [DotPub](https://github.com/hellozhaowenkai/dotpub/)
" References:
"   - [help](https://vimhelp.org/)
"   - [vim-galore](https://github.com/mhinz/vim-galore/)
"   - [learn-vim](https://github.com/iggredible/Learn-Vim/)
"   - [vim-plug](https://github.com/junegunn/vim-plug/)
"   - [vimrc](https://github.com/amix/vimrc/)
"   - [dotf](https://github.com/areisrosa/dotf/)
" ==================================================


" ==================================================
" Setups
" ==================================================

" Get the defaults that most users want.
source $VIMRUNTIME/defaults.vim

" Check whether the current editor started with Neovim.
let g:is_nvim = has('nvim')

" A helper function can improve the vim-plug conditional activation readability.
function! g:Condition(plug_enable, ...)
  let l:plug_options = get(a:000, 0, {})
  return a:plug_enable ? l:plug_options : extend(l:plug_options, { 'on': [], 'for': [] })
endfunction


" ==================================================
" Plugins
" ==================================================

"
" Let vim-plug manage plugins.
"

" ------------------------------------+-------------------------------------------------------------------
" Command                             | Description
" ------------------------------------+-------------------------------------------------------------------
" `PlugInstall [name ...] [#threads]` | Install plugins
" `PlugUpdate [name ...] [#threads]`  | Install or update plugins
" `PlugClean[!]`                      | Remove unlisted plugins (bang version will clean without prompt)
" `PlugUpgrade`                       | Upgrade vim-plug itself
" `PlugStatus`                        | Check the status of plugins
" `PlugDiff`                          | Examine changes from the previous update and the pending changes
" `PlugSnapshot[!] [output path]`     | Generate script for restoring the current snapshot of the plugins
" ------------------------------------+-------------------------------------------------------------------

" Plugins will be downloaded under the specified directory.
call plug#begin(g:is_nvim ? stdpath('data') . '/plugged' : '~/.vim/plugged')

"
" Declare the list of plugins.
"

" If you need Vim help for vim-plug itself (e.g. :help plug-options), register vim-plug as a plugin.
Plug 'junegunn/vim-plug'
" Retro groove color scheme for Vim.
Plug 'morhetz/gruvbox'
" A simplified and optimized Gruvbox colorscheme for Vim.
Plug 'lifepillar/vim-gruvbox8'
" A solid language pack for Vim.
Plug 'sheerun/vim-polyglot'
" Defaults everyone can agree on.
Plug 'tpope/vim-sensible'
" Heuristically set buffer options.
Plug 'tpope/vim-sleuth'
" A Git wrapper so awesome, it should be illegal.
Plug 'tpope/vim-fugitive', g:Condition(g:is_nvim)
" Make your Vim / Neovim as smart as VSCode.
Plug 'neoclide/coc.nvim', g:Condition(g:is_nvim, { 'branch': 'release' })

" List ends here. Plugins become visible to Vim after this call.
call plug#end()

"
" Put your plugin configuration after this line.
"

" Load color scheme.
colorscheme gruvbox


" ==================================================
" Settings
" ==================================================

"
" A (not so) minimal vimrc.
"

" You want Vim, not Vi. When Vim finds a vimrc, `nocompatible` is set anyway.
" We set it explicitly to make our position clear!
set nocompatible

" Enable loading the plugin files and the indent file for specific file types.
filetype plugin indent on

syntax enable               " Enable syntax highlighting.
set termguicolors           " Enable true color.

set expandtab               " Use the appropriate number of spaces to insert a <Tab>.
set smarttab                " A <Tab> in front of a line inserts blanks according to `shiftwidth`.
set smartindent             " Do smart autoindenting when starting a new line.
set autoindent              " Copy indent from current line when starting a new line.
set copyindent              " Copy the structure of the existing lines indent when autoindenting a new line.
set tabstop      =4         " Number of spaces that a <Tab> in the file counts for.
set softtabstop  =4         " Number of spaces that a <Tab> counts for while performing editing operations.
set shiftwidth   =4         " Number of spaces to use for each step of (auto)indent.
set shiftround              " Round indent to multiple of `shiftwidth`.

set showmode                " If in Insert, Replace or Visual mode put a message on the last line.
set showcmd                 " Show (partial) command in the last line of the screen.
set showmatch               " When a bracket is inserted, briefly jump to the matching one.
set laststatus   =2         " Always show a status line.
set display      =lastline  " As much as possible of the last line in a window will be displayed.

set incsearch               " While typing a search command, show where the pattern, as it was typed so far, matches.
set hlsearch                " When there is a previous search pattern, highlight all its matches.
set ignorecase              " Ignore case in search patterns.
set smartcase               " Override the `ignorecase` option if the search pattern contains upper case characters.

set splitbelow              " Splitting a window will put the new window below the current one.
set splitright              " Splitting a window will put the new window right of the current one.

set number                  " Print the line number in front of each line.
set relativenumber          " Show the line number relative to the line with the cursor in front of each line.
set cursorline              " Highlight the text line of the cursor.

"
" Make your Vim work as you would expect.
"

" When a file has been detected to have been changed outside of Vim, automatically read it again.
set autoread
" A buffer becomes hidden when it is abandoned.
set hidden
" Make your <BS> or <Del> key does do what you want.
set backspace   =indent,eol,start
" Enable the use of the mouse in all modes.
set mouse       =a
" Vim will use the system clipboard for all yank, delete, change and put operations.
set clipboard  ^=unnamed,unnamedplus

"
" Make your Vim more smooth.
"

" Indicates a fast terminal connection.
set ttyfast
" The screen will not be redrawn while executing macros, registers and other commands that have not been typed.
set lazyredraw
" Maximum column in which to search for syntax items.
set synmaxcol  =200
" When the number of changed lines is more than `report` a message will be given for most commands.
set report     =0

"
" Display non-printable characters visually.
"

" List mode, useful to see the difference between tabs and spaces and for trailing blanks.
set list
" Strings to use in List mode.
let &listchars = 'trail:·,tab:»·,extends:→,precedes:←,nbsp:×'

"
" Wrap lines at convenient points.
"

" Lines longer than the width of the window will wrap and displaying continues on the next line.
set wrap
" Searches wrap around the end of the file.
set wrapscan
" Vim will wrap long lines at a character in `breakat` rather than at the last character that fits on the screen.
set linebreak
" Show `↪` at the beginning of wrapped lines.
let &showbreak = '↪'

"
" Change cursor style dependent on mode.
"

" I like to use a block cursor in Normal mode, bar cursor in Insert mode, and underline cursor in Replace mode.
if empty($TMUX)
  let &t_SI = "\<Esc>]50;CursorShape=1\x7"
  let &t_EI = "\<Esc>]50;CursorShape=0\x7"
  let &t_SR = "\<Esc>]50;CursorShape=2\x7"
else
  let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
  let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
  let &t_SR = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=2\x7\<Esc>\\"
endif


" ==================================================
" Functions
" ==================================================

" Hi.
function! s:Hi(name)
  let l:message = 'Hello!  My name is '
  return l:message . a:name . '.'
endfunction

" Automatic vim-plug installation.
function! s:PlugSetup() abort
  echomsg 'Plug Setup start...'

  " Install vim-plug if not found, else run `PlugUpgrade` to upgrade it.
  let l:plug_dir = (g:is_nvim ? stdpath('data') . '/site' : '~/.vim') . '/autoload/plug.vim'
  if empty(glob(l:plug_dir))
    let l:plug_url = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    silent execute '!curl -fLo ' . l:plug_dir . ' --create-dirs ' . l:plug_url
  else
    PlugUpgrade
  endif

  " Run `PlugInstall` if there are missing plugins.
  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
    PlugInstall --sync | silent! source $MYVIMRC
  endif

  " Ensure all plugins are work right.
  PlugClean | PlugUpdate --sync | PlugStatus

  echomsg 'Plug Setup end.'
endfunction

" KeVim's initial flow setup actions.
function! s:KeVimSetup() abort
  echomsg s:Hi('KevInZhao')

  echomsg 'KeVim Setup start...'
  call s:PlugSetup()
  echomsg 'KeVim Setup end.'
endfunction


" ==================================================
" Commands
" ==================================================

" Setup KeVim.
command! KeVimSetup call s:KeVimSetup()

" Use `:W` to write a file as sudo.
command! W execute 'w !sudo tee % > /dev/null' <Bar> edit!


" ==================================================
" Mappings
" ==================================================

"
" Set the `mapleaders` before custom mappings!
"

" The default leader is `\`, but I prefer `<Space>` as it's in a standard location.
let g:mapleader = "\<Space>"

"
" Overview of which map command works in which mode.
"

"      COMMANDS                    MODES
" :map   :noremap  :unmap     Normal, Visual, Select, Operator-pending
" :nmap  :nnoremap :nunmap    Normal
" :vmap  :vnoremap :vunmap    Visual and Select
" :smap  :snoremap :sunmap    Select
" :xmap  :xnoremap :xunmap    Visual
" :omap  :onoremap :ounmap    Operator-pending
" :map!  :noremap! :unmap!    Insert and Command-line
" :imap  :inoremap :iunmap    Insert
" :lmap  :lnoremap :lunmap    Insert, Command-line, Lang-Arg
" :cmap  :cnoremap :cunmap    Command-line
" :tmap  :tnoremap :tunmap    Terminal-Job

"
" Using `noremap` is preferred, because it's clearer that recursive mapping is (mostly) disabled.
"

" Make `Y` consistent with `C` and `D`.
nnoremap Y y$
" When in Insert mode, press `<Leader>p` to go to Paste mode.
inoremap <Leader>p <C-O>:set invpaste<CR>
