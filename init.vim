"
" speedcola (neo)vim configuration
" https://github.com/mwilliammyers/speedcola
"

set undofile

set smartcase
set wildmode=list:longest,full
set whichwrap=b,s,h,l,<,>,[,]
set wildignore+=.svn,.hg,.bzr,.git
set wildignore+=*/tmp/*,*/node_modules/*,.sass-cache,*.class,*.scssc,*/Godeps/*
set wildignore+=.final_builds/*,*.o,*.obj,*.exe,*.so,*.dll,*.pyc,*/target/*

set completeopt=menu,menuone,preview,noselect,noinsert

autocmd CompleteDone * silent! pclose
set shortmess+=c

" Trigger `autoread` when files changes on disk
" see: https://unix.stackexchange.com/a/383044
autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * if mode() != 'c' | checktime | endif

"
" mappings
"
let g:mapleader=','

if exists(':tnoremap')
  tnoremap <Esc> <C-\><C-n>

  map <Leader>vt :vsplit term://$SHELL <Return>
  map <Leader>xt :split term://$SHELL <Return>
endif

command! -bang -nargs=? -complete=file E e<bang> <args>
command! -bang -nargs=? -complete=file W w<bang> <args>
command! -bang -nargs=? -complete=file Wq wq<bang> <args>
command! -bang -nargs=? -complete=file WQ wq<bang> <args>
command! -bang WQA wqa<bang>
command! -bang WQa wqa<bang>
command! -bang Wqa wqa<bang>
command! -bang Wa wa<bang>
command! -bang WA wa<bang>
command! -bang Q q<bang>
command! -bang QA qa<bang>
command! -bang Qa qa<bang>
command! -bang XA xa<bang>
command! -bang Xa xa<bang>

nnoremap Y y$

" Visual mode search
" https://github.com/godlygeek/vim-files/blob/ecd434bc/plugin/vsearch.vim
function! s:VSetSearch()
  let temp = @@
  norm! gvy
  let @/ = '\V' . substitute(escape(@@, '\'), '\n', '\\n', 'g')
  " Use this line instead of the above to match matches spanning across lines
  "let @/ = '\V' . substitute(escape(@@, '\'), '\_s\+', '\\_s\\+', 'g')
  call histadd('/', substitute(@/, '[?/]', '\="\\%d".char2nr(submatch(0))', 'g'))
  let @@ = temp
endfunction

vnoremap * :<C-u>call <SID>VSetSearch()<CR>/<CR>
vnoremap # :<C-u>call <SID>VSetSearch()<CR>?<CR>

" Do not immediately jump to next search result
" https://stackoverflow.com/a/4257175
" TODO: make this behavior work with loupe: https://github.com/wincent/loupe/issues/12
" nnoremap * *#

"
" UI
"
packadd vim-one
if has('termguicolors') | set termguicolors | endif
set background=dark
let g:one_allow_italics = 1
colorscheme one

set hidden

set mouse=a

if has('unnamedplus') | set clipboard=unnamedplus | endif

set belloff+=ctrlg

set noshowmode
set number relativenumber
set splitright splitbelow
set colorcolumn=80,120
if exists('+signcolumn') | set signcolumn=yes | endif
set nowrap

set listchars=tab:▸-,space:·,trail:·

set foldmethod=syntax
set foldlevelstart=99

"
" browser & docs
"
function! OpenUrl(...)
  for uri in a:000
    " let uri = tolower(uri)
    if uri !~# '^https\=\:\/\/'
      let uri = 'https://' . uri
    endif

    call netrw#BrowseX(uri, netrw#CheckIfRemote())
  endfor
endfunction

command! -nargs=* Url call OpenUrl(<f-args>)

command! -nargs=* Google call OpenUrl('https://www.google.com/search?q=' . join([<f-args>], '+'))
map <expr> <Leader><Leader>g ':Google ' . expand('<cword>') . '<Return>'

command! -nargs=* Lucky call OpenUrl('https://www.google.com/search?q=' . join([<f-args>], '+') . '&btnI')
map <expr> <Leader><Leader>l ':Lucky ' . expand('<cword>') . '<Return>'

command! -nargs=* Stackoverflow call OpenUrl('https://stackoverflow.com/search?q=' . join([<f-args>], '+'))
map <expr> <Leader><Leader>s ':Stackoverflow ' . expand('<cword>') . '<Return>'

command! -nargs=* Github call OpenUrl('https://www.github.com/search?q=' . join([<f-args>], '+'))
map <expr> <Leader><Leader>h ':Github ' . expand('<cword>') . '<Return>'

command! -nargs=* Docs call OpenUrl('https://www.google.com/search?q=' . join([<f-args>, 'documentation'], '+') . '&btnI')

" command! -nargs=* Docs call OpenUrl(''. <q-args>)
command! -nargs=* Docsrust call OpenUrl('https://doc.rust-lang.org/std/index.html?search=' . <q-args>)
command! -nargs=* Docspython call OpenUrl('https://docs.python.org/3.6/search.html?q=' . <q-args>)
command! -nargs=* Docspytorch call OpenUrl('https://pytorch.org/docs/stable/search.html?q='. <q-args>)
command! -nargs=* Docstf call OpenUrl('https://www.tensorflow.org/s/results/?q='. <q-args>)
command! -nargs=* Docspostgresql call OpenUrl('https://www.postgresql.org/search/?q=' . <q-args>)
command! -nargs=* Docssql call OpenUrl('https://www.postgresql.org/search/?q=' . <q-args>)
command! -nargs=* Docsjavascript call OpenUrl('https://developer.mozilla.org/en-US/search?topic=api&topic=js&topic=webdev&topic=standards&topic=webext&q='. <q-args>)

augroup docs
  autocmd!
  autocmd FileType * map <expr> L ':Docs' . &filetype . ' ' . expand('<cword>') . '<Return>'
  autocmd FileType * map <expr> <Leader><Leader>l ':Docs' . &filetype . ' ' . expand('<cword>') . '<Return>'
augroup END


"
" package settings
"


" nnoremap <silent> <F5> :MundoToggle<Return>
nnoremap <silent> <Leader>u :MundoToggle<Return>


let g:airline_theme='one'

let g:sql_type_default = 'pgsql'

let g:mundo_close_on_revert = 1

"
" sneak
"
let g:sneak#label = 1
" because the sandwhich plugin uses `sa`
map f <Plug>Sneak_s
map F <Plug>Sneak_S

"
" fzf
"
" Run fzf when vim open iff no filepath was specified to vim via CLI
autocmd StdinReadPre * let s:reading_stdin=1
autocmd VimEnter * nested
      \  if argc() == 0 && !exists("s:reading_stdin")
      \|  call fzf#vim#files(getcwd())
      \| endif

if executable('rg')
  inoremap <silent> <expr> <c-x><c-l> fzf#vim#complete(fzf#wrap({
        \ 'prefix': '^.*$',
        \ 'source': 'rg -n ^ --color always',
        \ 'options': '--ansi --delimiter : --nth 3..',
        \ 'reducer': { lines -> join(split(lines[0], ':\zs')[2:], '') }}))

  nnoremap <silent> <Leader>f :Rg<Return>
end

nnoremap <silent> <C-t> :Files<Return>
nnoremap <silent> <Leader>t :Files<Return>
nnoremap <silent> <Leader>tg :GFiles<Return>
nnoremap <silent> <Leader>tg? :GFiles?<Return>
nnoremap <silent> <Leader><Enter> :Buffers<Return>
nnoremap <silent> <Leader>b :Buffers<Return>
" nnoremap <silent> <Leader> :Colors<Return>
nnoremap <silent> <Leader>l :Lines<Return>
nnoremap <silent> <Leader>ll :BLines<Return>
nnoremap <silent> <Leader>y :Tags<Return>
nnoremap <silent> <Leader>yy :BTags<Return>
nnoremap <silent> <Leader>` :Marks<Return>
nnoremap <silent> <Leader>w :Windows<Return>
nnoremap <silent> <Leader>o :Locate<Return>
nnoremap <silent> <Leader>q :History<Return>
nnoremap <silent> <Leader>q: :History:<Return>
nnoremap <silent> <Leader>q/ :History/<Return>
nnoremap <silent> <Leader>sn :Snippets<Return>
nnoremap <silent> <Leader>c :Commits<Return>
nnoremap <silent> <Leader>cc :BCommits<Return>
nnoremap <silent> <Leader>: :Commands<Return>
nnoremap <silent> <Leader>m :Maps<Return>
nnoremap <silent> <Leader>h :Helptags<Return>
nnoremap <silent> <Leader>tp :Filetypes<Return>

nmap <silent> <leader><tab> <plug>(fzf-maps-n)
xmap <silent> <leader><tab> <plug>(fzf-maps-x)
omap <silent> <leader><tab> <plug>(fzf-maps-o)

let g:fzf_colors = {
      \ 'fg':      ['fg', 'Normal'],
      \ 'bg':      ['bg', 'Normal'],
      \ 'hl':      ['fg', 'Comment'],
      \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
      \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
      \ 'hl+':     ['fg', 'Statement'],
      \ 'info':    ['fg', 'PreProc'],
      \ 'border':  ['fg', 'Ignore'],
      \ 'prompt':  ['fg', 'Conditional'],
      \ 'pointer': ['fg', 'Exception'],
      \ 'marker':  ['fg', 'Keyword'],
      \ 'spinner': ['fg', 'Label'],
      \ 'header':  ['fg', 'Comment']
      \}

"
" fugitive
"
nnoremap <silent> <leader>Gs :Gstatus<Return>
nnoremap <silent> <leader>Gd :Gdiff<Return>
nnoremap <silent> <leader>Gc :Gcommit<Return>
nnoremap <silent> <leader>Gb :Gblame<Return>
nnoremap <silent> <leader>Gl :Glog<Return>
nnoremap <silent> <leader>Gp :Git push<Return>
nnoremap <silent> <leader>Gr :Gread<Return>
nnoremap <silent> <leader>Gw :Gwrite<Return>
nnoremap <silent> <leader>Ge :Gedit<Return>
nnoremap <silent> <leader>Gi :Git add -p %<Return>

"
" lsc
"
let g:lsc_auto_map = v:true

nnoremap <silent> <Leader>ad :LSClientAllDiagnostics<Return>
nnoremap <silent> <Leader>d :LSClientLineDiagnostics<Return>

let g:lsc_server_commands  = {
      \ 'javascript' : {
      \   'command': 'javascript-typescript-stdio',
      \   'log_level': 'Error'
      \ },
      \ 'python': {
      \   'command': 'pyls',
      \   'log_level': 'Error'
      \  },
      \ 'rust': {
      \   'command': 'rls',
      \   'log_level': 'Error'
      \  },
      \}

highlight link lscDiagnosticError SpellBad
highlight link lscDiagnosticWarning SpellCap

"
" neoformat
"
let g:neoformat_basic_format_align = 1
" let g:neoformat_basic_format_retab = 1
let g:neoformat_basic_format_trim = 1

nnoremap <silent> <Leader>= :Neoformat<Return>
nnoremap <silent> ;; :Neoformat<Return>

let g:neoformat_toml_prettier = {
      \ 'exe': 'prettier',
      \ 'args': ['--stdin', '--stdin-filepath', '"%:p"'],
      \ 'stdin': 1,
      \}

let g:neoformat_enabled_toml = ['prettier']


function! s:ConfigureJavascript()
  let g:jsx_ext_required = 1

  "
  " jsdoc
  "
  let g:javascript_plugin_jsdoc = 1

  packadd vim-jsdoc

  nmap <silent> <C-l> <Plug>(jsdoc)

  let g:jsdoc_allow_input_prompt = 1
  let g:jsdoc_input_description	= 1
  let g:jsdoc_access_descriptions	= 2
  let g:jsdoc_enable_es6 = 1
  let g:jsdoc_tags = {
        \   'returns': 'return',
        \ }
endfunction

" TODO: move this to a ftplugin file
augroup js
  autocmd!
  autocmd FileType javascript call <SID>ConfigureJavascript()
augroup END
