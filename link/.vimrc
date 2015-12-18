" Necesary for lots of cool vim things
set nocompatible
let $BASH_ENV='~/.bashrc'
" install pathogen
" execute pathogen#infect()
syntax on
filetype plugin indent on

" Change mapleader
let mapleader="\<Space>"

" Now ; works just like : but with 866% less keypresses!
nnoremap ; :

" Move more naturally up/down when wrapping is enabled.
nnoremap j gj
nnoremap k gk

" Local dirs setup
set backupdir=$DOTFILES/caches/vim
set directory=$DOTFILES/caches/vim
set undodir=$DOTFILES/caches/vim
let g:netrw_home = expand('$DOTFILES/caches/vim')

" Theme / Syntax highlighting
augroup color_scheme
  autocmd!
  " Make invisible chars less visible in terminal.
  autocmd ColorScheme * :hi NonText ctermfg=236
  autocmd ColorScheme * :hi SpecialKey ctermfg=236
  " Show trailing whitespace.
  autocmd ColorScheme * :hi ExtraWhitespace ctermbg=red guibg=red
augroup END
colorscheme molokai
set background=dark

" Visual settings
set cursorline " Highlight current line
set number " Enable line numbers.
set showtabline=2 " Always show tab bar.
set relativenumber " Use relative line numbers. Current line is still in status bar.
set title " Show the filename in the window titlebar.
set nowrap " Do not wrap lines.
set noshowmode " Don't show the current mode (airline.vim takes care of us)
set laststatus=2 " Always show status line

" Toggle between absolute and relative line numbers
augroup relative_numbers
  autocmd!
  " Show absolute numbers in insert mode
  autocmd InsertEnter * :set norelativenumber
  autocmd InsertLeave * :set relativenumber
augroup END

" Make it obvious where 80 characters is
set textwidth=80
set colorcolumn=+1

" Scrolling
set scrolloff=3 " Start scrolling three lines before horizontal border of window.
set sidescrolloff=3 " Start scrolling three columns before vertical border of window.

" Indentation
set autoindent " Copy indent from last line when starting new line.
set shiftwidth=2 " The # of spaces for indenting.
set smarttab " At start of line, <Tab> inserts shiftwidth spaces, <Bs> deletes shiftwidth spaces.
set softtabstop=2 " Tab key results in 2 spaces
set tabstop=2 " Tabs indent only 2 spaces
set expandtab " Expand tabs to spaces

"" Java Indentation
au FileType java setl sw=4 sts=2 ts=4 et

" Reformatting
set nojoinspaces " Only insert single space after a '.', '?' and '!' with a join command.

" Toggle show tabs and trailing spaces (,c)
set listchars=tab:▸\ ,trail:·,eol:¬,nbsp:_,extends:>,precedes:<
"set listchars=tab:>\ ,trail:.,eol:$,nbsp:_,extends:>,precedes:<
"set fillchars=fold:-
nnoremap <silent> <leader>v :call ToggleInvisibles()<CR>

" Extra whitespace
augroup highlight_extra_whitespace
  autocmd!
  autocmd BufWinEnter * :2match ExtraWhitespaceMatch /\s\+$/
  autocmd InsertEnter * :2match ExtraWhitespaceMatch /\s\+\%#\@<!$/
  autocmd InsertLeave * :2match ExtraWhitespaceMatch /\s\+$/
augroup END

" Toggle Invisibles / Show extra whitespace
function! ToggleInvisibles()
  set nolist!
  if &list
    hi! link ExtraWhitespaceMatch ExtraWhitespace
  else
    hi! link ExtraWhitespaceMatch NONE
  endif
endfunction

set nolist
call ToggleInvisibles()

" Trim extra whitespace
function! StripExtraWhiteSpace()
  let l = line(".")
  let c = col(".")
  %s/\s\+$//e
  call cursor(l, c)
endfunction
noremap <leader>ss :call StripExtraWhiteSpace()<CR>

" Search / replace
set gdefault " By default add g flag to search/replace. Add g to toggle.
set hlsearch " Highlight searches
set incsearch " Highlight dynamically as pattern is typed.
set ignorecase " Ignore case of searches.
set smartcase " Ignore 'ignorecase' if search pattern contains uppercase characters.

" Clear last search
map <silent> <leader>/ <Esc>:nohlsearch<CR>

" Ignore things
set wildignore+=*.jpg,*.jpeg,*.gif,*.png,*.gif,*.psd,*.o,*.obj,*.min.js
set wildignore+=*/bower_components/*,*/node_modules/*
set wildignore+=*/vendor/*,*/.git/*,*/.hg/*,*/.svn/*,*/log/*,*/tmp/*

" Vim commands
set hidden " When a buffer is brought to foreground, remember undo history and marks.
set report=0 " Show all changes.
set mouse=a " Enable mouse in all modes.
set shortmess+=I " Hide intro menu.

" Splits
set splitbelow " New split goes below
set splitright " New split goes right

" Ctrl-J/K/L/H select split
nnoremap <C-j> <C-W>j
nnoremap <C-k> <C-W>k
nnoremap <C-l> <C-W>l
nnoremap <C-h> <C-W>h
nnoremap <leader>w <C-w>v<C-w>l

" Buffer navigation
nnoremap <leader>b :CtrlPBuffer<CR> " List other buffers
nnoremap <leader>B :Buffers<CR> " Buffers navigation
map <leader><leader> :b#<CR> " Switch between the last two files
map gb :bnext<CR> " Next buffer
map gB :bprev<CR> " Prev buffer

" Jump to buffer number 1-9 with ,<N> or 1-99 with <N>gb
let c = 1
while c <= 99
  if c < 10
    execute "nnoremap <silent> <leader>" . c . " :" . c . "b<CR>"
  endif
  execute "nnoremap <silent> " . c . "gb :" . c . "b<CR>"
  let c += 1
endwhile

" Fix page up and down
map <PageUp> <C-U>
map <PageDown> <C-D>
imap <PageUp> <C-O><C-U>
imap <PageDown> <C-O><C-D>

" Use Q for formatting the current paragraph (or selection)
" vmap Q gq
" nmap Q gqap

" When editing a file, always jump to the last known cursor position. Don't do
" it for commit messages, when the position is invalid, or when inside an event
" handler (happens when dropping a file on gvim).
augroup vimrcEx
  autocmd!
  autocmd BufReadPost *
    \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif
augroup END

" F12: Source .vimrc & .gvimrc files
nmap <F12> :call SourceConfigs()<CR>

if !exists("*SourceConfigs")
  function! SourceConfigs()
    let files = ".vimrc"
    source $MYVIMRC
    if has("gui_running")
      let files .= ", .gvimrc"
      source $MYGVIMRC
    endif
    echom "Sourced " . files
  endfunction
endif

"" FILE TYPES
augroup file_types
  autocmd!

  " vim
  autocmd BufRead .vimrc,*.vim set keywordprg=:help

augroup END

" PLUGINS

" Ack
nnoremap <leader>a :Ag<space>

" Airline
let g:airline_powerline_fonts = 1 " TODO: detect this?
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_format = '%s '
let g:airline#extensions#tabline#buffer_nr_show = 1
"let g:airline#extensions#tabline#fnamecollapse = 0
"let g:airline#extensions#tabline#fnamemod = ':t'

" Bbye aka Bdelete
:nnoremap <Leader>q :Bdelete<CR>

" NERDTree
let NERDTreeShowHidden = 1
let NERDTreeMouseMode = 2
let NERDTreeMinimalUI = 1
" Open automatically if no files were specified on the CLI.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
" Automatically close vim if NERDTree is the only file open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
" Map Toggel and Focus to n and N
map <leader>n :NERDTreeToggle<CR>
map <leader>N :NERDTreeFocus<CR>

" Tagbar
map <leader>t :Tagbar<CR>

" Signify
let g:signify_vcs_list = ['git', 'hg', 'svn']

" CtrlP.vim
map <leader>p <C-P>
map <leader>r :CtrlPMRUFiles<CR>
"let g:ctrlp_match_window_bottom = 0 " Show at top of window

" Indent Guides
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1

" Mustache/handlebars
let g:mustache_abbreviations = 1

" Vimux
map <leader>Vn :wa <bar> VimuxRunCommand ''<Left>
map <leader>Vl :wa <bar> VimuxRunLastCommand <CR>
map <leader>Vc :VimuxCloseRunner <CR>

" https://github.com/junegunn/vim-plug
" Reload .vimrc and :PlugInstall to install plugins.
call plug#begin('~/.vim/plugged')
Plug 'rking/ag.vim'
Plug 'bling/vim-airline'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-bundler'
Plug 'scrooloose/nerdtree'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'fatih/vim-go'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'pangloss/vim-javascript'
Plug 'mhinz/vim-signify'
Plug 'mattn/emmet-vim'
Plug 'mustache/vim-mustache-handlebars'
Plug 'chase/vim-ansible-yaml'
Plug 'wavded/vim-stylus'
Plug 'vim-ruby/vim-ruby'
Plug 'tpope/vim-rails'
Plug 'ervandew/supertab'
Plug 'tpope/vim-cucumber'
Plug 'tpope/vim-haml'
Plug 'skalnik/vim-vroom'
Plug 'tpope/vim-endwise'
Plug 'godlygeek/tabular'
Plug 'slim-template/vim-slim'
Plug 'thoughtbot/vim-rspec'
Plug 'kchmck/vim-coffee-script'
Plug 'sandeepravi/refactor-rails.vim'
Plug 'scrooloose/syntastic'
Plug 'majutsushi/tagbar'
Plug 'vim-scripts/ZoomWin'
Plug 'vim-scripts/drools.vim'
Plug 'benmills/vimux'
Plug 'vim-scripts/java_checkstyle.vim'
Plug 'tpope/vim-abolish'
Plug 'moll/vim-bbye'
call plug#end()

set encoding=utf-8
" Clear search text
nnoremap <leader>, :noh<cr>
" Map tab for moving around better
nnoremap <tab> %
vnoremap <tab> %
" Disable arrow keys to avoid using them
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>

" get rid of F1 Key
inoremap <F1> <ESC>
nnoremap <F1> <ESC>
vnoremap <F1> <ESC>

" Auto save on focus lost
au FocusLost * :wa

" fold html tag
nnoremap <leader>ft Vatzf

" hight text that was just pasted
nnoremap <leader>v V`]

" open .vimrc in split pane
nnoremap <leader>ev <C-w><C-v><C-l>:e $MYVIMRC<cr>

" map jj to escape
inoremap jj <ESC>

autocmd BufRead *_spec.rb syn keyword rubyRspec describe context it specify it_should_behave_like before after setup subject its shared_examples_for shared_context let
au bufreadpost,filereadpost *.drl set ft=drools

nnoremap <leader>a :Ag<space>
highlight def link rubyRspec Function
