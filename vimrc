" .vimrc

" ======================================================================================================
" Gypsy black magic {{{
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'gmarik/Vundle.vim'
Plugin 'bling/vim-airline'
call vundle#end()
filetype plugin indent on
let g:airline_powerline_fonts = 1
set t_Co=256
" }}}
" ======================================================================================================
" Some standard settings: {{{
set nocompatible
set bs=2                          " backspace should work as we expect it to
set autoindent                    " same indentation as previous line on return
set history=512                   " remember last 512 commands
set ruler                         " show cursor position in the bottom line
set guioptions=                   " remove EVERYTHING!!!
set scrolloff=5                   " let me see five lines above/below when possible
set mouse=a                       " make the mouse work
set autochdir                     " go to directory the file is in
set wrap
set textwidth=80                  " by default, wrap text at 80 columns
set number
set relativenumber                " the current line shows the line number, others show relative numbers.
set laststatus=2
syntax on                         " turn on syntax highlighting if not available by default
filetype on
filetype indent on
filetype plugin on
" }}}
" ======================================================================================================
" Small tweaks: my preferred indentation, colors, autowrite etc.:  {{{

" currently I prefer spaces instead of tabs, width of 4 chars
set shiftwidth=4
set tabstop=4
set expandtab

" my favorite colorscheme for now
colorscheme desert

" automatically save before each make/execute command
set autowrite
 
" source the vimrc file after saving it
if has("autocmd")
  autocmd bufwritepost .vimrc source %
endif

" if I press <tab> in command line, show me all options if there is more than one
set wildmenu

" adjust timeout for mapped commands: 200 milliseconds should be enough for everyone
set timeout
set timeoutlen=200

" an alias to convert a file to html, using vim syntax highlighting
command! ConvertToHTML so $VIMRUNTIME/syntax/2html.vim

" text search settings
set incsearch  " show the first match already while I type
set ignorecase
set smartcase  " only be case-sensitive if I use uppercase in my query
set hlsearch " I like when half of the text lights up

" enough with the @@@s, show all you can if the last displayed line is too long
set display+=lastline
" show chars that cannot be displayed as <13> instead of ^M
set display+=uhex

" <Ctrl-l> redraws the screen and removes any search highlighting.
nnoremap <silent> <C-l> :nohl<CR><C-l>

" }}}
" ======================================================================================================
" <Tab> at the end of a word should attempt to complete it using tokens from the current file: {{{
function! My_Tab_Completion()
    if col('.')>1 && strpart( getline('.'), col('.')-2, 3 ) =~ '^\w'
        return "\<C-P>"
    else
        return "\<Tab>"
endfunction
inoremap <Tab> <C-R>=My_Tab_Completion()<CR>
" }}}
" ======================================================================================================
" Specific settings for specific filetypes:  {{{

" usual policy: if there is a Makefile present, :mak calls make, otherwise we define a command to compile the filetype

" LaTeX
function! TEXSET()
  set makeprg=if\ \[\ -f\ \"Makefile\"\ \];then\ make\ $*;else\ if\ \[\ -f\ \"makefile\"\ \];then\ make\ $*;else\ pdflatex\ -file-line-error-style\ %\ &&\ evince\ %:r.pdf;fi;fi
  set errorformat=%f:%l:\ %m
endfunction

" Haskell
function! HSSET()
  set smartindent
  set tw=0
  set nowrap
endfunction

" C
function! CSET()
  set makeprg=if\ \[\ -f\ \"Makefile\"\ \];then\ make\ $*;else\ if\ \[\ -f\ \"makefile\"\ \];then\ make\ $*;else\ gcc\ -O2\ -std=c99\ -g\ -Wall\ -W\ -lm\ -o%.bin\ %\ &&\ ./%.bin;fi;fi
  set errorformat=%f:%l:\ %m
  set cindent
  set tw=0
endfunction

" C++
function! CPPSET()
  set makeprg=if\ \[\ -f\ \"Makefile\"\ \];then\ make\ $*;else\ if\ \[\ -f\ \"makefile\"\ \];then\ make\ $*;else\ g++\ -std=c++11\ -O2\ -g\ -Wall\ -W\ -O2\ -o%.bin\ %\ &&\ ./%.bin;fi;fi
  set cindent
  set tw=0
endfunction

" Java
function! JAVASET()
  set makeprg=if\ \[\ -f\ \"Makefile\"\ \];then\ make\ $*;else\ if\ \[\ -f\ \"makefile\"\ \];then\ make\ $*;else\ javac\ -g\ %;fi;fi
  set errorformat=%f:%l:\ %m
  set cindent
  set tw=0
endfunction

" vim scripts
function! VIMSET()
  set tw=0
  set nowrap
  set comments+=b:\"
endfunction

" Makefile
function! MAKEFILESET()
  set tw=0
  set nowrap
  " in a Makefile we need to use <Tab> to actually produce tabs
  set noet
  set sts=8
  iunmap <Tab>
endfunction

" HTML/PHP
function! HTMLSET()
  set tw=0
  set nowrap
endfunction

" Python
function! PYSET()
  set makeprg=if\ \[\ -f\ \"Makefile\"\ \];then\ make\ $*;else\ if\ \[\ -f\ \"makefile\"\ \];then\ make\ $*;else\ python3\ %;fi;fi
  set smartindent
  set tw=0
endfunction

" Perl
function! PERLSET()
  set cindent
  set tw=0
endfunction

" Ruby
function! RUBYSET()
  set smartindent
  set tw=0
endfunction

" Scheme
function! SCSET()
    set makeprg=if\ \[\ -f\ \"Makefile\"\ \];then\ make\ $*;else\ if\ \[\ -f\ \"makefile\"\ \];then\ make\ $*;else\ racket\ %;fi;fi
    inoremap [ (
    inoremap ] )
    inoremap ( [
    inoremap ) ]
    set smartindent
    set tw=0
endfunction

function! SMLSET()
    set makeprg=if\ \[\ -f\ \"Makefile\"\ \];then\ make\ $*;else\ if\ \[\ -f\ \"makefile\"\ \];then\ make\ $*;else\ mlton\ -output\ a.out\ %\ &&\ ./a.out;fi;fi
    set smartindent
    set tw=0
endfunction

" Autocommands for all languages:
autocmd FileType sml     call SMLSET()
autocmd FileType vim     call VIMSET()
autocmd FileType c       call CSET()
autocmd FileType C       call CSET()
autocmd FileType haskell call HSSET()
autocmd FileType hs      call HSSET()
autocmd FileType scheme  call SCSET()
autocmd FileType cc      call CPPSET()
autocmd FileType cpp     call CPPSET()
autocmd FileType java    call JAVASET()
autocmd FileType tex     call TEXSET()
autocmd FileType make    call MAKEFILESET()
autocmd FileType ruby    call RUBYSET()
autocmd FileType html    call HTMLSET()
autocmd FileType php     call HTMLSET()
autocmd FileType perl    call PERLSET()
autocmd FileType python  call PYSET()

" }}}
" ======================================================================================================

" finally, tell the folds to fold on file open
set fdm=marker
set commentstring=\ \"\ %s
