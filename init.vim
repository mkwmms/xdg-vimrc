packadd onedark.vim
if has('termguicolors') | set termguicolors | endif
colorscheme onedark

set hidden

set mouse=a

set belloff+=ctrlg

set noshowmode
set number relativenumber
set splitright splitbelow
set colorcolumn=80,120
if exists('+signcolumn') | set signcolumn=yes | endif
set nowrap

set undofile

set listchars=tab:▸\ ,eol:\ ,trail:·

set shiftwidth=2
set softtabstop=2
set tabstop=2

autocmd BufRead,BufNewFile Dockerfile.* setfiletype dockerfile

augroup indentation
  autocmd!
  autocmd FileType dockerfile setlocal shiftwidth=2 softtabstop=2 expandtab
  autocmd FileType fish setlocal shiftwidth=4 softtabstop=4 expandtab
  autocmd FileType javascript setlocal shiftwidth=2 softtabstop=2 expandtab list
  autocmd FileType json setlocal shiftwidth=2 softtabstop=2 expandtab list
  autocmd FileType make setlocal noexpandtab list
  autocmd FileType markdown setlocal linebreak shiftwidth=4 tabstop=4 expandtab spell
  autocmd FileType python setlocal shiftwidth=4 softtabstop=4 expandtab
  autocmd FileType cfg setlocal shiftwidth=4 softtabstop=4 tabstop=4 noexpandtab commentstring=\;\ %s
  autocmd FileType sql setlocal commentstring=\--\ %s
  autocmd FileType vim setlocal shiftwidth=2 softtabstop=2 expandtab commentstring=\"\ %s
augroup END

set foldmethod=syntax
set foldlevelstart=99

set smartcase
set wildmode=list:longest,full
set whichwrap=b,s,h,l,<,>,[,]
set wildignore+=.svn,.hg,.bzr,.git
set wildignore+=*/tmp/*,*/node_modules/*,.sass-cache,*.class,*.scssc,*/Godeps/*
set wildignore+=.final_builds/*,*.o,*.obj,*.exe,*.so,*.dll,*.pyc,*/target/*

set completeopt=menu,menuone,preview,noselect,noinsert

autocmd CompleteDone * silent! pclose
set shortmess+=c

let g:mapleader=','

if exists(':tnoremap')
  tnoremap <Esc> <C-\><C-n>
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

" Make * and # work on visual mode too
" http://got-ravings.blogspot.com/2008/07/vim-pr0n-visual-search-mappings.html
function! s:VSetSearch(cmdtype)
  let temp = @s
  norm! gv"sy
  let @/ = '\V' . substitute(escape(@s, a:cmdtype.'\'), '\n', '\\n', 'g')
  let @s = temp
endfunction

xnoremap * :<C-u>call <SID>VSetSearch('/')<CR>/<C-R>=@/<CR><CR>
xnoremap # :<C-u>call <SID>VSetSearch('?')<CR>?<C-R>=@/<CR><CR>

" Trigger `autoread` when files changes on disk
" https://unix.stackexchange.com/a/383044
autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * if mode() != 'c' | checktime | endif

"
" package settings
"

let g:javascript_plugin_jsdoc = 1

nnoremap <silent> <F5> :MundoToggle<Return>
nnoremap <silent> <Leader>u :MundoToggle<Return>

let g:jsx_ext_required = 1

let g:airline_theme='onedark'

let g:sneak#label = 1

let g:sql_type_default = 'pgsql'

let g:mundo_close_on_revert = 1

"
" fzf
"
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
" ale
"
nmap <Leader>af <Plug>(ale_fix)
nmap <Leader>p <Plug>(ale_fix)

nmap <Leader>an <Plug>(ale_next_wrap)
nmap <C-j> <Plug>(ale_next_wrap)

nmap <Leader>ap <Plug>(ale_previous_wrap)
nmap <C-k> <Plug>(ale_previous_wrap)

nmap <Leader>ad <Plug>(ale_go_to_definition)
" TODO: fix this binding to work with docs navigation etc.
" https://github.com/w0rp/ale/issues/1236
" https://github.com/w0rp/ale/issues/1645
nmap <C-]> <Plug>(ale_go_to_definition)

nmap <Leader>ar <Plug>(ale_find_references)
nmap gr <Plug>(ale_find_references)

nmap <Leader>ah <Plug>(ale_hover)

" nmap <Leader>as :ALESymbolSearch<Return>
" nmap gS :ALESymbolSearch<Return>

let g:ale_use_global_executables = 1
let g:ale_completion_enabled = 1
let g:ale_set_balloons = 1
" let g:ale_sign_error = '✘'
" let g:ale_sign_warning = '⚠'
let g:airline#extensions#ale#enabled = 1

let g:ale_javascript_prettier_use_local_config = 1
let g:ale_python_black_options = '-l 80'
let g:ale_rust_rls_toolchain = 'beta'

let g:ale_fixers = {
    \   '*': ['remove_trailing_lines', 'trim_whitespace'],
    \   'graphql': ['eslint', 'prettier'],
    \   'javascript': ['eslint', 'prettier'],
    \   'json': ['prettier', 'jq'],
    \   'python': ['black', 'isort'],
    \   'rust': ['rustfmt'],
    \ }

let g:ale_linters = {
    \   'graphql': ['eslint', 'prettier'],
    \   'javascript': ['tsserver', 'eslint', 'prettier'],
    \   'json': ['prettier'],
    \   'python': ['pyls', 'vulture'],
    \   'rust': ['rls'],
    \ }

"
" devdocs.vim
"
nmap L <Plug>(devdocs-under-cursor)

let g:devdocs_filetype_map = {
    \   'ansible': 'ansible',
    \   'dockerfile': 'postgresql',
    \   'fish': 'fish',
    \   'javascript': 'javascript',
    \   'javascript.jsx': 'react',
    \   'javascript.test': 'jest',
    \   'markdown': 'markdown',
    \   'rust': 'rust',
    \   'sql': 'postgresql',
    \ }

command! -nargs=* DevDocsESlint call devdocs#open_doc(<q-args>, 'eslint')
command! -nargs=* DevDocsExpress call devdocs#open_doc(<q-args>, 'express')
command! -nargs=* DevDocsGit call devdocs#open_doc(<q-args>, 'git')
command! -nargs=* DevDocsJSdoc call devdocs#open_doc(<q-args>, 'jsdoc')
command! -nargs=* DevDocsLodash call devdocs#open_doc(<q-args>, 'lodash')
command! -nargs=* DevDocsMatplotlib call devdocs#open_doc(<q-args>, 'matplotlib')
command! -nargs=* DevDocsMoment call devdocs#open_doc(<q-args>, 'moment')
command! -nargs=* DevDocsNpm call devdocs#open_doc(<q-args>, 'npm')
command! -nargs=* DevDocsNumpy call devdocs#open_doc(<q-args>, 'numpy')
command! -nargs=* DevDocsReact call devdocs#open_doc(<q-args>, 'react')

"
" gutentags
"
" TODO: extract this and XDG logic in vimrc to a package
if empty($XDG_CACHE_HOME) | let $XDG_CACHE_HOME=expand('~/.cache') | endif
let g:gutentags_cache_dir = $XDG_CACHE_HOME . '/tags'

let g:gutentags_ctags_exclude = ['package*.json', '*config.json']

let g:gutentags_file_list_command = {
   \ 'markers': {
       \ '.git': 'git ls-files',
       \ '.hg': 'hg files',
       \ },
   \ }

"
" jsdoc
"
nmap <silent> <C-l> <Plug>(jsdoc)

let g:jsdoc_allow_input_prompt = 1
let g:jsdoc_input_description	= 1
let g:jsdoc_access_descriptions	= 1
let g:jsdoc_enable_es6 = 1
