" https://github.com/gmarik/vimfiles/blob/master/vimrc


" General "{{{
set nocompatible  " disable vi compatibility.

set t_Co=256

scriptencoding utf-8           " utf-8 all the way
set encoding=utf-8

set history=256                " Number of things to remember in history.
set timeoutlen=250             " Time to wait after ESC (default causes an annoying delay)
set clipboard+=unnamed         " Yanks go on clipboard instead.
set pastetoggle=<F10>          " toggle between paste and normal: for 'safer' pasting from keyboard
set shiftround                 " round indent to multiple of 'shiftwidth'
set tags=.git/tags;$HOME       " consider the repo tags first, then
                               " walk directory tree upto $HOME looking for
                               " tags
                               " note `;` sets the stop folder. :h file-search
set modeline
set modelines=5                " default numbers of lines to read for modeline instructions

set autowrite                  " Writes on make/shell commands
set autoread

set nobackup
set nowritebackup
set directory=/tmp//           " prepend(^=) $HOME/.tmp/ to default path; use full path as backup filename(//)
set noswapfile                 "

set hidden                     " The current buffer can be put to the background without writing to disk

set hlsearch                   " highlight search
set ignorecase                 " be case insensitive when searching
set smartcase                  " be case sensitive when input has a capital letter
set incsearch                  " show matches while typing
" "}}}

" Formatting "{{{
set fo+=o                      " Automatically insert the current comment leader after hitting 'o' or 'O' in Normal mode.
set fo-=r                      " Do not automatically insert a comment leader after an enter
set fo-=t                      " Do no auto-wrap text using textwidth (does not apply to comments)

set wrap
set textwidth=0                " Don't wrap lines by default

set tabstop=2                  " tab size eql 2 spaces
set softtabstop=2
set shiftwidth=2               " default shift width for indents
set expandtab                  " replace tabs with ${tabstop} spaces
set smarttab                   "

set backspace=indent
set backspace+=eol
set backspace+=start

set autoindent
set cindent
set indentkeys-=0#            " do not break indent on #
set cinkeys-=0#
set cinoptions=:s,ps,ts,cs
set cinwords=if,else,while,do
set cinwords+=for,switch,case
" "}}}

" Visual "{{{
syntax on                      " enable syntax

set mouse=a "enable mouse in GUI mode
set mousehide                 " Hide mouse after chars typed

set number                  " line numbers Off
set showmatch                 " Show matching brackets.
set matchtime=2               " Bracket blinking.

set wildmode=longest,list     " At command line, complete longest common string, then list alternatives.

set completeopt+=preview

set foldenable                " Turn on folding
set foldmethod=marker         " Fold on the marker
set foldlevel=100             " Don't autofold anything (but I can still fold manually)

set foldopen=block,hor,tag    " what movements open folds
set foldopen+=percent,mark
set foldopen+=quickfix

set virtualedit=block

set splitbelow
set splitright

set list                      " display unprintable characters f12 - switches
set listchars=tab:\ ·,eol:¬
set listchars+=trail:·
set listchars+=extends:»,precedes:«
map <silent> <F12> :set invlist<CR>

if has("multi_byte")
  if &termencoding == ""
    let &termencoding = &encoding
  endif
  set encoding=utf-8
  setglobal fileencoding=utf-8
  "setglobal bomb
  set fileencodings=ucs-bom,utf-8,latin1
endif

if has('gui_running')
  set guioptions-=T  " no toolbar
  set guifont=Andale\ Mono
  "set guioptions=cMg " console dialogs, do not show menu and toolbar

  "if has('mac')
  if has('gui_macvim')
    "set guifont=Andale\ Mono:h13
    "set guifont=Liberation\ Mono\ for\ Powerline
    set guifont=Liberation\ Mono\ Powerline\ Nerd\ Font\ Complete

    set noantialias
    set fuoptions=maxvert,maxhorz ",background:#00AAaaaa
  elseif has('gui_win32')
    "set guifont=Terminus:h16
    "set guifont=Liberation\ Mono\ for\ Powerline
    "set guifont=DejaVu\ Sans\ Mono\ 10

    source $VIMRUNTIME/mswin.vim
    behave mswin
  end
endif


" Scripts and Plugins " {{{
filetype off  " must be off before Vundle has run
" Load vim-plug
if empty(glob("~/.vim/autoload/plug.vim"))
    execute '!curl -fLo ~/.vim/autoload/plug.vim https://raw.github.com/junegunn/vim-plug/master/plug.vim'
endif

call plug#begin('~/.vim/plugged')


" Design and Color schemes
Plug 'flazz/vim-colorschemes'
if has("gui_running")
  "colorscheme zenburn
  colorscheme desert
else
  colorscheme desert
endif

Plug 'nathanaelkane/vim-indent-guides'  "visually displaying indent levels in code

" Syntax checker
Plug 'scrooloose/syntastic'
let g:syntastic_python_checkers=['flake8','python']
let g:syntastic_python_checker_args='--ignore=E501,E225'

" Syntax highlight
Plug 'gmarik/vim-markdown'
Plug 'timcharper/textile.vim'

" Golang
Plug 'fatih/vim-go'


" Files
Plug 'Xuyuanp/git-nerdtree'  "NERDTree with git status support

" Utility
Plug 'tmux-plugins/vim-tmux-focus-events' "This Plug restores them when using vim inside Tmux.
Plug 'gmarik/sudo-gui.vim' "sudo GUI for a GUI vim
Plug 'vim-scripts/lastpos.vim'  "Last position jump improved for Easy Vim
Plug 'sjl/gundo.vim'  "Graph vim undo tree in style
"Plug 'wincent/Command-T'  "extremely fast, intuitive mechanism for opening files and buffers with a minimal number of keystrokes
Plug 'tpope/vim-surround'  "quoting/parenthesizing made simple

" Python
" Plug 'vim-scripts/pep8'  "Check your python source files with PEP8

" Productivity
Plug 'vim-scripts/TaskList.vim'  "Eclipse like task list
"nnoremap <leader>t <Plug>TaskList
let mapleader = "."

" Foo
Plug 'mhinz/vim-startify'   "fancy start screen for Vim.

" Git integration
Plug 'tpope/vim-fugitive'  "Git wrapper so awesome, it should be illegal
Plug 'airblade/vim-gitgutter'  "shows a git diff in the gutter (sign column) and stages/reverts hunks

" Status Bar
Plug 'bling/vim-airline'   "lean & mean status/tabline for vim that's light as air
let g:airline_powerline_fonts = 1 "Use nice powerline-fonts
let g:airline_theme = 'dark' "solized theme

"Bundle 'mileszs/ack.vim'  "Vim Plug for the Perl module / CLI script 'ack'

" All of your Plugins must be added before the following line
filetype plugin indent on    " required
call plug#end()

"set guifont=Liberation\ Mono\ Powerline\ Nerd\ Font\ Complete:h12
"set guifont=Liberation\ Mono\ Powerline\ Nerd\ Font\ Complete:h12
"set guifont=Knack\ Regular\ Nerd\ Font:h12
set guifont=Andale\ Mono

set laststatus=2 " Always display the statusline in all windows
set showtabline=2 " Always display the tabline, even if there is only one tab
set noshowmode " Hide the default mode text (e.g. -- INSERT -- below the statusline)

