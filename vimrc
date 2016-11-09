" { NeoBundle
if has('vim_starting')
	set nocompatible
	set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

call neobundle#begin(expand('~/.vim/bundle'))

NeoBundleFetch 'Shougo/neobundle.vim'

" Bundles {
" Shoguo
NeoBundle 'Shougo/vimproc.vim', {
	\   'build' : {
	\     'windows' : 'tools\\update-dll-mingw',
	\     'cygwin' : 'make -f make_cygwin.mak',
	\     'mac' : 'make -f make_mac.mak',
	\     'linux' : 'make',
	\     'unix' : 'gmake',
	\   },
	\ }

NeoBundle 'Shougo/unite.vim', {
	\   'commands' : [
	\     {
	\       'name' : 'Unite',
	\       'complete' : 'customlist,unite#complete_source',
	\     },
	\   ],
	\ }

NeoBundle 'Shougo/vimfiler.vim', {
	\   'depends' : 'Shougo/unite.vim',
	\   'commands' : [
	\     {
	\       'name' : ['VimFiler', 'Edit', 'Write'],
	\       'complete' : 'customlist,vimfiler#complete',
	\     },
	\     'Read',
	\     'Source',
	\   ],
	\   'mappings' : '<Plug>',
	\   'explorer' : 1,
	\ }

" tpope
NeoBundle 'tpope/vim-sensible'
NeoBundle 'tpope/vim-sleuth'
NeoBundle 'tpope/vim-surround'
NeoBundle 'tpope/vim-unimpaired'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'tpope/vim-abolish'

" mhinz
NeoBundle 'mhinz/vim-signify'
NeoBundle 'mhinz/vim-startify'

" Solarized
NeoBundle 'altercation/vim-colors-solarized'

NeoBundle 'mbbill/undotree'
NeoBundle 'christoomey/vim-tmux-navigator'
NeoBundle 'bling/vim-airline'
NeoBundle 'hewes/unite-gtags'
" }

" Tapping {
if neobundle#tap('unite.vim')
	function! neobundle#hooks.on_source(bundle)
		call unite#custom#profile('default', 'context', {
			\   'direction': 'botright',
			\   'auto_resize': 1,
			\   'no_empty': 1,
			\ })
		call unite#filters#matcher_default#use(['matcher_fuzzy'])
		call unite#filters#sorter_default#use(['sorter_rank'])
	endfunction

	call neobundle#untap()
endif
" }

call neobundle#end()

filetype plugin indent on

NeoBundleCheck
" }

" Config {
set t_Co=16
set background=dark
colorscheme solarized

set nobackup
set directory=~/.vim/swap//
set swapfile
if has("persistent_undo")
	set undodir=~/.vim/undo//
	set undofile
endif

if filereadable('GTAGS')
	set csprg=gtags-cscope
	set cscopetag
	cs add GTAGS
endif

" Visual
set relativenumber
set number
set cursorline
set hlsearch

" Tags navigation
set notagstack
" }

" Unite {
let g:unite_source_grep_command = 'ag'
let g:unite_source_grep_default_opts = '-i --line-numbers --nocolor --nogroup'
let g:unite_source_grep_recursive_opt = ''

autocmd FileType unite call s:unite_settings()
function! s:unite_settings()
"	nmap <buffer> <Esc> <Plug>(unite_all_exit)
endfunction
" }

" Startify {
let g:startify_change_to_dir = 0
let g:startify_relative_path = 1

autocmd User Startified setlocal cursorline

let g:startify_list_order = [
	\ [' LRU within this dir:'],
	\ 'dir',
	\ [' Sessions:'],
	\ 'sessions',
	\ [' Bookmarks:'],
	\ 'bookmarks',
	\ ]
 let g:startify_skiplist = [
	\ 'COMMIT_EDITMSG',
	\ '.git/index',
	\ ]
" }

" Signify {
let g:signify_vcs_list = [ 'git' ]
" }

" Airline {
let g:airline_theme = 'solarized'
" }

" Mappings {
" use space as <Leader> without remapping
map <Space> \

nmap <Leader>h :set hlsearch!<CR>

" Unite
" Mapping:
"   [f]iles
"   [b]uffers
"   [t]ags
"   [s]earch
" Modifiers:
"   [f]ile - search in current file
" Pattern:
"   [s]tring - string from keyboard
"   [w]ord - word under cursor
"
nnoremap [unite] <Nop>
nmap <Leader> [unite]

map [unite]f   :Unite -start-insert file_rec/async<CR>
map [unite]b   :Unite buffer<CR>
map [unite]ss  :Unite -start-insert grep:.<CR>
map [unite]sw  :Unite grep:.::<C-r><C-w><CR>
map [unite]sfs :Unite -start-insert grep:%<CR>
map [unite]sfw :Unite grep:%::<C-r><C-w><CR>
map [unite]ts  :Unite -start-insert -default-action=list_definitions gtags/completion<CR>
map [unite]tw  :Unite gtags/context<CR>
map [unite]r   :UniteResume<CR>

" Undotree
nmap <Leader>u :UndotreeToggle<CR>
" }
