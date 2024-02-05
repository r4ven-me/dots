" By r4ven.me

" ############################
" ###### BASIC SETTINGS ######
" ############################

set mouse=a                 " Enable mouse support
set encoding=utf-8          " Set character encoding to UTF-8
set number                  " Display line numbers
set scrolloff=7             " Keep at least 7 lines visible above/below cursor
set noshowmode              " Disable mode display
set cursorline              " Highlight the current line
set ignorecase              " Enable case-insensitive searching
set smartcase               " Use smart case for searching
set laststatus=2            " Always show status line
set tabstop=4               " Set tab width to 4 spaces
set softtabstop=4           " Set soft tabstop to 4 spaces
set shiftwidth=4            " Set indentation width to 4 spaces
set expandtab               " Use spaces instead of tabs for indentation
set autoindent              " Enable automatic indentation
set fileformat=unix         " Set file format to Unix (LF line endings)
set showtabline=2           " Always show tabline
set clipboard=unnamedplus   " Use system clipboard
set termguicolors           " Enable true color support
set splitbelow              " Split new windows below the current one
set splitright              " Split new windows to the right of the current one
set equalalways             " Keep window sizes equal
set sessionoptions-=blank   " Don't save blank windows in sessions
filetype indent on          " Disable automatic indentation for specific filetypes

" #############################
" ###### SWAP AND BACKUP ######
" #############################

" Create swap, undo, backup and sessions directories if they don't exist
if !isdirectory($HOME. "/.local/state/nvim/swap")
    call mkdir($HOME. "/.local/state/nvim/swap", "p")
endif

if !isdirectory($HOME. "/.local/state/nvim/undo")
    call mkdir($HOME. "/.local/state/nvim/undo", "p")
endif

if !isdirectory($HOME. "/.local/state/nvim/backup")
    call mkdir($HOME. "/.local/state/nvim/backup", "p")
endif

if !isdirectory($HOME. "/.local/state/nvim/sessions")
    call mkdir($HOME. "/.local/state/nvim/sessions", "p")
endif

set swapfile " Protect changes between writes, def values: 200 keystrokes / 4 seconds
set directory^=~/.local/state/nvim/swap// " Set directory for swap files

set writebackup " Protect against crash-during-write
set nobackup " Do not persist backup after successful write
set backupcopy=auto " Use rename-and-write-new method whenever safe
set backupdir^=~/.local/state/nvim/backup// " Set directory for backup files

set undofile " Persist the undo tree for each file
set undodir^=~/.local/state/nvim/undo// " Set directory for undo tree files

" #########################
" ###### KEYBINDINGS ######
" #########################

" Insert a new line below
nnoremap <Enter> o<ESC>

" Add a space after the cursor
nnoremap <Space> a<Space><ESC>

" Map 'jk' in insert mode to Escape
inoremap jk <ESC>

" Turn off search highlighting with ',<Space>'
nnoremap ,<Space> :nohlsearch<CR>

" Delete without yanking to the default register
nnoremap x "_x
xnoremap x "_x

" Swap 'p' and 'P' keys
xnoremap <expr> p 'pgv"'.v:register.'y`>'
xnoremap <expr> P 'Pgv"'.v:register.'y`>'

" Auto-chmod and execute for shell and python files with <F5>
" Here '<C-R>=shellescape(@%, 1)<CR>' makes insert result of 'shellescape(@%, 1)'
" which parses current filename and escapes it for safe use in commandline
autocmd FileType sh,python map <buffer> <F5> :w<CR>:!chmod ug+x <C-R>=shellescape(@%, 1)<CR> && sh -c ./<C-R>=shellescape(@%, 1)<CR><CR>
autocmd FileType sh,python imap <buffer> <F5> <esc>:w<CR>:!chmod ug+x <C-R>=shellescape(@%, 1)<CR> && sh -c ./<C-R>=shellescape(@%, 1)<CR><CR>

" Session save and restore (4 sessions)
" Sets variable for session file path prefix
let session_file = "~/.local/state/nvim/sessions/session"

" Mapping <F9>, <F10>, <F11>, <F12> keys to save sessions (1-4)
nnoremap <S-F9> :execute "mksession! " . session_file . "1.vim"<CR>
inoremap <S-F9> <esc>:execute "mksession! " . session_file . "1.vim"<CR>a
nnoremap <S-F10> :execute "mksession! " . session_file . "2.vim"<CR>
inoremap <S-F10> <esc>:execute "mksession! " . session_file . "2.vim"<CR>a
nnoremap <S-F11> :execute "mksession! " . session_file . "3.vim"<CR>
inoremap <S-F11> <esc>:execute "mksession! " . session_file . "3.vim"<CR>a
nnoremap <S-F12> :execute "mksession! " . session_file . "4.vim"<CR>
inoremap <S-F12> <esc>:execute "mksession! " . session_file . "4.vim"<CR>a

" Mapping <F9>, <F10>, <F11>, <F12> keys to save sessions (1-4) for alacritty terminal
nnoremap <F21> :execute "mksession! " . session_file . "1.vim"<CR>
inoremap <F21> <esc>:execute "mksession! " . session_file . "1.vim"<CR>a
nnoremap <F22> :execute "mksession! " . session_file . "2.vim"<CR>
inoremap <F22> <esc>:execute "mksession! " . session_file . "2.vim"<CR>a
nnoremap <F23> :execute "mksession! " . session_file . "3.vim"<CR>
inoremap <F23> <esc>:execute "mksession! " . session_file . "3.vim"<CR>a
nnoremap <F24> :execute "mksession! " . session_file . "4.vim"<CR>
inoremap <F24> <esc>:execute "mksession! " . session_file . "4.vim"<CR>a

" Load sessions with <F9>, <F10>, <F11>, <F12>
nnoremap <F9> :execute "source " . session_file . "1.vim"<CR>
inoremap <F9> <esc>:execute "source " . session_file . "1.vim"<CR>
nnoremap <F10> :execute "source " . session_file . "2.vim"<CR>
inoremap <F10> <esc>:execute "source " . session_file . "2.vim"<CR>
nnoremap <F11> :execute "source " . session_file . "3.vim"<CR>
inoremap <F11> <esc>:execute "source " . session_file . "3.vim"<CR>
nnoremap <F12> :execute "source " . session_file . "4.vim"<CR>
inoremap <F12> <esc>:execute "source " . session_file . "4.vim"<CR>

" Save the file with 'WW' (same as :w) 
nnoremap WW :w<CR>

" ############################
" ###### OTHER SETTINGS ######
" ############################

" Always jump to the last known cursor position after opening a file
autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g`\"" | endif

" Update terminal size on VimEnter
autocmd VimEnter * :silent exec "!kill -s SIGWINCH $PPID"
" After loading a session, equalize window sizes
autocmd SessionLoadPost * wincmd =

" Disable readonly (ro) format options for all file types (off auto comments)
autocmd FileType * setlocal formatoptions-=ro

" Auto install plugin-manager: vim-plug
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
    silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
else
    runtime plugins.vim
endif
