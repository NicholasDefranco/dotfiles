" Comments in Vimscript start with a `"`.

" Colourful colorscheme
colorscheme slate

nnoremap <space> <nop>
let mapleader = " "

" have Vim jump to the last position when reopening a file
" Except for gitcommit files where this feature is an annoyance
fun! JumpToLastPlace()
    " https://stackoverflow.com/questions/4525261/getting-relative-paths-in-vim#24463362
    if expand("%") =~ '.git/COMMIT_EDITMSG' || expand('%') =~ '.git/MERGE_MSG' || expand('%') =~ '.git/rebase-merge/git-rebase-todo'
	return
    endif
    if line("'\"") > 1 && line("'\"") <= line("$")
	exe "normal! g'\""
    endif
endfun
autocmd BufReadPost * call JumpToLastPlace()

" Search down into subfolders
" Provides tab-completion for all file-related tasks
set path+=**

" files for any web dev should be two spaces
autocmd FileType php,json,yaml,markdown,javascript,css,html setlocal shiftwidth=2 softtabstop=2 expandtab

" shell scripts should be four spaces
autocmd FileType vim,sh,zsh,bash,fish setlocal shiftwidth=4 softtabstop=4
augroup decor
    " Vertical Splits
    autocmd ColorScheme * highlight VertSplit cterm=NONE ctermfg=red ctermbg=NONE
    " Sign Column - where neomake symbols show
    autocmd ColorScheme * highlight signcolumn cterm=NONE ctermfg=grey ctermbg=NONE
    " Fold colours
    autocmd ColorScheme * highlight Folded ctermfg=Black ctermbg=blue
    autocmd ColorScheme * highlight FoldColumn cterm=NONE ctermbg=NONE
    " UI modifications
    autocmd ColorScheme * highlight statusline cterm=NONE ctermfg=red ctermbg=NONE
    autocmd ColorScheme * highlight statuslineterm cterm=NONE ctermfg=red ctermbg=NONE
    autocmd ColorScheme * highlight statuslinetermnc cterm=NONE ctermfg=red ctermbg=NONE
    autocmd ColorScheme * highlight statuslinenc cterm=NONE ctermfg=darkgrey ctermbg=NONE
    autocmd ColorScheme * highlight tabline cterm=NONE ctermfg=darkgrey ctermbg=NONE
    autocmd ColorScheme * highlight tablinefill cterm=NONE ctermfg=red ctermbg=NONE
    " Spelling
    autocmd ColorScheme * highlight SpellBad term=bold cterm=underline ctermbg=NONE ctermfg=NONE
    autocmd ColorScheme * highlight SpellCap term=bold cterm=underline ctermbg=NONE ctermfg=NONE
    autocmd ColorScheme * highlight SpellRare term=bold cterm=underline ctermbg=NONE ctermfg=NONE
    autocmd ColorScheme * highlight SpellLocal term=bold cterm=underline ctermbg=NONE ctermfg=NONE
augroup END

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
	let l:fname = expand('%:t')
	" I programmed in these languages at one point ... don't judge!
	" Spell check in them is very annoying
	if l:ext =~ '.*rpgle$' || l:ext =~ 'clle' || l:ext =~ '.*pf$' || l:ext =~ 'lf' || &ft == 'help' || &ft == 'man' || &ft == 'gitrebase' || l:fname == '.gitconfig' || l:fname == 'git-rebase-todo' || l:fname == '.gitattributes' || &ft == '' || l:fname == 'addp-hunk-edit.diff' || &ft == 'twiggy' || &ft == 'tmux'
		return
	else
		setlocal spell spelllang=en_ca
	endif
endfun
autocmd VimEnter,BufEnter * call SpellCheck()

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

" Better abbreviations, substitution, and coercion
" https://github.com/tpope/vim-abolish
Plug 'tpope/vim-abolish'

" runs linters
" https://github.com/neomake/neomake
Plug 'neomake/neomake'


" Git in vim
" https://github.com/tpope/vim-fugitive
Plug 'tpope/vim-fugitive'

" Software caps lock
" https://github.com/tpope/vim-capslock
Plug 'tpope/vim-capslock'

" Fugitive extension
" Branch managment
" https://github.com/sodapopcan/vim-twiggy
Plug 'sodapopcan/vim-twiggy'

" liquid syntax
" https://github.com/tpope/vim-liquid
Plug 'tpope/vim-liquid'

" Preview colours in css
" https://github.com/ap/vim-css-color
Plug 'ap/vim-css-color'

" Shell commands enhancement
" https://github.com/tpope/vim-eunuch
Plug 'tpope/vim-eunuch'

call plug#end()



" vim-instant-markdown

" Only update when:
" No keys have been pressed for a while
" A while after you leave insert mode
" You save the file being edited
let g:instant_markdown_slow = 1

" Turn off autostart. Autostart automatically opens your browser and switches
" focus to it which does not make much sense and is annoying. Thus, it makes
" more sense to do it manually
" Use :InstantMarkdownPreview to start the server and
" :InstantMarkdownStop to stop it
let g:instant_markdown_autostart = 0

" Autoscrolling confuses me, as the screen will appear to random places
let g:instant_markdown_autoscroll = 0

" vim-abolish
" Note, this must be executed AFTER the vimrc (or init.vim) has been sourced
fun! Abbrevs()
    silent! Abolish {despa,sepe}rat{e,es,ed,ing,ely,ion,ions,or} {despe,sepa}rat{}
    silent! Abolish {reutr,retru}n{,ing,ed} {retur,retur}n{}
    silent! Abolish gray grey
    silent! Abolish acommodati{ng,ons} accommodati{}
endfun
autocmd VimEnter * call Abbrevs()

" neomake
" Notes for this plugin:
" Yamllint - sudo apt install yamllint
" eslint - sudo apt install eslint
" vint - pip3 install vim-vint
" sqllint - sudo gem install sqllint
" shellcheck - sudo apt install shellcheck
" markdown linter - sudo npm install -g markdownlint-cli
" Prose lint - pip3 install proselint
" write good - sudo npm install -g write-good
" json linter - sudo npm install jsonlint -g
" cpp check - sudo apt install cppcheck
" css linter - sudo npm install -g csslint
" PHP_CodeSniffer - composer global require "squizlabs/php_codesniffer=*"
" python linter - sudo apt install pylinud
" html linter - install @linthtml/linthtml --save-dev
"	      - npx linthtml --init

" Full config: when writing or reading a buffer, and on changes in insert and
" normal mode (after 500ms; no delay when writing).
call neomake#configure#automake('nrwi', 500)

augroup my_neomake_signs
	au!
	autocmd ColorScheme *
				\ hi NeomakeErrorSign ctermfg=red |
				\ hi NeomakeWarningSign ctermfg=yellow |
				\ hi NeomakeInfoSign ctermfg=blue |
				\ hi NeomakeMessageSign ctermfg=blue
augroup END

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
augroup my_neomake_highlights
        au!
        autocmd ColorScheme *
          \ highlight NeomakeError cterm=underline ctermfg=red |
          \ highlight NeomakeWarning cterm=underline ctermfg=yellow |
	  \ highlight NeoMakeInfo cterm=underline ctermfg=blue |
	  \ highlight NeoMakeMessage cterm=underline ctermfg=blue
augroup END

" Other Markdown stuff
exec "source ~/.config/nvim/markdown-vim.vim"






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

" fancy auto format options that are extremely helpful
set formatoptions+=2tqncrojpw
fun! Format()
    if !(&filetype =~# 'vim' || &filetype =~# 'sh' || &filetype =~# 'python')
	setlocal formatoptions+=a
    endif
endfun
augroup formatting
    autocmd BufEnter * call Format()
augroup END

" Show line numbers.
set number

" width of numbers
set numberwidth=3

" This enables relative line numbering mode. With both number and
" relativenumber enabled, the current line shows the true line number, while
" all other lines (above and below) are numbered relative to the current line.
" This is useful because you can tell, at a glance, what count is needed to
" jump up or down to a particular line, by {count}k to go up or {count}j to go
" down.
set relativenumber

" No status line
set laststatus=0

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

filetype on
filetype indent on
" Enable CSS completion
" https://medium.com/vim-drops/css-autocompletion-on-vim-no-plugins-needed-e8df9ce079c7
set omnifunc=syntaxcomplete#Complete

" Disable audible bell because it's annoying.
set noerrorbells visualbell t_vb=

" Use ctrl-[hjkl] to select the active split!
" Taken from:
" https://stackoverflow.com/questions/6053301/easier-way-to-navigate-between-vim-split-panes#6053341
nnoremap <silent> <c-k> :wincmd k<CR>
nnoremap <silent> <c-j> :wincmd j<CR>
nnoremap <silent> <c-h> :wincmd h<CR>
nnoremap <silent> <c-l> :wincmd l<CR>

" Indent a whole file
nnoremap <leader>i gg=G<c-o>

" Toggle spelling
nnoremap <leader>p :setlocal spell!<cr>

" Resize split
" https://stackoverflow.com/questions/4368690/how-to-increase-the-vertical-split-window-size-in-vim
nnoremap <C-left> <c-w><
nnoremap <c-right> <c-w>>
nnoremap <c-up> <c-w>+
nnoremap <c-down> <c-w>-

" Create the tags file
command! MakeTags !ctags -R .

" ^ and g_ are inconvenient to type
nnoremap H ^
nnoremap L g_
vnoremap H ^
vnoremap L g_

" gt and gT are also inconvenient
nnoremap J gT
nnoremap K gt

" To avoid shadowing of J and K
nnoremap M K
nnoremap <c-n> J

nnoremap <c-s> i<cr><esc>k$

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

" Get Project Specific .vimrc in the root directory of the git repository
fun! GitProject()
    " https://stackoverflow.com/questions/5794611/how-to-expand-a-symbolic-link-to-the-full-path-of-a-filename-in-vim#5794800
    let l:projectvimrc = system('cd ' . fnamemodify(resolve(expand("%")), ':p:h') . ' && git rev-parse --show-toplevel | tr -d "\n"') . '/.vimrc'

    " v:shell_error is vim's equivalent of $? in shell scripts
    " https://stackoverflow.com/questions/9828148/how-to-get-return-status-value-of-an-external-command-in-vim#9828589
    if v:shell_error == 0
	" Edit project specific vimrc
	" I can't figure out how to map this binding to open the file
	" stored in l:projectvimrc:
	nnoremap <buffer> <leader>ep :split

	" https://stackoverflow.com/questions/840900/vim-sourcing-based-on-a-string#841025
	silent! execute "source " . l:projectvimrc
    endif
endfun
autocmd BufNew * call GitProject()
call GitProject()
