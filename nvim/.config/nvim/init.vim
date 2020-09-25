" Comments in Vimscript start with a `"`.

" Colourful colorscheme
colorscheme slate

nnoremap <space> <nop>
let mapleader = " "

" have Vim jump to the last position when reopening a file
" Except for gitcommit files where this feature is an annoyance
fun! JumpToLastPlace()
    " If filename is .git/COMMIT_EDITMSG
    " https://stackoverflow.com/questions/4525261/getting-relative-paths-in-vim#24463362
    if expand("%") =~ '.git/COMMIT_EDITMSG'
	return
    endif
    if line("'\"") > 1 && line("'\"") <= line("$")
	exe "normal! g'\""
    endif
endfun
autocmd BufReadPost * call JumpToLastPlace()

" files for any web dev should be two spaces
autocmd FileType yaml,markdown,javascript,css,html setlocal shiftwidth=2 softtabstop=2 expandtab

" shell scripts should be four spaces
autocmd FileType vim,sh,zsh,bash,fish setlocal shiftwidth=4 softtabstop=4

" Properly strip unneeded whitespace
fun! StripSpace()
    if &ft == ''
	return
    endif
    if expand('%') !~ "\.md$"
	augroup stripgroup
	    autocmd!
	    autocmd BufWrite * silent! :undojoin | :let l = winsaveview()
	    autocmd BufWrite * silent! :undojoin|silent! :%s/\s\+$//
	    autocmd BufWrite * silent! :undojoin|:call winrestview(l)
	augroup END
    else
	augroup stripgroup
	    autocmd!
	    autocmd BufWrite *.md silent! :undojoin|silent! :%s/\s\s\s\+$//|:undojoin|silent! :%s/\(\S\)\s$/\1/
	augroup END
    endif
endfun
autocmd BufEnter * call StripSpace()

" Using the Built-in spell checker
" This function blacklists files that I don't want spell checking on
fun! SpellCheck()
	let l:ext = expand("%:e")
	" I programmed in these languages at one point ... don't judge!
	" Spell check in them is very annoying
	if l:ext =~ '.*rpgle$' || l:ext =~ 'clle' || l:ext =~ '.*pf$' || l:ext =~ 'lf' || &ft == 'help' || &ft == 'man' || &ft == 'gitrebase'
		return
	else
		setlocal spell spelllang=en_ca
	endif
endfun
autocmd VimEnter,BufReadPost * call SpellCheck()

" vim-plug as the plug-in manager https://github.com/junegunn/vim-plug

" Install vim-plug if not installed already...
" Taken from Luke Smith's config
" https://github.com/LukeSmithxyz/voidrice/blob/master/.config/nvim/init.vim
if ! filereadable(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim"'))
    echo "Downloading junegunn/vim-plug to manage plugins..."
    silent !mkdir -p ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/
    silent !curl "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" > ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim
    autocmd VimEnter * PlugInstall
endif

" List of plugins
call plug#begin(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/plugged"'))

" https://github.com/vim-airline/vim-airline
" pretty status bar
Plug 'vim-airline/vim-airline'

" https://github.com/danro/rename.vim
" Adds the :Rename comand allowing me to rename files
Plug 'danro/rename.vim'

" https://github.com/suan/vim-instant-markdown
" Opens a local web server on port 8090 which parses markdown files
" Viewable on the browser
" requires: instant-markdown-d
" sudo npm -g install instant-markdown-d
Plug 'suan/vim-instant-markdown', {'for': 'markdown'}

" simple commenting plugin
" https://github.com/tpope/vim-commentary
Plug 'tpope/vim-commentary'

" Manipulate surrounding characters with ease
" https://github.com/tpope/vim-surround
Plug 'tpope/vim-surround'

" . command for plugins
" https://github.com/tpope/vim-repeat
Plug 'tpope/vim-repeat'

call plug#end()

" vim-airline

" let the fancy-ness continue in the status bar
let g:airline#extensions#tabline#enabled = 1

" vim-instant-markdown

" Only update when:
" No keys have been pressed for a while
" A while after you leave insert mode
" You save the file being edited
let g:instant_markdown_slow = 1

" Turn off autostart. Autostart automatically opens your browser and switchs
" focus to it which does not make much sense and is annoying. Thus, it makes
" more sense to do t manually
" Use :InstantMarkdownPreview to start the server and
" :InstantMarkdownStop to stop it
let g:instant_markdown_autostart = 0

" Autoscrolling confuses me, as the screen will appear to random places
let g:instant_markdown_autoscroll = 0

" Helper to assist inserting breaks in markdown
" The a option to format options has strange behaviour with breaks in markdown
" This code should help rectify the issue
augroup mdformat
    autocmd!
    autocmd BufEnter,BufReadPost,BufWritePre,VimLeavePre *.md silent! :undojoin | :let l = winsaveview()
    autocmd BufEnter,BufWritePost *.md silent! undojoin | silent! :keepjumps %s/  $/ <br>/g
    autocmd BufWritePre,VimLeavePre *.md silent! undojoin | silent! :keepjumps %s/ <br>$/  /g
    autocmd BufWritePre *.md silent! undojoin | silent! :keepjumps %s/<br> \?\(.\+\)/\1/g
    autocmd BufEnter,BufReadPost,BufWritePost,VimLeavePre *.md call winrestview(l)
    autocmd Filetype markdown iabbrev <buffer> $ <br>
augroup END

" If you open this file in Vim, it'll be syntax highlighted for you.

" Vim is based on Vi. Setting `nocompatible` switches from the default
" Vi-compatibility mode and enables useful Vim functionality. This
" configuration option turns out not to be necessary for the file named
" '~/.vimrc', because Vim automatically enters nocompatible mode if that file
" is present. But we're including it here just in case this config file is
" loaded some other way (e.g. saved as `foo`, and then Vim started with
" `vim -u foo`).
set nocompatible

" Turn on syntax highlighting.
syntax on

" Disable the default Vim startup message.
set shortmess+=I

" Show line numbers.
set number

" This enables relative line numbering mode. With both number and
" relativenumber enabled, the current line shows the true line number, while
" all other lines (above and below) are numbered relative to the current line.
" This is useful because you can tell, at a glance, what count is needed to
" jump up or down to a particular line, by {count}k to go up or {count}j to go
" down.
set relativenumber

" Always show the status line at the bottom, even if you only have one window open.
set laststatus=2

" The backspace key has slightly unintuitive behavior by default. For example,
" by default, you can't backspace before the insertion point set with 'i'.
" This configuration makes backspace behave more reasonably, in that you can
" backspace over anything.
set backspace=indent,eol,start

" By default, Vim doesn't let you hide a buffer (i.e. have a buffer that isn't
" shown in any window) that has unsaved changes. This is to prevent you from "
" forgetting about unsaved changes and then quitting e.g. via `:qa!`. We find
" hidden buffers helpful enough to disable this protection. See `:help hidden`
" for more information on this.
set hidden

" This setting makes search case-insensitive when all characters in the string
" being searched are lowercase. However, the search becomes case-sensitive if
" it contains any capital letters. This makes searching more convenient.
set ignorecase
set smartcase

set ai " auto indent
set scrolloff=3 " keep 3 lines when scrolling
set ruler

" Enable searching as you type, rather than waiting till you press enter.
set incsearch

" Splits open at the bottom and on the right
" taken from Luke Smith's config:
" https://github.com/LukeSmithxyz/voidrice/blob/master/.config/nvim/init.vim
set splitbelow splitright

" Unbind some useless/annoying default key bindings.
nmap Q <Nop> " 'Q' in normal mode enters Ex mode. You almost never want this.

" Disable audible bell because it's annoying.
set noerrorbells visualbell t_vb=

" Use ctrl-[hjkl] to select the active split!
" Taken from:
" https://stackoverflow.com/questions/6053301/easier-way-to-navigate-between-vim-split-panes#6053341
nnoremap <silent> <c-k> :wincmd k<CR>
nnoremap <silent> <c-j> :wincmd j<CR>
nnoremap <silent> <c-h> :wincmd h<CR>
nnoremap <silent> <c-l> :wincmd l<CR>

filetype on
filetype indent on

" Create the tags file
command! MakeTags !ctags -R .

" Flip case of a word
inoremap <c-u> <esc>bviwUea

" ^ and g_ are inconvenient to type
nnoremap H ^
nnoremap L g_
vnoremap H ^
vnoremap L g_

" _ and + to move lines up and down
nnoremap _ "+ddp
nnoremap + "+ddkP

" Indent with Ctrl + H and Ctrl + L
inoremap <c-h> <c-d>
inoremap <c-l> <c-t>

" edit vimrc
nnoremap <leader>ev :split $MYVIMRC<cr>:nnoremap <buffer> ZZ ZZ :source $MYVIMRC <cr>
" source vimrc
nnoremap <leader>sv :source $MYVIMRC<cr>
" easily type name and email
iabbrev @@ defrann8208@outlook.com
iabbrev myname Nicholas Defranco
