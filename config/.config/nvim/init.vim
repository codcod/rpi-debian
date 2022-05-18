" minimal neovim config

set tabstop=4

" remember position of last edit and return on reopen
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" highliht trailing whitespace
highlight ExtraWS ctermbg=red
match ExtraWS /\s\+$/

" display proper colors under tmux
if $TERM ==# "screen-256color"
    set background=light
endif

