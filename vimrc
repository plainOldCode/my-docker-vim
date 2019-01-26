set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim

call vundle#begin()
" let Vundle manage Vundle, required
Plugin 'gmarik/vundle'
Plugin 'vim-airline/vim-airline'
Plugin 'scrooloose/nerdtree'
Plugin 'jelera/vim-javascript-syntax'
Plugin 'airblade/vim-gitgutter'
Plugin 'tpope/vim-fugitive'
"Plugin 'crusoexia/vim-monokai'
Plugin 'junegunn/goyo.vim'
"Plugin 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
"lugin 'junegunn/fzf.vim'
"lugin 'MattesGroeger/vim-bookmarks'
"Plugin 'christoomey/vim-tmux-navigator'
"Plugin 'fatih/vim-go'
"Plugin 'tomlion/vim-solidity'
"Plugin 'prettier/vim-prettier'
" Plugin 'vim-geeknote'
call vundle#end()            " required

filetype plugin indent on 
syntax enable
set smartindent
set ts=4 ai
set noswapfile
set guifont=consolas:h10
set rtp+=/.fzf
set backspace=indent,eol,start
set fillchars+=vert:\│
hi VertSplit ctermfg=Black ctermbg=DarkGray

let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_symbols.space = "\ua0"
let g:airline_right_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_left_alt_sep= ''
let g:airline_left_sep = ''


let mapleader=","
nnoremap <Leader>rc :rightbelow vnew $MYVIMRC<CR>
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l

nnoremap <C-F> :NERDTreeToggle<CR>
"nnoremap <C-G> :Geeknote<CR>

