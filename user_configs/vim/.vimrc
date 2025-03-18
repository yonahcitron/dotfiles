set number
set relativenumber


" Remap key to enter Normal Mode.
inoremap jk <Esc>
inoremap kj <Esc>

" Swap `:` and `;` keys to make entering Command Mode easier.
"	Also swaps command to repeat the last 'f', 't', 'F' & 'T' command.
nnoremap ; :
nnoremap ; :

" Saner default to navigate windows with Ctrl + h/j/k/l
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Store yanked text to the + (clipboard) register by default
" Use the jasonccox/vim-wayland-clipboard plugin to automatically copy all text in the + register to the wl-clipboard.
:set clipboard=unnamedplus
