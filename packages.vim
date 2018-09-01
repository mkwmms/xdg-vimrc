function! s:gutentags_hook(hooktype, name)
	if executable('apt-get')
		call system('sudo apt-get install -y universal-ctags')
	elseif executable('brew')
		call system('brew install --HEAD universal-ctags')
		call system('echo 2 > /tmp/test.txt')
	endif
endfunction

function! s:lsp_hook(hooktype, name)
	let l:pip = 'pip3 install python-language-server[all]'
	let l:npm = 'npm i -g javascript-typescript-langserver'
	if executable('apt-get')
		let l:pip = 'sudo ' + l:pip
		let l:npm = 'sudo ' + l:npm
	endif
	call system(l:pip)
	call system(l:npm)
endfunction

packadd minpac
call minpac#init({'dir': stdpath('data') . '/site'})
call minpac#add( 'k-takata/minpac', {'type': 'opt'})

call minpac#add( 'joshdick/onedark.vim', {'type': 'opt'})
call minpac#add( 'vim-airline/vim-airline')
call minpac#add( 'airblade/vim-gitgutter')
call minpac#add( 'airblade/vim-rooter')
call minpac#add( 'editorconfig/editorconfig-vim')
call minpac#add( 'ervandew/supertab')
call minpac#add( 'jeffkreeftmeijer/vim-numbertoggle')
call minpac#add( 'junegunn/fzf')
call minpac#add( 'junegunn/fzf.vim')
call minpac#add( 'sheerun/vim-polyglot')
call minpac#add( 'tpope/vim-commentary')
call minpac#add( 'easymotion/vim-easymotion')
call minpac#add( 'tpope/vim-fugitive')
call minpac#add( 'tpope/vim-surround')
call minpac#add( 'simnalamburt/vim-mundo')
call minpac#add( 'tpope/vim-abolish')
call minpac#add( 'w0rp/ale', {'type': 'opt', 'do': function('s:lsp_hook')})
call minpac#add('ludovicchabant/vim-gutentags', {
			\ 'type': 'opt', 
			\ 'do': function('s:gutentags_hook')
			\})

