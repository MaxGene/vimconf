
" An example for a vimrc file.
"
" Maintainer: Bram Moolenaar <Bram@vim.org>
" Last change: 2008 Dec 17
"
" To use it, copy it to
" for Unix and OS/2: ~/.vimrc
" for Amiga: s:.vimrc
" for MS-DOS and Win32: $VIM\_vimrc
" for OpenVMS: sys$login:.vimrc

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

""""""""""""""""""""""""""""
" Generic configs
" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" Enable pathogen. Filetype has to be set off for this part.
" filetype off
" call pathogen#runtime_append_all_bundles()
" call pathogen#helptags()

" Set the leader key for other shortcuts
let mapleader = ","
" allow backspacing over everything in insert mode
set backspace=indent,eol,start


" ,v brings up my .vimrc
" " ,V reloads it -- making all changes active (have to save first)
map <leader>v :sp ~/.vimrc<CR><C-W>_
map <silent> <leader>V :source ~/.vimrc<CR>:filetype detect<CR> ":echo 'vimrc reloaded'"<CR>

set wildmode=longest:full
set wildmenu
set whichwrap+=<,>,h,l

" Bash like keys for the command line
cnoremap <C-P> <Up>
cnoremap <C-N> <Down>

" Smart way to move btw. windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" Use the arrows to something useful
map <right> :bn<cr>
map <left> :bp<cr>

"Taglist; hit TT to see functions/classes in new window
map TT :TagbarToggle <CR>
let Tlist_Use_Right_Window = 1
set tabstop=4

" Open tasklist
map <leader>t <Plug>TaskList

" Open a gundo window to revert to previous writes of current file
map <leader>g :GundoToggle<CR>

" Less GUI in GVIM
set guioptions=
set guioptions+=c
set guioptions+=e
" Rainbow parens
au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces

"Statusline
set statusline= " clear the statusline for when vimrc is reloaded
set statusline+=%-3.3n\ " buffer number
set statusline+=%f\ " file name
set statusline+=%h%m%r%w " flags
set statusline+=[%{strlen(&ft)?&ft:'none'}, " filetype
set statusline+=%{strlen(&fenc)?&fenc:&enc}, " encoding
set statusline+=%{&fileformat}] " file format
set statusline+=%= " right align
set statusline+=%{synIDattr(synID(line('.'),col('.'),1),'name')}\ " highlight
set statusline+=%b,0x%-8B\ " current char
set statusline+=%-14.(%l,%c%V%)\ %<%P " offset

set laststatus=2

if has("vms")
  set nobackup " do not keep a backup file, use versions instead
else
  set backup " keep a backup file
endif
set history=50 " keep 50 lines of command line history
set ruler " show the cursor position all the time
set showcmd " display incomplete commands
set incsearch " do incremental searching

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot. Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

" Enable file type detection.
" Use the default filetype settings, so that mail gets 'tw' set to 72,
" 'cindent' is on in C files, etc.
" Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

" Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

" For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid or when inside an event handler
" (happens when dropping a file on gvim).
" Also don't do it when the mark is in the first line, that is the default
" position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \ exe "normal! g`\"" |
    \ endif

  augroup END

else

  set autoindent " always set autoindenting on

endif " has("autocmd")

" w!! will invoke superuser privileges and write the file anyway
cmap w!! %!sudo tee > /dev/null %

" jk = <esc>
imap jk <Esc>

" Regular expression keys are a pain.
map H ^
map L $

set hidden

"Less clunky clipboard bindings
map <Leader>y "+y
map <Leader>p "+p

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
\ | wincmd p | diffthis
endif
" Liquid Carbon colorscheme and line numbers.
colorscheme liquidcarbon
set number
nnoremap <F2> :set nonumber!<CR>:set foldcolumn=0<CR>

"Word wrap.
set wrap
set linebreak
set nolist
"Omnicompletion.
inoremap <Nul> <C-x><C-o>
filetype plugin indent on

" Smarter searching
set ignorecase
set smartcase

" Set the terminal's title
set title

" Easier access to NERDTree
map <leader>n :NERDTreeToggle<CR>

" And to project.vim
map <leader>p :Project<CR>

" gundo
map <leader>g :GundoToggle<CR>

" Ropevim settings
" Also note "Ctrl-C F" will find instances of a name in the project
map <leader>j :RopeGotoDefinition<CR>
map <leader>r :RopeRename<CR>
map <leader>c :RopeCodeAssist<CR>

" Enable Ack
nmap <leader>a <Esc>:Ack!

" jeetworks.org/node/89
" Up and down delete and insert blank lines

function! DelEmptyLineAbove()
    if line(".") == 1
        return
    endif
    let l:line = getline(line(".") - 1)
    if l:line =~ '^\s*$'
        let l:colsave = col(".")
        .-1d
        silent normal! <C-y>
        call cursor(line("."), l:colsave)
    endif
endfunction
 
function! AddEmptyLineAbove()
    let l:scrolloffsave = &scrolloff
    " Avoid jerky scrolling with ^E at top of window
    set scrolloff=0
    call append(line(".") - 1, "")
    if winline() != winheight(0)
        silent normal! <C-e>
    endif
    let &scrolloff = l:scrolloffsave
endfunction
 
function! DelEmptyLineBelow()
    if line(".") == line("$")
        return
    endif
    let l:line = getline(line(".") + 1)
    if l:line =~ '^\s*$'
        let l:colsave = col(".")
        .+1d
        ''
        call cursor(line("."), l:colsave)
    endif
endfunction
 
function! AddEmptyLineBelow()
    call append(line("."), "")
endfunction
 
" Arrow key remapping: Up/Dn = move line up/dn; Left/Right = indent/unindent
function! SetArrowKeysAsTextShifters()
    " normal mode
    nnoremap <silent> <Up> <Esc>:call DelEmptyLineAbove()<CR>
    nnoremap <silent> <Down>  <Esc>:call AddEmptyLineAbove()<CR>
    nnoremap <silent> <C-Up> <Esc>:call DelEmptyLineBelow()<CR>
    nnoremap <silent> <C-Down> <Esc>:call AddEmptyLineBelow()<CR>
 
    " visual mode
    vnoremap <silent> <Up> <Esc>:call DelEmptyLineAbove()<CR>gv
    vnoremap <silent> <Down>  <Esc>:call AddEmptyLineAbove()<CR>gv
    vnoremap <silent> <C-Up> <Esc>:call DelEmptyLineBelow()<CR>gv
    vnoremap <silent> <C-Down> <Esc>:call AddEmptyLineBelow()<CR>gv
 
    " insert mode
    inoremap <silent> <Up> <Esc>:call DelEmptyLineAbove()<CR>a
    inoremap <silent> <Down> <Esc>:call AddEmptyLineAbove()<CR>a
    inoremap <silent> <C-Up> <Esc>:call DelEmptyLineBelow()<CR>a
    inoremap <silent> <C-Down> <Esc>:call AddEmptyLineBelow()<CR>a
endfunction
call SetArrowKeysAsTextShifters()

""""""""""""""""""""""""""""
" Python specific:

" Proper Indentation/formatting:

filetype plugin indent on
autocmd FileType python set complete+=k~/.vim/syntax/python.vim isk+=.,(

" Enable PyDiction's autocomplete capabilities

let g:pydiction_location = "~/.vim/complete-dict"

" Set breakpoint with F7, clear all with Shift+F7


" Author: Nick Anderson <nick at anders0n.net>
" Website: http://www.cmdln.org
" Adapted from sonteks post on Vim as Python IDE
" http://blog.sontek.net/2008/05/11/python-with-a-modular-ide-vim/

python << EOF
import vim
def SetBreakpoint():
    import re
    nLine = int( vim.eval( 'line(".")'))

    strLine = vim.current.line
    strWhite = re.search( '^(\s*)', strLine).group(1)

    vim.current.buffer.append(
"%(space)sfrom ipdb import set_trace;set_trace() %(mark)s Breakpoint %(mark)s" %
         {'space':strWhite, 'mark': '#' * 30}, nLine - 1)

vim.command( 'map <f10> :py SetBreakpoint()<cr>')

def RemoveBreakpoints():
    import re

    nCurrentLine = int( vim.eval( 'line(".")'))

    nLines = []
    nLine = 1
    for strLine in vim.current.buffer:
        if strLine.lstrip()[:38] == 'from ipdb import set_trace;set_trace()':
            nLines.append( nLine)
            print nLine
        nLine += 1

    nLines.reverse()

    for nLine in nLines:
        vim.command( 'normal %dG' % nLine)
        vim.command( 'normal dd')
        if nLine < nCurrentLine:
            nCurrentLine -= 1

    vim.command( 'normal %dG' % nCurrentLine)

vim.command( 'map <s-f10> :py RemoveBreakpoints()<cr>')
EOF
autocmd FileType python set omnifunc=pythoncomplete#Complete

" Suppress pyflakes' quickfix window
let g:pyflakes_use_quickfix = 0

" Easily use the pep8 plugin to validate code
let g:pep8_map='<leader>8'

" Supertab configuration
au FileType python set omnifunc=pythoncomplete#Complete
let g:SuperTabDefaultCompletionType = "context"
set completeopt=menuone,longest,preview