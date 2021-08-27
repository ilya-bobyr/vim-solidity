setlocal commentstring=//\ %s

" "///" and "/**" are NatSpec comments.
setlocal comments=s1:/**,mb:*,ex:*/,s1:/*,mb:*,ex:*/,:///,://

" Default 'formatoptions': qntcj
" As we have proper comments specified above, we add 'r' and 'o':
"
" r  Automatically insert the current comment leader after hitting <Enter>
"    in Insert mode.
"
" o  Automatically insert the current comment leader after hitting 'o' or
"    'O' in Normal mode.
setlocal formatoptions+=ro
