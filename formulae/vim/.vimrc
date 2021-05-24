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

" Enable true color.
set termguicolors
" Chose a color scheme to use.
colorscheme gruvbox


" ==================================================
" Settings
" ==================================================

"
" A (not so) minimal vimrc.
"

" You want Vim, not vi. When Vim finds a vimrc, `nocompatible` is set anyway.
" We set it explicitly to make our position clear!
set nocompatible

filetype plugin indent on          " Load plugins according to detected filetype.
syntax on                          " Enable syntax highlighting.

set autoindent                     " Indent according to previous line.
set expandtab                      " Use spaces instead of tabs.
set softtabstop =4                 " Tab key indents by 4 spaces.
set shiftwidth  =4                 " >> indents by 4 spaces.
set shiftround                     " >> indents to next multiple of `shiftwidth`.

set backspace   =indent,eol,start  " Make backspace work as you would expect.
set hidden                         " Switch between buffers without having to save first.
set laststatus  =2                 " Always show statusline.
set display     =lastline          " Show as much as possible of the last line.

set showmode                       " Show current mode in command-line.
set showcmd                        " Show already typed keys when more are expected.

set incsearch                      " Highlight while searching with `/` or `?`.
set hlsearch                       " Keep matches highlighted.

set ttyfast                        " Faster redrawing.
set lazyredraw                     " Only redraw when necessary.

set splitbelow                     " Open new windows below the current window.
set splitright                     " Open new windows right of the current window.

set cursorline                     " Find the current line quickly.
set wrapscan                       " Searches wrap around end-of-file.
set report      =0                 " Always report changed lines.
set synmaxcol   =200               " Only highlight the first 200 columns.

set list                           " Show non-printable characters.

"
" Change cursor style dependent on mode.
"

" I like to use a block cursor in Normal mode, i-beam cursor in Insert mode, and underline cursor in Replace mode.
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
    PlugInstall --sync | source $MYVIMRC
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
