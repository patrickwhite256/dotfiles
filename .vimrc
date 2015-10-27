set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'gmarik/Vundle.vim'

Plugin 'sjl/badwolf'
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/syntastic'
Plugin 'flxf/uCpp.vim'
Plugin 'Xuyuanp/nerdtree-git-plugin'
Plugin 'bling/vim-airline'
Plugin 'tpope/vim-commentary'
Plugin 'nvie/vim-flake8.git'
Plugin 'tpope/vim-fugitive'
Plugin 'airblade/vim-gitgutter'
call vundle#end()

filetype plugin indent on
syntax on

set encoding=utf8
set t_Co=256

set nobackup
set nowritebackup
set noswapfile

set tabstop=4
set shiftwidth=4
set smarttab
set expandtab
set softtabstop=4
set autoindent
set smartindent
set nowrap

set nu
set hlsearch
set updatetime=750
set hidden

colorscheme badwolf

map <C-K> :bn<CR>
map <C-J> :bp<CR>
map <C-X> :bd<CR>
map <leader>k :tabn<CR>
map <leader>j :tabp<CR>
map <leader>x :tabclose<CR>

map <C-L> :redraw!<CR> :noh<CR>

if bufwinnr(1)
    map + <C-W>+
    map = <C-W>+
    map - <C-W>-
endif

highlight OverLength ctermbg=7 ctermfg=black guibg=#592929
match OverLength /\%101v.\+/
""""""""""""""""""""""""""""""""for testing above""""""""""""""""""""""""""""""""""""""""""""


"""Flake8 configuration: nvie/vim-flake8
autocmd BufWritePost *.py call Flake8()

"""Airplane configuration
set laststatus=2
let g:airline_theme = 'simple'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#branch#displayed_head_limit = 10
let g:airline_powerline_fonts = 1
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
let g:airline_left_sep = '▶'
let g:airline_right_sep = '◀'
let g:airline_symbols.branch = '⎇'

"""Nerdtree configuration
map <C-n> :NERDTreeToggle<CR>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
let NERDTreeIgnore=['\.pyc$','__pycache__']
let NERDTreeQuitOnOpen=1

let g:syntastic_cpp_compiler = 'u++'
let g:syntastic_mode_map = {'passive_filetypes': ['python']}
let g:syntastic_always_populate_loc_list = 1
