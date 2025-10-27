fu EnableAdvanced()
  " enable advanced / IDE type features

  " allow backspace to delete indents
  set backspace=indent,eol,start

  " enable syntax highlighting
  syntax on

  " highlight lines lines over 80 chars
  highlight ColorColumn ctermbg=magenta
  call matchadd('ColorColumn', '\%81v', -1)

  " auto indent styles
  autocmd FileType python set
    \ autoindent expandtab shiftwidth=4 softtabstop=4 tabstop=8
  autocmd Filetype sh set
    \ autoindent expandtab shiftwidth=2 softtabstop=2 tabstop=8
  autocmd Filetype vim set
    \ autoindent expandtab shiftwidth=2 softtabstop=2 tabstop=8

  " auto-lint python
  augroup python_flake8
    autocmd!
    autocmd FileType python setlocal makeprg=flake8\ %
    autocmd FileType python setlocal errorformat=%f:%l:%c:\ %m
    autocmd BufWritePost *.py silent make! | silent cwindow | redraw!
  augroup END

  " auto-lint shell
  augroup sh_shellcheck
    autocmd!
    autocmd FileType sh,bash setlocal
      \ makeprg=shellcheck\ -e\ SC1090,SC1091\ -f\ gcc\ %
    autocmd FileType sh,bash setlocal
      \ errorformat=%f:%l:%c:\ %trror:\ %m,%f:%l:%c:\ %t%*[^:]:\ %m
    autocmd FileType sh,bash autocmd
      \ BufWritePost <buffer> silent make! | silent cwindow | redraw!
  augroup END

  " init file type - this must come last
  if empty(&filetype)
    filetype detect
  endif
  silent! doautocmd <nomodeline> FileType
endf


" disable backup files (usually already disabled)
set nobackup

" increase the size of the command bar
set cmdheight=2

" enable the ruler (column/position numbers) in the command bar
set ruler

" disable compatibility (vi) mode
set nocompatible

" enable incremental search
set incsearch

" disable persistant highlightning
set nohlsearch

" disable creation of the viminfo file
set viminfo=

" ignore modelines
set nomodeline

" enable filetype detection
filetype on

" disable syntax highlighting
syntax off

" disable auto-indenting
set noautoindent

" disable use of bold fonts
set t_md=

" set the color scheme to something easy to read on dark terminals
set background=dark

" disable automatic comment continuation
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" command alias for EnableAdvanced, to enable advanced / IDE like features
" for the current session
:command BCEdit call EnableAdvanced()
