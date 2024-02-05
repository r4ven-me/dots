" By r4ven.me

" ################################
" ###### PLUGINS MANAGEMENT ######
" ################################

" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
    \| PlugInstall --sync | source $MYVIMRC
    \| endif

" List of plugins to install 
call plug#begin('~/.local/share/nvim/plugged')

    " Startup page
    Plug 'mhinz/vim-startify'
    " Enter commands using the Russian keyboard layout
    Plug 'powerman/vim-plugin-ruscmd'
    " IDE options
    Plug 'tpope/vim-endwise'            " Automatically ends if, do, def structures
    Plug 'neomake/neomake'              " Autochecks code (with pylint, shellcheck, etc.)
    Plug 'WolfgangMehner/bash-support'  " Bash support (see :h bashsupport.txt)
    Plug 'airblade/vim-gitgutter'       " Git highlight
    Plug 'solvedbiscuit71/vim-autopair' " Insert or delete brackets, parens, quotes in pairs
    Plug 'junegunn/fzf'                 " Fuzzy finder (exec file)
    Plug 'junegunn/fzf.vim'             " Fuzzy finder (requires fzf & bat to be installed)
    Plug 'tpope/vim-commentary'         " Work with comments (gcc, gc)
    Plug 'wincent/indent-blankline.nvim'" Indentation guides
    Plug 'davidhalter/jedi-vim', { 'on': 'JediClearCache' } " Python LSP
    " NERDTree FM with icons and Git
    Plug 'preservim/nerdtree'           " NERDTree plugin
    Plug 'ryanoasis/vim-devicons'       " File icons for NERDTree
    Plug 'Xuyuanp/nerdtree-git-plugin'  " Git status flags
    " Appearance
    Plug 'arcticicestudio/nord-vim'     " Nord theme
    Plug 'itchyny/lightline.vim'        " Lightline
    Plug 'tpope/vim-fugitive'           " Branch name in lightline
    Plug 'dstein64/nvim-scrollview'     " Scrollbar
    " Float terminal in Neovim session
    Plug 'voldikss/vim-floaterm'

call plug#end()

" ###################################
" ###### PLUGINS CONFIGURATION ######
" ###################################

" ----- vim-startify ------
" Sets folder with session files
let g:startify_session_dir = '~/.local/state/nvim/sessions/'
" Sets bookmark file path
let g:startify_bookmarks = systemlist("cut -sd' ' -f 2- ~/.local/state/nvim/NERDTreeBookmarks")

" ----- neomake -----
" Neomake requires installed 'makers' packages, e.g., 'pylint' for Python, 'shellcheck' for sh/bash
" Also use ':lopen' or ':lwindow' to see the list of Neomake check results 
" F7 key enables automake
nnoremap <F7> :NeomakeEnable<CR>:call neomake#configure#automake('nrwi', 500)<CR>:Neomake<CR>
inoremap <F7> <esc>:NeomakeEnable<CR>:call neomake#configure#automake('nrwi', 500)<CR>:Neomake<CR>a
" Shift + F7 key disables automake
nnoremap <S-F7> :NeomakeDisable<CR>:NeomakeClean<CR>
inoremap <S-F7> <esc>:NeomakeDisable<CR>:NeomakeClean<CR>a
" Shfit + <F7> for alacritty and gnome-terminal
nnoremap <F19> :NeomakeDisable<CR>:NeomakeClean<CR>
inoremap <F19> <esc>:NeomakeDisable<CR>:NeomakeClean<CR>a

" ----- jedi-vim -----
" F8 activates Jedi Python LSP
autocmd FileType python map <F8> :JediClearCache<CR>
autocmd FileType python imap <F8> <ESC>:JediClearCache<CR>a

" ----- bash-support -----
" See help ':h bashsupport.txt'
"  let g:BASH_CustomTemplateFile = '~/.config/nvim/templates/template.bash'

" ----- fzf.vim -----
" F2 key opens FZF window with file preview
" Ctrl+T, Ctrl+X, or Ctrl+V to open file in a new tab, split, or vsplit
nnoremap <silent> <F2> :Files<CR>
nnoremap <silent> <S-F2> :Buffers<CR>
" Shift + <F2> for alacritty and gnome-terminal
nnoremap <silent> <F14> :Buffers<CR>
" Sets the size of the FZF window
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6  }  }
" Sets the size and position of the preview area
let g:fzf_preview_window = 'right:50%'

" ----- nerdtree -----
" Displays the bookmarks table on startup
let NERDTreeShowBookmarks = 1
" Show hidden files
let NERDTreeShowHidden=1
" Enter key in the NERDTree window opens the file in a new tab
let NERDTreeCustomOpenArgs={'file':{'where': 't'}}
" Sets arrow looks
let g:NERDTreeDirArrowExpandable = '▶'
let g:NERDTreeDirArrowCollapsible = '▼'
" Sets the bookmarks file path
let g:NERDTreeBookmarksFile = expand("~/.local/state/nvim/NERDTreeBookmarks")
" Binds the 'F3' key to toggle NERDTree
nnoremap <F3> :NERDTreeToggle<CR>
" Exit Vim if NERDTree is the only window remaining in the only tab
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
" Close the tab if NERDTree is the only window remaining in it.
autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" ----- nord-vim -----
colorscheme nord " Sets Nord theme
let g:nord_cursor_line_number_background = 1 " Highlights the background of the line number column in the cursor line
let g:nord_uniform_status_lines = 1 " Applies consistent styling to all status lines
let g:nord_bold_vertical_split_line = 1 " Makes the vertical split line between windows bold
let g:nord_uniform_diff_background = 1 " Provides a consistent background color for diff blocks
let g:nord_bold = 1 " Makes text rendered in the Nord color scheme bold
let g:nord_italic = 1 " Applies italic styling to text in the Nord color scheme
let g:nord_italic_comments = 1 " Makes comments in the Nord color scheme appear in italic style
let g:nord_underline = 1 " Adds an underline to text

" ----- lightline.vim -----
let g:lightline = {
      \ 'colorscheme': 'nord',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'readonly', 'relativepath', 'modified', 'gitbranch' ] ]
      \ },
      \ 'component': {
      \   'obsessionstatus': '%{ObsessionStatus()}'
      \ },
      \ 'separator': {
      \   'left': '', 'right': ''
      \ },
      \ 'subseparator': {
      \   'left': '', 'right': ''
      \ },
      \ 'component_function': {
      \   'gitbranch': 'FugitiveHead'
      \ },
      \ }

" ----- nvim-scrollview -----
let g:scrollview_current_only = v:true " Views the scrollbar only in the current window
let g:scrollview_winblend = 75 " Sets the level of transparency
let g:scrollview_excluded_filetypes = ['nerdtree'] " Does not show the scrollbar in NERDTree window

" ----- vim-floaterm -----
let g:floaterm_width = 0.7 " Sets the width of the terminal window
let g:floaterm_height = 0.7 " Sets the height of the terminal window
let g:floaterm_keymap_toggle = '<F4>' " F4 key toggles the terminal
" Run shell or Python script in floaterm by pressing F6 key in command or insert mode
autocmd FileType sh,python map <buffer> <F6> :w<CR>:FloatermNew! chmod ug+x <C-R>=shellescape(@%, 1)<CR> && bash -c ./<C-R>=shellescape(@%, 1)<CR><CR> bash -c 'read -p "Press Enter to exit..."' && exit<CR>
autocmd FileType sh,python imap <buffer> <F6> <esc>:w<CR>:FloatermNew! chmod ug+x <C-R>=shellescape(@%, 1)<CR> && bash -c ./<C-R>=shellescape(@%, 1)<CR><CR> bash -c 'read -p "Press Enter to exit..."' && exit<CR>

" ----- OTHERS -----
" Source the session if .session.vim exists in the current dir
if argc() == 0 && filereadable("./.session.vim")
    execute "source ./.session.vim"
    autocmd StdinReadPre * let s:std_in=1
    autocmd VimEnter * NERDTree | if argc() > 0 || exists("s:std_in") | wincmd p | endif
    autocmd BufWinEnter * if getcmdwintype() == '' | silent NERDTreeMirror | endif
endif
