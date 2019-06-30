set nocompatible
filetype off " required

" https://github.com/junegunn/vim-plug
" Reload .vimrc and :PlugInstall to install plugins.
call plug#begin('~/.vim/plugged')

Plug 'VundleVim/Vundle.vim'
Plug 'tpope/vim-sensible'
Plug 'rodjek/vim-puppet'
Plug 'hashivim/vim-vagrant'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'scrooloose/syntastic'
Plug 'elzr/vim-json'
Plug 'pangloss/vim-javascript', {'for': 'javascript'}
Plug 'sheerun/vim-polyglot'
Plug 'ryanoasis/vim-devicons'
Plug 'Raimondi/delimitMate'
Plug 'jwalton512/vim-blade'
Plug 'joshdick/onedark.vim'
Plug 'sonph/onehalf', {'rtp': 'vim/'}
Plug 'chase/vim-ansible-yaml'
Plug 'hashivim/vim-terraform'

call plug#end()

set tabstop=2
set expandtab
set softtabstop=2
set shiftwidth=2
"set modeline
set directory=""
set fo=tcq
set encoding=utf-8
set ruler
set number
set nowrap
set nobackup
set noswapfile
set nowb
set splitright
" Keep undo history across sessions, by storing in file.
silent !mkdir ~/.vim/backups > /dev/null 2>&1
set undodir=~/.vim/backups
set undofile
set cursorline
syntax on

" No arrow keys in vim!
noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>

" All things theme
if has("gui_macvim")
  set macligatures
endif

if has('gui_running')
  set guifont=Noto\ Mono\ For\ Powerline\ 9
  let g:enable_bold_font = 1
  set guioptions-=T
 "" set guioptions-=m
  set anti
  set gtl=%t gtt=%F
  let &t_SI = "\<Esc>]50;CursorShape=1\x7" " Vertical bar in insert mode
  let &t_EI = "\<Esc>]50;CursorShape=0\x7" " Block in normal mode
else
  " SO we are running vim in a terminal
  set t_Co=256
  set ttyfast
  if exists('+termguicolors')
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    set termguicolors
  endif
endif

colorscheme onehalfdark
highlight comment ctermfg=cyan
highlight Normal ctermbg=NONE
highlight nonText ctermbg=NONE
set linespace=10

" Airline settings
let g:airline_theme='onehalfdark'
let g:airline_powerline_fonts = 1
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_symbols.space = "\ua0"
"let g:airline_section_y = '%{substitute(getcwd(), expand("$HOME"), "~", "g")}'
"let g:airline#extensions#whitespace#enabled = 0
let g:airline#extensions#tabline#enabled = 1
"let g:airline#extensions#tabline#show_buffers = 0
let g:airline#extensions#hunks#enabled = 0
let g:airline#extensions#tagbar#enabled = 0
"let g:airline#extensions#tabline#left_sep = ' '
"let g:airline#extensions#tabline#left_alt_sep = '│'

" Set up puppet manifest and spec options
"
au BufRead,BufNewFile *.pp
  \ set filetype=puppet
au BufRead,BufNewFile *_spec.rb
  \ nmap <F8> :!rspec --color %<CR>

" Syntastic settings
let g:syntastic_enable_signs = 1
let g:syntastic_error_symbol = "x"
let g:syntastic_style_error_symbol = "x"
let g:syntastic_warning_symbol = "▵"
let g:syntastic_style_warning_symbol = "▵"
let g:syntastic_loc_list_height = 5
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_aggregate_errors = 1
let g:syntastic_auto_jump = 3
let g:syntastic_php_checkers = ['php', 'phpcs', 'phpmd']
let g:syntastic_javascript_checkers = ['eslint']
let g:syntastic_scss_checkers = []
let g:syntastic_puppet_lint_arguments = '--no-140chars-check'

" Terrafrom
let g:terraform_align=1
let g:terraform_fold_sections=1
let g:terraform_remap_spacebar=1
let g:terraform_fmt_on_save=1

