" Plugins

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
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'tpope/vim-commentary'
Plugin 'nvie/vim-flake8.git'
Plugin 'tpope/vim-fugitive'
Plugin 'airblade/vim-gitgutter'
Plugin 'derekwyatt/vim-scala'
call vundle#end()

filetype plugin indent on
syntax on

"General Config

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

autocmd FileType javascript setlocal shiftwidth=2 softtabstop=2 tabstop=2
autocmd FileType php setlocal shiftwidth=2 softtabstop=2 tabstop=2

set nu
set hlsearch
set updatetime=750
set hidden

silent! colorscheme badwolf

" this is great, but it makes syntax impossible to read after 80 chars.
" especially problematic when reading other people's code.
"
" highlight OverLength ctermbg=7 ctermfg=black guibg=#592929
" match OverLength /\%81v.\+/

set colorcolumn=80

"""functions to toggle location list
"""adapted from http://vim.wikia.com/wiki/Toggle_to_open_or_close_the_quickfix_window
function! GetBufferList()
  redir =>buflist
  silent! ls!
  redir END
  return buflist
endfunction

function! ToggleList()
  let buflist = GetBufferList()
  for bufnum in map(filter(split(buflist, '\n'), 'v:val =~ "Location List"'), 'str2nr(matchstr(v:val, "\\d\\+"))')
    if bufwinnr(bufnum) != -1
      exec('lclose')
      return
    endif
  endfor
  silent! exec('lopen')
endfunction

nmap <silent> <F2> :call ToggleList()<CR>

"Mappings

nnoremap Y y$

map <C-K> :bn<CR>
map <C-J> :bp<CR>
map <C-X> :bd<CR>
map <leader>k :tabn<CR>
map <leader>j :tabp<CR>
map <leader>x :tabclose<CR>

map <C-L> :redraw!<CR>:noh<CR>
nmap <F5> :execute "!markdown " expand("%") . " > " . expand("%:r") . ".html"<CR><CR>

if bufwinnr(1)
    map + <C-W>+
    map = <C-W>+
    map - <C-W>-
endif

"viewport scrolling is hella slow in default
nnoremap <C-e> 5<C-e>
nnoremap <C-y> 5<C-y>

""" go to next/previous line with same indent

nnoremap <leader>, :call search('^'. matchstr(getline('.'), '\(^\s*\)') .'\%<' . line('.') . 'l\S', 'be')<CR>
nnoremap <leader>. :call search('^'. matchstr(getline('.'), '\(^\s*\)') .'\%>' . line('.') . 'l\S', 'e')<CR>

""" partially because i enjoy screwing with sublime text users

nnoremap <Left> <C-w>h
nnoremap <Down> <C-w>j
nnoremap <Up> <C-w>k
nnoremap <Right> <C-w>l

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

" it's such a pain getting the triangles to work
let g:airline_left_sep = ''
let g:airline_right_sep = ''
if exists($SUPPORTS_TRIANGLES)
    let g:airline_left_sep = '▶'
    let g:airline_right_sep = '◀'
endif
let g:airline_symbols.branch = '⎇'

"""Nerdtree configuration
map <C-n> :NERDTreeToggle<CR>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
let NERDTreeIgnore=['\.pyc$','__pycache__']
let NERDTreeQuitOnOpen=1

" let g:syntastic_mode_map = {'passive_filetypes': ['python']}
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_python_checkers = ['python', 'pep8', 'pylint']
let g:syntastic_aggregate_errors = 1
