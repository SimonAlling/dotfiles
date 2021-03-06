" Extend default vimrc
if filereadable("/etc/vim/vimrc")
    source /etc/vim/vimrc
endif

" Tabs
set autoindent
set tabstop=4
set shiftwidth=4
set expandtab

" Line numbers
set number

" Highlight search results
set hlsearch
nnoremap <silent> <c-l> :noh<CR>
inoremap <silent> <c-l> <esc>:noh<CR>a

" Language-specific settings
filetype plugin on

" Use global undo history
if has("persistent_undo")
    set undodir=~/.vimundo/
    set undofile
endif

" Automatic HALLOJ debugging (adds HALLOJ at the top of each function)
function! HallojGo()
    " 'func', then maybe a "this", then the function name, and then the rest of the line:
    :%s_\v^(func (\(.+\) )?(\w+)\(.+)$_\1\rfmt.Println("HALLOJ \3")_
endfun
