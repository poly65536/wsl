" dein自体の自動インストール
"
let g:cache_home = empty($XDG_CACHE_HOME) ? expand('$HOME/.cache') : $XDG_CACHE_HOME
let g:config_home = empty($XDG_CONFIG_HOME) ? expand('$HOME/.config') : $XDG_CONFIG_HOME

" dein {{{
let s:dein_cache_dir = g:cache_home . '/dein'

" reset augroup
augroup MyAutoCmd
  autocmd!
augroup END

if &runtimepath !~# '/dein.vim'
  let s:dein_repo_dir = s:dein_cache_dir . '/repos/github.com/Shougo/dein.vim'

  " Auto Download
  if !isdirectory(s:dein_repo_dir)
    call system('git clone https://github.com/Shougo/dein.vim ' . shellescape(s:dein_repo_dir))
  endif

  " dein.vim をプラグインとして読み込む
  execute 'set runtimepath^=' . s:dein_repo_dir
endif

" dein.vim settings
let g:dein#install_max_processes = 16
let g:dein#install_progress_type = 'title'
let g:dein#install_message_type = 'none'
let g:dein#install_process_timeout = 600
let g:dein#enable_notification = 1

let s:toml_file = fnamemodify(expand('<sfile>'), ':h').'/dein.toml'
let s:lazy_toml_file = fnamemodify(expand('<sfile>'), ':h').'/dein_lazy.toml'
if dein#load_state(s:dein_cache_dir)
  call dein#begin(s:dein_cache_dir)

  " dein.toml のロード(ぼちぼち移行していこう)
  call dein#load_toml(s:lazy_toml_file, {'lazy': 1})
  call dein#load_toml(s:toml_file, {'lazy': 0})


  call dein#end()
  call dein#save_state()
endif

" 不足プラグインの自動インストール
if has('vim_starting') && dein#check_install()
  call dein#install()
  call dein#remote_plugins()
endif


" setting
"文字コードをUFT-8に設定
set fenc=utf-8
" バックアップファイルを作らない
set nobackup
" スワップファイルを作らない
set noswapfile
" 編集中のファイルが変更されたら自動で読み直す
set autoread
" バッファが編集中でもその他のファイルを開けるように
set hidden
" 入力中のコマンドをステータスに表示する
set showcmd

set undofile
set undodir=~/.vimfiles/undo

" 見た目系
" 行番号を表示
set number
set ruler
set cursorline
" 行末の1文字先までカーソルを移動できるように
set virtualedit=onemore
" ビープ音を可視化
set visualbell
" 括弧入力時の対応する括弧を表示
set showmatch
source $VIMRUNTIME/macros/matchit.vim
" ステータスラインを常に表示
set laststatus=2
set showcmd
" コマンドラインの補完
set wildmode=list:longest
" 折り返し時に表示行単位での移動できるようにする
nnoremap j gj
nnoremap k gk

" マウス有効化
set mouse=a


" Tab系
" 不可視文字を可視化(タブが「▸-」と表示される)
set list
set listchars=tab:>>,trail:-
" Tab文字を半角スペースにする
set expandtab
" 行頭以外のTab文字の表示幅（スペースいくつ分）
set tabstop=2
" 行頭でのTab文字の表示幅
set shiftwidth=2
" インデントはスマートインデント
set autoindent
set smartindent


" 検索系
" 検索文字列が小文字の場合は大文字小文字を区別なく検索する
set ignorecase
" 検索文字列に大文字が含まれている場合は区別して検索する
set smartcase
" 検索文字列入力時に順次対象文字列にヒットさせる
set incsearch
" 検索時に最後まで行ったら最初に戻る
set wrapscan
" 検索語をハイライト表示
set hlsearch
" command hokan
set wildmenu
set history=2000

" ESC連打でハイライト解除
nmap <Esc><Esc> :nohlsearch<CR><Esc>

" copy & paste with clipboard
nnoremap <silent> <Space>y :.w !win32yank.exe -i<CR><CR>
vnoremap <silent> <Space>y :w !win32yank.exe -i<CR><CR>
nnoremap <silent> <Space>p :r !win32yank.exe -o<CR>
vnoremap <silent> <Space>p :r !win32yank.exe -o<CR>

" colorscheme
syntax enable
set termguicolors
set background=dark
colorscheme molokai

" for plugins
nnoremap <silent><C-e> :NERDTreeToggle<CR>
" let g:lightline = {
"   \ 'colorscheme': 'molokai'
"   \}

let g:lightline = {
  \'colorscheme': 'molokai',
  \'active': {
  \  'left': [
  \    ['mode', 'paste'],
  \    ['readonly', 'modified', 'filename', 'ale'],
  \  ]
  \},
  \'component_function': {
  \  'ale': 'ALEGetStatusLine'
  \}
\ }

let g:ale_linters = {
\  'javascript': ['eslint'],
\  'haskell': ['hlint']
\}
let g:ale_fixers = {
\  'javascript': ['eslint'],
\  'haskell': ['hlint']
\}
let g:ale_statusline_format = ['ERROR:%d', 'WARNING:%d', 'OK']
let g:ale_echo_msg_error_str = 'ERROR'
let g:ale_echo_msg_warning_str = 'WORNING'
let g:ale_echo_msg_format = '[%linter%] %severity%:%s'
highlight ALEErrorSign ctermfg=231 ctermbg=161 guifg=#FFFFFF guibg=#F92672
highlight link ALEWarningSign Error
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)
