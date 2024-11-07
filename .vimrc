syntax on
set scrolloff=8
set ttyfast
set number
set relativenumber
set tabstop=4 
set softtabstop=4
set shiftwidth=4
set expandtab
set smartindent
set splitbelow
set updatetime=100
set encoding=utf-8
set clipboard=unnamedplus

" Searching
set hlsearch
set incsearch
set smartcase
set showmatch

" Colors
set background=dark
set termguicolors
colorscheme catppuccin_frappe

" Basic remaps
let mapleader = " "
nnoremap <leader>pv :Vex<CR>
nnoremap <leader><CR> :so ~/.vimrc<CR>
nnoremap <leader>nh :nohlsearch<CR>
nnoremap <leader>t :term ++close<CR>
