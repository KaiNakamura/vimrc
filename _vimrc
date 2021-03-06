""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" TODO
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Autocomplete adds dummy placeholder variables
" Shift + Backspace inserts "�"
" Auto switch between hlsearch and nohlsearch
" Color column highlights even when nothing is in the 81st column
" Auto compete window creates miscolored spots
" Auto java import statements
" Highlight unused import statements
" Better tabs? Or better tab naming
" Color Scheme
" If text is typed between pair before coc-pairs updates, the text remains
" Comments don't carry on to extra lines

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if empty(glob('~/.vim/autoload/plug.vim'))
	silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
	\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
call plug#begin('~/.vim/plugged')
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'scrooloose/nerdcommenter'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'airblade/vim-gitgutter'
call plug#end()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Conquer of Completion
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" To edit coc-settings.json :CocConfig
" To edit snippets use :CocCommand snippets.editSnippets
let g:coc_global_extensions = [
	\ 'coc-snippets',
	\ 'coc-pairs',
	\ 'coc-json',
	\ 'coc-java',
	\ 'coc-tsserver',
	\ 'coc-python',
	\ ]

" TextEdit might fail if hidden is not set
set hidden

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience
set updatetime=100

" Don't pass messages to |ins-completion-menu|
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved
set signcolumn=yes

function! s:check_back_space() abort
	let col = col('.') - 1
	return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <TAB> to trigger completion
inoremap <silent><expr> <TAB> coc#refresh()

" Use <TAB> to confirm completion, `<C-g>u` means break undo chain at current
" position
" Coc only does snippet and additional edit on confirm
if has('patch8.1.1068')
	" Use `complete_info` if your (Neo)Vim version supports it.
	inoremap <expr> <TAB> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<TAB>"
else
	imap <expr> <TAB> pumvisible() ? "\<C-y>" : "\<C-g>u\<TAB>"
endif

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
	if (index(['vim','help'], &filetype) >= 0)
		execute 'h '.expand('<cword>')
	else
		call CocAction('doHover')
	endif
endfunction

" Highlight the symbol and its references when holding the cursor
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
	autocmd!
	" Setup formatexpr specified filetype(s).
	autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
	" Update signature help on jump placeholder.
	autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current line
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Introduce function text object
" NOTE: Requires 'textDocument.documentSymbol' support from the language server
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

" Use <TAB> for selections ranges
" NOTE: Requires 'textDocument/selectionRange' support from the language server
" coc-tsserver, coc-python are the examples of servers that support it
nmap <silent> <TAB> <Plug>(coc-range-select)
xmap <silent> <TAB> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings using CoCList:
" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<CR>
" Manage extensions
nnoremap <silent> <space>e  :<C-u>CocList extensions<CR>
" Show commands
nnoremap <silent> <space>c  :<C-u>CocList commands<CR>
" Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<CR>
" Search workspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<CR>
" Do default action for next item
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>

" Make enter trigger newline
" When coc-pairs completes, enter places cursor in between pairs
function! s:CRComplete()
	if pumvisible()
		execute "norm! i\<CR>"
	else
		inoremap <silent><expr> <CR> "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
	endif
endfunction
inoremap <CR> <LEFT><RIGHT><C-O>:call <SID>CRComplete()<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" NERDCommenter
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Toggle comments with CTRL-/
noremap <C-/> :call NERDComment(0, "toggle")<C-m>

" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1

" Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDDefaultAlign = 'left'

" Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDCommentEmptyLines = 1

" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1

" Enable NERDCommenterToggle to check all selected lines is commented or not 
let g:NERDToggleCheckAllLines = 1

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" File Exploration
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Hide .swp files
let g:netrw_list_hide = '.*\.swp$'
" Hide menu
let netrw_banner = 0

" Open vimrc
command V exec ":e $MYVIMRC"

" Change current working directory
command CD exec ":cd %:p:h"

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Copy and Paste
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Changes copy and paste to use the system clipboard
set clipboard=unnamedplus,unnamed

" Delete and pasting over text does not yank text
nnoremap d "_d
xnoremap d "_d
xnoremap p "_dP

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Windows and Tabs
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Makes new split screens appear below or to the right the current screen
set splitbelow
set splitright

" Quick way to move between windows
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" Quick way to resize windows
nnoremap <C-_> <C-w>-
nnoremap <C-=> <C-w>+
nnoremap <C-+> 100<C-w>+

" Quick way to switch tabs
nnoremap <M-n> :tabnew<Space>
nnoremap <M-l> :tabnext<CR>
nnoremap <M-h> :tabprev<CR>
nnoremap <M-k> :tabfirst<CR>
nnoremap <M-j> :tablast<CR>
nnoremap <M-c> :tabclose<CR>
nnoremap <M-q> :tabclose<CR>
nnoremap <M-m> :tabmove<Space>
nnoremap <M-1> 1gt
nnoremap <M-2> 2gt
nnoremap <M-3> 3gt
nnoremap <M-4> 4gt
nnoremap <M-5> 5gt
nnoremap <M-6> 6gt
nnoremap <M-7> 7gt
nnoremap <M-8> 8gt
nnoremap <M-9> 9gt
nnoremap <M-0> :tablast<CR>

" Quick way to move between windows in terminal
tnoremap <C-j> <C-w>j
tnoremap <C-k> <C-w>k
tnoremap <C-h> <C-w>h
tnoremap <C-l> <C-w>l

" Quick way to resize windows
tnoremap <C-_> <C-w>-
tnoremap <C-=> <C-w>+
tnoremap <C-+> <C-w>_

" Open terminal
command T call OpenTerminal()
func! OpenTerminal()
	exec ":terminal"
	exec "normal 5\<C-w>_"
endfunc

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Indentation
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set tabstop=4
set shiftwidth=4

set smartindent

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Appearance and Behavior
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Turn syntax highlighting on
filetype plugin on
syntax on
noh

" Highlight trailing whitespace
set listchars=tab:\ \ ,trail:�,nbsp:_
set list
autocmd VimEnter,WinEnter * match Error /\v^\t* +\t*[^\s]/

" Get rid of 'Hit ENTER to continue'
set shortmess+=a

" Show line numbers
set nu

" Highlight line overflow
autocmd VimEnter,WinEnter * call matchadd('ColorColumn', '\%81v', 100)

" Backspace deletes lines
set backspace=indent,eol,start

" Lets cursor go one space past the end of the line
set virtualedit=onemore

" Stops creation of backup files (.un~, .file~)
set noundofile
set nobackup
set nowritebackup

" Move cursor by display lines when line is wrapped
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk
nnoremap <Down> gj
nnoremap <Up> gk
vnoremap <Down> gj
vnoremap <Up> gk
inoremap <Down> <C-o>gj
inoremap <Up> <C-o>gk

" These create newlines like o and O but stay in normal mode
nnoremap zj o<Esc>k
nnoremap zk O<Esc>j

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Compilation
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <C-c> :call CompileAndRun()<CR>
func! CompileAndRun()
	exec "w"
	if &filetype == 'c'
		exec "!gcc % -o %:r && %:r"
	elseif &filetype == 'cpp'
		exec "!g++ % -o %:r && %:r"
	elseif &filetype == 'java'
		exec "silent !javac -d %:p:h\\..\\out %"
		exec "!java -cp %:p:h\\..\\out %:t:r"
	elseif &filetype == 'python'
		exec "!python %"
	endif
endfunc
