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
