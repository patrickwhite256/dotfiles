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
Plugin 'bling/vim-airline'
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

set nu
set hlsearch
set updatetime=750
set hidden

silent! colorscheme badwolf

highlight OverLength ctermbg=7 ctermfg=black guibg=#592929
match OverLength /\%81v.\+/
""""""""""""""""""""""""""""""""for testing above""""""""""""""""""""""""""""""""""""""""""""

"""functions to toggle quickfix window/location list/neither
"""adapted from http://vim.wikia.com/wiki/Toggle_to_open_or_close_the_quickfix_window
function! GetBufferList()
  redir =>buflist
  silent! ls!
  redir END
  return buflist
endfunction

function! ToggleList()
  let buflist = GetBufferList()
"  for bufnum in map(filter(split(buflist, '\n'), 'v:val =~ "Quickfix List"'), 'str2nr(matchstr(v:val, "\\d\\+"))')
"    if bufwinnr(bufnum) != -1
"      exec('cclose')
"      exec('lopen')
"      return
"    endif
"  endfor
  for bufnum in map(filter(split(buflist, '\n'), 'v:val =~ "Location List"'), 'str2nr(matchstr(v:val, "\\d\\+"))')
    if bufwinnr(bufnum) != -1
      exec('lclose')
      return
    endif
  endfor
"  exec('copen')
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

""" go to next/previous line with same indent

nnoremap <leader>, :call search('^'. matchstr(getline('.'), '\(^\s*\)') .'\%<' . line('.') . 'l\S', 'be')<CR>
nnoremap <leader>. :call search('^'. matchstr(getline('.'), '\(^\s*\)') .'\%>' . line('.') . 'l\S', 'e')<CR>

"""Flake8 configuration: nvie/vim-flake8
"nmap <F2> :call Flake8()<CR>
"nmap <F4> :call flake8#Flake8UnplaceMarkers()<CR>
"let g:flake8_show_quickfix = 0
"let g:flake8_show_in_gutter = 1
"autocmd BufWritePost *.py call Flake8()
" superceded by pylint in syntastic

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
let supports_triangles = $SUPPORTS_TRIANGLES
let g:airline_left_sep = ''
let g:airline_right_sep = ''
if exists('supports_triangles')
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
