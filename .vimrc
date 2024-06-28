set guifont=Monospace\ Regular\ 15
syntax on
set number
set cursorline
"set termguicolors
" this command below fixes tmux issue 
set t_ut=
set t_Co=256
set expandtab
set tabstop=4
set shiftwidth=4
set autochdir
set nowrap
set incsearch
set scrolloff=8
"#:fixdel
"imap ^H <BS>
noremap! <C-?> <C-h>
set ignorecase
set smartcase
set bs=indent,eol,start 
set hlsearch
set hidden
"autocmd VimEnter * NERDTree | wincmd p 
"packadd! matchit
filetype plugin on
"runtime macros/matchit.vim
colorscheme Atelier_EstuaryDark

set clipboard=unnamedplus

function! DisplayColorSchemes()
   let currDir = getcwd()
   "exec cd $VIMRUNTIME/colors
   exec "cd /usr/intel/pkgs/vim/8.2.1001/share/vim/vimfiles/pack/UsrIntel/start/vim-colorschemes/colors"
   for myCol in split(glob("*"), '\n')
      if myCol =~ '\.vim'
         let mycol = substitute(myCol, '\.vim', '', '')
         exec "colorscheme " . mycol
         exec "redraw!"
         echo "colorscheme = ". myCol
         sleep 2
      endif
   endfor
   exec "cd " . currDir
endfunction

au BufNewFile,BufRead *.vh set ft=systemverilog
au BufNewFile,BufRead *.vs set ft=systemverilog
au BufNewFile,BufRead *.cjson set ft=jsonc
au BufNewFile,BufRead *.jsonc set ft=jsonc
au BufNewFile,BufRead *.pb set ft=perl
au BufNewFile,BufRead *.max set ft=perl
au BufNewFile,BufRead *.list set ft=test_list
imap jj <Esc>

packloadall

" silent! map <C-t> :NERDTreeToggle<CR>

set statusline+=%F
let g:nerdtree_tabs_open_on_gui_startup = 2
command GetFilePath echon expand('%:p') 


" define line highlight color
highlight LineHighlight ctermbg=darkgray guifg=#ba6236 guibg=#a5980d
" highlight the current line
nnoremap <silent> <Leader>l :call matchadd('LineHighlight', '\%'.line('.').'l')<CR>
" clear all the highlighted lines
nnoremap <silent> <Leader>c :call clearmatches()<CR>
let g:bufferline_echo=0
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#bufferline#enabled = 0

" Check if NERDTree is open or active
function! IsNERDTreeOpen()
  return exists("t:NERDTreeBufName") && (bufwinnr(t:NERDTreeBufName) != -1)
endfunction

function! ParseMe(filename)
    let cur_buf = a:filename
    let cur_line = line(".")
    echom "File to use "
    echom cur_buf
    execute 'vnew PARSED_'.cur_buf 
    noautocmd execute 'r!$WORKDISK/scripts/tools/bnl_debug_parser.py -o -i '. cur_buf
    noautocmd execute cur_line
    
endfunction
command ParseBNL :exec "call ParseMe(expand('%'))"

command ParseBNLI :exec "!$WORKDISK/scripts/tools/bnl_debug_parser.py -o -i %"


" Call NERDTreeFind iff NERDTree is active, current window contains a modifiable
" file, and we're not in vimdiff
function! SyncTree()
  if &modifiable && IsNERDTreeOpen() && strlen(expand('%')) > 0 && !&diff
    NERDTreeFind
    wincmd p
  endif
endfunction

command SetDebugMode :%s/$RTLMODELS\/dkt\/pbatomc\/pbatomc-ertl-dkt-head0-latest/\/nfs\/site\/disks\/userdisk000_itsmoak\/pbatomc-ertl-dkt-head0/g
command SetDebugModeARW :%s/$RTLMODELS\/arw\/pbatomc\/pbatomc-ertl-arw-head0-latest/\/nfs\/site\/disks\/userdisk000_itsmoak\/arw_pbatomc/g
command ResetDebugMode :%s/\/nfs\/site\/disks\/userdisk000_itsmoak\/pbatomc-ertl-dkt-head0/$RTLMODELS\/dkt\/pbatomc\/pbatomc-ertl-dkt-head0-latest/g
command ResetDebugModeARW :%s/\/nfs\/site\/disks\/userdisk000_itsmoak\/arw_pbatomc/$RTLMODELS\/arw\/pbatomc\/pbatomc-ertl-arw-head0-latest/g
command LocalDiff :w !diff % -

" Highlight currently open buffer in NERDTree
autocmd BufEnter * call SyncTree()
"autocmd BufEnter * :!
command TryMe :exec 'cd' fnameescape(fnamemodify(finddir('.git', escape(expand('%:p:h'), ' ') . ';'), ':h'))

function! ToggleNerdTree()
  set eventignore=BufEnter
  NERDTreeToggle
  set eventignore=
endfunction

function! MYCMD()
    :Gcd
    :Files
endfunction
nmap <C-n> :call ToggleNerdTree()<CR>
nmap <C-t> :call ToggleNerdTree()<CR>
nmap <C-f> :call MYCMD() <CR>
nmap <C-b> :Buffer <CR>
map  <C-q> :q! <CR>
