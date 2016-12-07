" Plugins

set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'gmarik/Vundle.vim'

"themes and schemes
Plugin 'sjl/badwolf'
Plugin 'vim-airline/vim-airline-themes'

"tools and addons
Plugin 'scrooloose/nerdtree'
Plugin 'Xuyuanp/nerdtree-git-plugin'
Plugin 'vim-airline/vim-airline'
Plugin 'tpope/vim-commentary'
Plugin 'nvie/vim-flake8.git'
Plugin 'tpope/vim-fugitive'
Plugin 'airblade/vim-gitgutter'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'tpope/vim-surround'
Plugin 'patrickwhite256/ag.vim'
Plugin 'Chun-Yang/vim-action-ag'
Plugin 'jpmv27/tagbar'
if has('nvim')
    Plugin 'benekastah/neomake'
    Plugin 'janko-m/vim-test'
else
    Plugin 'scrooloose/syntastic'
end

"language support
Plugin 'fatih/vim-go'
Plugin 'flxf/uCpp.vim'
Plugin 'derekwyatt/vim-scala'
Plugin 'hashivim/vim-terraform'
Plugin 'kchmck/vim-coffee-script'
Plugin 'mustache/vim-mustache-handlebars'
Plugin 'rodjek/vim-puppet'

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

"there are a lot of these... i should probably make a list
autocmd FileType javascript setlocal shiftwidth=2 softtabstop=2 tabstop=2
autocmd FileType php setlocal shiftwidth=2 softtabstop=2 tabstop=2
autocmd FileType html setlocal shiftwidth=2 softtabstop=2 tabstop=2
autocmd FileType css setlocal shiftwidth=2 softtabstop=2 tabstop=2
autocmd FileType ruby setlocal shiftwidth=2 softtabstop=2 tabstop=2
autocmd FileType yaml setlocal shiftwidth=2 softtabstop=2 tabstop=2
autocmd FileType json setlocal shiftwidth=2 softtabstop=2 tabstop=2

set nu
set hlsearch
set updatetime=750
set hidden
set ignorecase
set smartcase
set wildmenu
set mouse=

set wildignore+=*.pyc,__pycache__,tmp,__vendor

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

if has('nvim')
    " needs to be called twice since they're only reset at the end of the call
    nmap <silent> <F3> :call neomake#signs#ResetFile(bufnr('%'))<CR>:call neomake#signs#ResetFile(bufnr('%'))<CR>
else
    nmap <silent> <F3> :SyntasticReset<CR>
endif
nmap <F5> :e<CR>
nmap <F6> :execute "!markdown " expand("%") . " > " . expand("%:r") . ".html"<CR><CR>
nmap <F8> :TagbarToggle<CR>

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

""" Begone escape key

inoremap jj <Esc>

"""Airline configuration
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
let g:airline_left_alt_sep = ''
let g:airline_right_alt_sep = ''
if !empty($SUPPORTS_TRIANGLES)
    let g:airline_left_sep = '▶'
    let g:airline_right_sep = '◀'
endif
let g:airline_symbols.branch = '⎇'

"""Nerdtree configuration
map <C-n> :NERDTreeToggle<CR>
autocmd! bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
let NERDTreeIgnore=['\.pyc$','__pycache__']
let NERDTreeQuitOnOpen=1

"""Ctrlp configuration
let g:ctrlp_custom_ignore = 'node_modules'
let g:ctrlp_regexp = 1

"""TODO: if cache is stale (>1 day) clear it

let g:ag_working_path_mode="r" "90% of the time i mean 'find in project'
let g:ag_default_window_type='l' " use location list instead of quickfix window

if has('nvim')
    let g:neomake_python_enabled_makers = ['python', 'pep8', 'pylint']
    let g:neomake_cpp_gcc_args = ['-std=c++11']
    let g:neomake_javascript_enabled_makers = ['eslint']

    autocmd! BufWritePost * Neomake

    let g:test#strategy = "neovim"
    let g:test#preserve_screen = 1
    nmap <silent> <F4> :TestFile<CR>
    tnoremap <Esc> <C-\><C-n>
else
    let g:syntastic_always_populate_loc_list = 1
    let g:syntastic_python_checkers = ['python', 'pep8', 'pylint']
    let g:syntastic_aggregate_errors = 1
endif

"""go-vim configuration
let g:go_fmt_command = "goimports"
let g:go_list_type = "location"
