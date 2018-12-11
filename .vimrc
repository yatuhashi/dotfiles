"scriptencoding utf-8
set encoding=utf-8
set termguicolors
set number
set clipboard=unnamed
nmap <S-n><S-n> :set number<CR>
nmap <S-d><S-d> :set nonumber<CR>
noremap PP "0p"
nnoremap x "_x"
set t_Co=256
set noswapfile
set ruler
set hlsearch
set incsearch
set title
"set list
set whichwrap=[s,h,l,b,[,],<,>]
set backspace=indent,eol,start
inoremap jj <Esc>
"ESCを2回押すとハイライトを消す
nmap <silent> <Esc><Esc> :nohlsearch<CR>
syntax on

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                       Python Path                               "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! IncludePath(path)
      " define delimiter depends on platform
    if has('win16') || has('win32') || has('win64')
        let delimiter = ";"
    else
        let delimiter = ":"
    endif
        let pathlist = split($PATH, delimiter)
    if isdirectory(a:path) && index(pathlist, a:path) ==-1
        let $PATH=a:path.delimiter.$PATH
    endif
    IncludePath(expand("~/.pyenv/shims"))
endfunction
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                     Dein Vim Setting                            "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vimrc に以下のように追記
" プラグインが実際にインストールされるディレクトリ
let s:dein_dir = expand('~/.cache/dein')
" dein.vim 本体
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
" dein.vim がなければ github から落としてくる
if &runtimepath !~# '/dein.vim'
  if !isdirectory(s:dein_repo_dir)
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
  endif
  execute 'set runtimepath^=' . fnamemodify(s:dein_repo_dir, ':p')
endif

" 設定開始
if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)

  " プラグインリストを収めた TOML ファイル
  " 予め TOML ファイル（後述）を用意しておく
  let g:rc_dir    = expand('~/.vim/rc')
  let s:toml      = g:rc_dir . '/dein.toml'
  let s:lazy_toml = g:rc_dir . '/dein_lazy.toml'

  " TOML を読み込み、キャッシュしておく
  call dein#load_toml(s:toml,      {'lazy': 0})
  call dein#load_toml(s:lazy_toml, {'lazy': 1})

  " 設定終了
  call dein#end()
  call dein#save_state()
endif

" もし、未インストールものものがあったらインストール
if dein#check_install()
  call dein#install()
endif
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
colorscheme molokai
set cursorline
hi clear CursorLine
highlight LineNr ctermfg=35
highlight CursorLineNr   ctermfg=208
hi Comment ctermfg=31

filetype plugin indent on
nnoremap <silent> <C-t> :NERDTree<CR>
nnoremap <silent> <C-g> :QuickRun<CR>
nnoremap <silent> <C-m> :PrevimOpen<CR>
nnoremap <silent> <C-f> :Unite file buffer<CR>
nnoremap <silent> <C-y> :Unite history/yank<CR>
nnoremap <silent> <C-q> :%!jq '.'<CR>
nnoremap <c-h> <Left>
nnoremap <c-j> <Down>
nnoremap <c-k> <Up>
nnoremap <c-l> <Right>

nmap + :Switch<CR>
nmap - :Switch<CR>

let g:user_emmet_leader_key='<c-t>'
" 未インストールのプラグインがある場合、インストールするかどうかを尋ねてくれるようにする設定
" 毎回聞かれると邪魔な場合もあるので、この設定は任意です。

au BufRead,BufNewFile *.md set filetype=markdown
let g:previm_open_cmd = ''
" let g:quickrun_config={'_': {'split': 'vertical'}}
" let g:quickrun_config['markdown'] = {
"      \   'outputter': 'browser'
"      \ }
let g:quickrun_config = {
    \   "cpp/g++" : {
    \       "cmdopt" : "-std=c++0x",
    \       "hook/time/enable" : 1
    \   },
    \   "tex" : {
    \       'runner': 'vimproc',
    \       'runner/vimproc/updatetime' : 60,
    \       'command'  : 'platex',
    \       'exec' : ['%c %s','dvipdfmx %s:r.dvi','open %s:r.pdf']
    \   },
    \  "*":  {'split': '',
    \         "outputter/buffer/split" : ":botright 5sp",},
    \}

set splitbelow

let g:signify_vcs_list = [ 'git', 'hg' ]

"""""""""""""""""""""""""""""""""""""""""""""""""""
"コメントアウト \c
"""""""""""""""""""""""""""""""""""""""""""""""""""
nmap <Leader>c <Plug>(caw:i:toggle)
vmap <Leader>c <Plug>(caw:i:toggle)

"""""""""""""""""""""""""""""""""""""""""""""""""""
"全角スペースをアンダーラインハイライト
"""""""""""""""""""""""""""""""""""""""""""""""""""
function! ZenkakuSpace()
    highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=darkgray
endfunction

if has('syntax')
    augroup ZenkakuSpace
        autocmd!
        autocmd ColorScheme * call ZenkakuSpace()
        autocmd VimEnter,WinEnter,BufRead * let w:m1=matchadd('ZenkakuSpace', '　')
    augroup END
    call ZenkakuSpace()
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""
"C言語系のヘッダーファイルのパス指定
"
"""""""""""""""""""""""""""""""""""""""""""""""""""
setlocal path+=/usr/include/c++/4.8.2,/usr/include/

""""""""""""""""""""""""""""""
" 最後のカーソル位置を復元する
""""""""""""""""""""""""""""""
if has("autocmd")
    autocmd BufReadPost *
    \ if line("'\"") > 0 && line ("'\"") <= line("$") |
    \   exe "normal! g'\"" |
    \ endif
endif
""""""""""""""""""""""""""""""
