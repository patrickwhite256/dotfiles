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
Plugin 'w0rp/ale'
Plugin 'scrooloose/nerdtree'
" Plugin 'Shougo/deoplete.nvim'
Plugin 'neoclide/coc.nvim', {'branch': 'release'}
" Plugin 'stamblerre/gocode', {'rtp': 'nvim/'}
Plugin 'Xuyuanp/nerdtree-git-plugin'
Plugin 'vim-airline/vim-airline'
Plugin 'tpope/vim-commentary'
Plugin 'nvie/vim-flake8.git'
Plugin 'tpope/vim-fugitive'
Plugin 'airblade/vim-gitgutter'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-unimpaired'
Plugin 'patrickwhite256/ag.vim'
Plugin 'Chun-Yang/vim-action-ag'
Plugin 'jpmv27/tagbar'
Plugin 'inkarkat/vim-ingo-library'
Plugin 'inkarkat/vim-mark'
if has('nvim')
    " Plugin 'benekastah/neomake'
    Plugin 'janko-m/vim-test'
else
    Plugin 'scrooloose/syntastic'
end

"language support
Plugin 'fatih/vim-go'
Plugin 'flxf/uCpp.vim'
Plugin 'derekwyatt/vim-scala'
Plugin 'elixir-editors/vim-elixir'
Plugin 'hashivim/vim-terraform'
Plugin 'kchmck/vim-coffee-script'
Plugin 'mustache/vim-mustache-handlebars'
Plugin 'rodjek/vim-puppet'
Plugin 'uarun/vim-protobuf'

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
autocmd FileType typescript setlocal shiftwidth=2 softtabstop=2 tabstop=2

set nu
set hlsearch
set updatetime=300
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

set colorcolumn=120

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
" nmap <F8> :TagbarToggle<CR>

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

""" Am I getting lazy? Yes.

inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

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

" requires glyphs from ryanoasis/powerline-extra-symbols
let g:airline_left_sep = ''
let g:airline_right_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_alt_sep = ''
if !empty($SUPPORTS_TRIANGLES)
    let g:airline_left_sep = "\ue0b0"
    let g:airline_right_sep = "\ue0b2"
endif
let g:airline_symbols.branch = "\ue0a0"

"""Nerdtree configuration
map <C-n> :NERDTreeToggle<CR>
autocmd! bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
let NERDTreeIgnore=['\.pyc$','__pycache__']
let NERDTreeQuitOnOpen=1

"""Ctrlp configuration
let g:ctrlp_custom_ignore = {
\ 'dir': '\v(node_modules|dist)$',
\}
let g:ctrlp_regexp = 1

"""TODO: if cache is stale (>1 day) clear it

let g:ag_working_path_mode="r" "90% of the time i mean 'find in project'
let g:ag_default_window_type='l' " use location list instead of quickfix window

""" ale config
let g:ale_linters = {
\   'go': ['gobuild', 'gofmt', 'golangci-lint'],
\}
let g:ale_go_golangci_lint_options = ""
let g:ale_go_golangci_lint_package=1

if has('nvim')
    " let g:neomake_python_enabled_makers = ['python', 'pep8', 'pylint']
    " let g:neomake_python_pep8_maker = {
    " \ 'args': [
    " \   '--config=/Users/whpatr/go/src/code.justin.tv/liverecs/model-generation/pep8.ini'
    " \ ],
    " \ 'errorformat': '%f:%l:%c: %m',
    " \ 'postprocess': function('neomake#makers#ft#python#Pep8EntryProcess')
    " \ }
    " let g:neomake_cpp_gcc_args = ['-std=c++11']
    " let g:neomake_javascript_enabled_makers = ['eslint']
    " let g:neomake_go_enabled_makers = [ 'go', 'golangci-lint' ]
    " let g:neomake_go_gometalinter_maker = {
  " \ 'args': [
  " \   '--tests',
  " \   '--enable-gc',
  " \   '--concurrency=3',
  " \   '--fast',
  " \   '-D', 'aligncheck',
  " \   '-D', 'dupl',
  " \   '-D', 'gocyclo',
  " \   '-D', 'gotype',
  " \   '-E', 'errcheck',
  " \   '-E', 'misspell',
  " \   '-E', 'unused',
  " \   '%:p:h',
  " \ ],
  " \ 'append_file': 0,
  " \ 'errorformat':
  " \   '%E%f:%l:%c:%trror: %m,' .
  " \   '%W%f:%l:%c:%tarning: %m,' .
  " \   '%E%f:%l::%trror: %m,' .
  " \   '%W%f:%l::%tarning: %m'
  " \ }

    " autocmd! BufWritePost * Neomake

    " let g:test#strategy = "neovim"
    " let g:test#preserve_screen = 1
    " nmap <silent> <F4> :TestFile<CR>
    tnoremap <Esc> <C-\><C-n>
    let g:go_term_enabled = 1
    let g:go_term_mode = "split"
else
    " let g:syntastic_always_populate_loc_list = 1
    " let g:syntastic_python_checkers = ['python', 'pep8', 'pylint']
    " let g:syntastic_aggregate_errors = 1
endif

"""go-vim configuration
let g:go_list_type = "location"
let g:go_list_type_commands = {"GoTest": "quickfix", "GoTestFunc": "quickfix"}
" let g:go_auto_type_info = 0
let g:go_fmt_command='goimports'
let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_operators = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_build_constraints = 1
let g:go_highlight_generate_tags = 1
let g:go_auto_sameids = 1
" disable all linters as that is taken care of by coc.nvim
let g:go_diagnostics_enabled = 0
let g:go_metalinter_enabled = []
let g:go_auto_type_info = 1
" let g:go_build_tags = 'integration'
" let g:go_def_mode = 'godef'
" set updatetime=750
let g:go_updatetime=100
nmap <F8> :GoTestFunc<CR>

let g:go_def_mapping_enabled = 0
nmap <silent> gd <Plug>(coc-definition)

let g:coc_global_extensions = ['coc-json', 'coc-html', 'coc-pyright', 'coc-css', 'coc-go']

"deoplete conf
let g:deoplete#enable_at_startup = 1
" call deoplete#custom#option('omni_patterns', { 'go': '[^. *\t]\.\w*' })
set completeopt=menu,menuone
" au filetype go inoremap <buffer> . .<C-x><C-o>

" let g:deoplete#sources#go#sort_class = ['package', 'func', 'type', 'var', 'const']
" let g:deoplete#sources#go#use_cache = 1
" let g:deoplete#sources#go#json_directory = '/path/to/data_dir'

""" folding conf
set foldmethod=indent
set foldlevel=1
set foldnestmax=1
set foldclose=all
""" vim-go screws up folding on save
autocmd BufWritePost *.go normal! zv

""" i got mad at my colour scheme
" 'lime' from badwolf
highlight DiffAdd guifg=#aeee00 ctermfg=154
"  'dress' from badwolf
highlight DiffDelete guifg=#ff9eb8 ctermfg=211
highlight GitGutterChangeDelete guifg=#ff9eb8 ctermfg=211
" 'dirtyblonde' from badwolf
highlight DiffChange guifg=#f4cf86 ctermfg=222
