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
"   - [Vim help files](https://vimhelp.org/)
"   - [vim-galore](https://github.com/mhinz/vim-galore/)
"   - [Learn Vim (the Smart Way)](https://github.com/iggredible/Learn-Vim/)
"   - [vim-plug](https://github.com/junegunn/vim-plug/)
"   - [sensible.vim](https://github.com/tpope/vim-sensible/)
"   - [The Ultimate vimrc](https://github.com/amix/vimrc/)
"   - [(Dotf)iles](https://github.com/areisrosa/dotf/)
" ==================================================


" ==================================================
" Setups
" ==================================================

" This variable is used to locate various user files for Vim.
let g:vim_path = expand('~/.vim/')

" Make the path absolute.
function! g:Path(relative_path)
  let l:absolute_path = g:vim_path . a:relative_path

  " Create directory if needed.
  if matchend(a:relative_path, '/') > 1 && !isdirectory(l:absolute_path) && exists('*mkdir')
    call mkdir(l:absolute_path, 'p')
  endif

  return l:absolute_path
endfunction

" Check whether the current editor started with Neovim.
let g:is_nvim = has('nvim')

if g:is_nvim
  " Transitioning from Vim for Neovim.
  let &runtimepath = g:Path('') . ',' . &runtimepath . ',' . g:Path('after/')
  let &packpath = &runtimepath

  " Integrating with Node.
  let g:node_host_prog = '~/.nvm/versions/node/v14.17.0/bin/node'
  " Integrating with Python.
  let g:python3_host_prog = '~/.pyenv/versions/neovim/bin/python'
endif

" A helper function can improve the vim-plug conditional activation readability.
function! g:Condition(is_enabled, ...)
  let l:options = get(a:000, 0, {})
  return a:is_enabled ? l:options : extend(l:options, {'on': [], 'for': []})
endfunction


" ==================================================
" Plugins
" ==================================================

"
" Load optional plugins from packages.
"

" Extended `%` matching for HTML, LaTeX, and many other languages.
packadd! matchit

"
" Load more plugins from network by vim-plug.
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
call plug#begin(g:Path('plugged/'))

"
" Declare the list of plugins.
"

" Retro groove color scheme for Vim.
Plug 'morhetz/gruvbox'

" A collection of language packs for Vim.
Plug 'sheerun/vim-polyglot'
" Two things you need to know:
"   - Vim Polyglot sets defaults of some settings that are relevant for good language support (just like vim-sensible).
"   - Vim Polyglot tries to automatically detect indentation settings (just like vim-sleuth).
" You can disable them by:
let g:polyglot_disabled = ['sensible', 'autoindent']

" A Git wrapper so awesome, it should be illegal.
Plug 'tpope/vim-fugitive'
" Heuristically set buffer options.
Plug 'tpope/vim-sleuth'
" Quoting / Parenthesizing made simple.
Plug 'tpope/vim-surround'
" Comment stuff out.
Plug 'tpope/vim-commentary'
" Combine with netrw to create a delicious salad dressing.
Plug 'tpope/vim-vinegar'
" Enable repeating supported plugin maps with `.`.
Plug 'tpope/vim-repeat'

" Make your Vim / Neovim as smart as VSCode.
Plug 'neoclide/coc.nvim', g:Condition(g:is_nvim, {'branch': 'release'})
" Path to node executable to start coc service.
let g:coc_node_path = g:is_nvim ? g:node_host_prog : 'node'
" Global extension names to install when they aren't installed.
let g:coc_global_extensions = [
  "\ Enable language servers.
  \ 'coc-json', 'coc-html', 'coc-css', 'coc-tsserver', 'coc-vetur', 'coc-jedi',
  "\ Improve Vim experience.
  \ 'coc-lists', 'coc-snippets', 'coc-git', 'coc-yank',
\ ]

" Asynchronous Lint Engine.
Plug 'dense-analysis/ale', g:Condition(g:is_nvim)
" Integrating with coc.nvim.
let g:ale_disable_lsp = 1
" Fix files when they are saved.
let g:ale_fix_on_save = 1
" A mapping from filetypes to `List` values for functions for fixing errors.
let g:ale_fixers = {'python': ['black'], '*': ['prettier']}

" Lean & Mean status / tabline for Vim that's light as air.
Plug 'vim-airline/vim-airline'
" Integrating with powerline fonts.
let g:airline_powerline_fonts = 1
" Integrating with ALE for displaying error information in the status bar.
let g:airline#extensions#ale#enabled = 1
" Smarter tab line.
let g:airline#extensions#tabline#enabled = 1

" A Vim plugin to display the indention levels with thin vertical lines.
Plug 'Yggdroot/indentLine'
" Change indent char.
let g:indentLine_char = '▏'

"
" List ends here.
"

" Plugins become visible to Vim after this call.
call plug#end()


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

set termguicolors           " Enable true color.
colorscheme gruvbox         " Load color scheme.
syntax enable               " Enable syntax highlighting.

set expandtab               " Use the appropriate number of spaces to insert a <Tab>.
set smarttab                " A <Tab> in front of a line inserts blanks according to `shiftwidth`.
set smartindent             " Do smart autoindenting when starting a new line.
set autoindent              " Copy indent from current line when starting a new line.
set copyindent              " Copy the structure of the existing lines indent when autoindenting a new line.
set tabstop      =4         " Number of spaces that a <Tab> in the file counts for.
set softtabstop  =4         " Number of spaces that a <Tab> counts for while performing editing operations.
set shiftround              " Round indent to multiple of `shiftwidth`.

set showmode                " If in Insert, Replace or Visual mode put a message on the last line.
set showcmd                 " Show (partial) command in the last line of the screen.
set showmatch               " When a bracket is inserted, briefly jump to the matching one.
set scrolloff    =1         " Minimal number of screen lines to keep above and below the cursor.
set laststatus   =2         " Always show a status line.
set display     +=lastline  " As much as possible of the last line in a window will be displayed.

set incsearch               " While typing a search command, show where the pattern, as it was typed so far, matches.
set hlsearch                " When there is a previous search pattern, highlight all its matches.
set ignorecase              " Ignore case in search patterns.
set smartcase               " Override the `ignorecase` option if the search pattern contains upper case characters.

set hidden                  " A buffer becomes hidden when it is abandoned.
set splitbelow              " Splitting a window will put the new window below the current one.
set splitright              " Splitting a window will put the new window right of the current one.

set ruler                   " Show the line and column number of the cursor position, separated by a comma.
set number                  " Print the line number in front of each line.
set relativenumber          " Show the line number relative to the line with the cursor in front of each line.
set cursorline              " Highlight the text line of the cursor.

"
" Make your Vim work as you would expect.
"

" When a file has been detected to have been changed outside of Vim, automatically read it again.
set autoread
" Set the character encoding used inside Vim.
set encoding        =utf-8
" The bell will not be rung anyway.
set belloff         =all
" Make your <BS> or <Del> key does do what you want.
set backspace       =indent,eol,start
" Enable the use of the mouse in all modes.
set mouse           =a
" Vim will use the system clipboard for all yank, delete, change and put operations.
set clipboard      ^=unnamed,unnamedplus
" All folds are open when starting.
set nofoldenable
" Keep the cursor in the same column (if possible) when scrolling.
set nostartofline
" Numbers that start with a zero will not be considered to be octal when used as a [count].
set nrformats      -=octal
" Where it makes sense, remove a comment leader when joining lines.
set formatoptions  +=j

"
" Make your Vim more smooth.
"

" Indicate a fast terminal connection.
set ttyfast
" The screen will not be redrawn while executing macros, registers and other commands that have not been typed.
set lazyredraw
" Time out when part of a keyboard code has been received.
set ttimeout
" The time in milliseconds that is waited for a keyboard code sequence to complete.
set ttimeoutlen  =100
" If this many milliseconds nothing is typed the swap file will be written to disk.
set updatetime   =300

"
" Wrap lines at convenient points.
"

" Lines longer than the width of the window will wrap and displaying continues on the next line.
set wrap
" Vim will wrap long lines at a character in `breakat` rather than at the last character that fits on the screen.
set linebreak
" Every wrapped line will continue visually indented, thus preserving horizontal blocks of text.
set breakindent
" Display the `showbreak` value before applying the additional indent.
set breakindentopt  =sbr
" Show `↪` at the beginning of wrapped lines.
let &showbreak = '↪'

"
" Better experience when completing.
"

" The command-line completion operates in an enhanced mode.
set wildmenu
" Don't scan current and included files when completion is active.
set complete     -=i
" When using <C-D> to list matching tags, the kind of tag and the file of the tag is listed.
set wildoptions  +=tagfile
" Search upward for tags files in a directory tree.
setglobal tags-=./tags tags-=./tags; tags^=./tags;

"
" Snapshot enables you to continue where you left off.
"

" Remember global variables that start with an uppercase letter, and don't contain a lowercase letter.
set viminfo         ^=!
" Don't remember options and mappings local to a window or buffer (not global values for local options).
set viewoptions     -=options
" Don't remember all options and mappings (also global values for local options).
set sessionoptions  -=options

"
" Temporary files.
"

" Temporary directory.
let s:temporary_path = 'temps/'

" Make a backup before overwriting a file.
set backup
" The directory where the backup file is stored.
let &backupdir = g:Path(s:temporary_path . 'backup//')

" Use a swap file for the buffer.
set swapfile
" The directory where the swap file is stored.
let &directory = g:Path(s:temporary_path . 'swap//')

" Vim automatically saves undo history to an undo file, and restores undo history from the same file.
set undofile
" The directory where the undo file is stored.
let &undodir = g:Path(s:temporary_path . 'undo//')

"
" Display non-printable characters visually.
"

" List mode, useful to see the difference between tabs and spaces and for trailing blanks.
set list
" Strings to use in List mode.
let &listchars = 'trail:·,tab:»·,extends:→,precedes:←,nbsp:×'
" Characters to fill the statuslines and vertical separators.
let &fillchars = 'stl: ,stlnc: ,vert:│,fold:·,foldsep:│'

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
  let l:message = 'Hi!  This is '
  return l:message . a:name . '.'
endfunction

" Automatic vim-plug installation.
function! s:PlugSetup() abort
  echomsg 'Plug setup: start...'

  " Install vim-plug if not found, else upgrade it.
  let l:plug_path = g:Path('autoload/plug.vim')
  if empty(glob(l:plug_path))
    let l:plug_url = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    silent execute '!curl -fLo ' . l:plug_path . ' --create-dirs ' . l:plug_url
  else
    PlugUpgrade
  endif

  " Run `PlugInstall` if there are missing plugins.
  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
    PlugInstall --sync | silent! source $MYVIMRC
  endif

  " Ensure all plugins are work right.
  PlugClean | PlugUpdate --sync | PlugStatus

  echomsg 'Plug setup: end.'
endfunction

" KeVim's initial flow setup actions.
function! s:KeVimSetup() abort
  echomsg s:Hi('KevInZhao')

  echomsg 'KeVim setup: start...'
  call s:PlugSetup()
  echomsg 'KeVim setup: end.'
endfunction

" Replace in the entire file, with ask for confirmation.
function! s:replace(pattern, string) abort
  " The full `substitute` syntax is as follows:
  "   :[range]s[ubstitute]/{pattern}/{string}/[flags] [count]
  " For each line in [range] replace a match of {pattern} with {string}.
  execute '%substitute/' . a:pattern . '/' . a:string . '/gc'
endfunction


" ==================================================
" Commands
" ==================================================

" Execute KeVim's initial flow setup actions.
command! KeVimSetup call s:KeVimSetup()

" Write a file as sudo.
command! W execute 'write !sudo tee % > /dev/null' <Bar> edit!

" Quit without writing, also when the current buffer has changes.
command! Q quit!

" Replace in the entire file, with ask for confirmation.
command! -nargs=+ Replace call s:replace(<f-args>)

" See the difference between the current buffer and the file it was loaded from, thus the changes you made.
command! Diff vertical new | set buftype=nofile | read ++edit # | 0delete _ | diffthis | wincmd p | diffthis

" When editing a file, always jump to the last known cursor position.
autocmd BufReadPost *
  \ if line("'\"") >= 1 && line("'\"") <= line("$") && &filetype !~# 'commit'
  \ |   execute "normal! g'\""
  \ | endif


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

" Don't use Ex mode, use `Q` for formatting.
noremap Q gq
" Make `Y` consistent with `C` and `D`.
nnoremap Y y$
" Clear the highlighting of search and diff.
nnoremap <silent> <Leader>l :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>

" Delete the word before the cursor, with undo support.
inoremap <Leader>w <C-G>u<C-W>
" Delete all entered characters before the cursor in the current line, with undo support.
inoremap <Leader>u <C-G>u<C-U>

" Toggle the Paste mode.
set pastetoggle  =<Leader>p
" Delete, and without influence to the system clipboard.
vnoremap <Leader>d "_d
" Cut to the system clipboard.
vnoremap <Leader>x "+d
" Copy to the system clipboard.
vnoremap <Leader>c "+y
" Paste form the system clipboard, and don't auto-indent.
nnoremap <Leader>v <Leader>p"+p<Leader>p
lnoremap <Leader>v <C-R><C-O>+

" Find the word under the cursor in the entire file.
nnoremap <Leader>f :/<C-r><C-w><CR>Gn
" Replace the word under the cursor in the entire file, with ask for confirmation.
nnoremap <Leader>r :Replace<Space><C-r><C-w><Space>

" Open a new tab page with an netrw window, after the current tab page.
nnoremap <Leader>t :tabnew<Space>.<CR>
" Close the current tab page.
nnoremap <Leader>w :tabclose<CR>
