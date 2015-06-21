" no compatible vi keyboard
set nocp
" do not ignore case when search/replace
set ignorecase
" Tab related
set tabstop=2
set shiftwidth=2
set smarttab
set expandtab

set ambiwidth=double

set clipboard=unnamedplus

set noru
set nu

set nohls
set mouse=c
set laststatus=2
set statusline=%F\ %m%r%=%l,%c%V\ %p%%
set showmatch

" Format related
"set tw=78
set formatoptions+=mBr
set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,sjis,euc-jp,euc-kr,latin1d
set encoding=utf-8

" Indent related
set smartindent
set autoindent
au FileType desc setlocal noautoindent
au FileType desc setlocal nosmartindent
"set cino=:0g0t0(susj1

" Editing relate
set backspace=indent,eol,start
set whichwrap=b,s,<,>,[,]
set mouse=c
set mousemodel=popup
set selection=inclusive

" Misc
set wildmenu

color elflord

" File type related
filetype plugin indent on

syntax on

" set to cur dir
set bsdir=buffer
set autochdir

"tab switch
map <s-tab> :tabn<CR>:e %<cr>

"========================
"tab maximize
nmap <c-s> <c-w>_<c-w>\|
"=========================
nmap ( a()<esc>i
nmap [ a[]<esc>i
nmap { a{}<esc>i<cr><esc>O
" input brace map
"inoremap ( ()<esc>i
"inoremap [ []<esc>i
"inoremap { {}<esc>i

" folding
"-------------------------------------------------------------------------------------
set foldenable " turn on folding
set foldmethod=syntax " make folding indent sensitive
set foldlevel=100 " don't autofold anything (but I can still fold manually)
set foldopen -=search " don't open folds when you search into them
set foldopen -=undo " don't open folds when you undo stuff 
set foldopen -=quickfix 
map <f2> :e ./<cr>

let g:acp_enableAtStartup = 0 
let g:neocomplcache_enable_at_startup = 1 
let g:neocomplcache_enable_smart_case = 1 

" AutoComplPop like behavior. 
let g:neocomplcache_enable_auto_select = 1 

inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>" 
" inoremap <expr><CR>  neocomplcache#smart_close_popup() . "\<CR>" 
" inoremap <expr><CR>  pumvisible() ? "\<C-n>" : "\<CR>" 
inoremap <expr><CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
"

" JP translation related 
au BufRead,BufNewFile *.trans set filetype=trans
au FileType html setlocal cursorcolumn

vmap <s-p> "0p

set timeoutlen=100
