" By r4ven.me

" ############################
" ###### BASIC SETTINGS ######
" ############################

set mouse=a                 " Enable mouse support
set encoding=utf-8          " Set character encoding to UTF-8
set number                  " Display line numbers
set scrolloff=7             " Keep at least 7 lines visible above/below cursor
"set noshowmode              " Disable mode display
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
"set showtabline=2           " Always show tabline
set clipboard=unnamedplus   " Use system clipboard
"set termguicolors           " Enable true color support
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
