" This is a plugin to map shortkeys for trans files
" Author: Eskibear
"

" Shortkey to add brackets
vmap <C-y>/ s「」<esc>P
nmap <C-y>/ :s/@@ \(.*\)/@@ 「\1」<cr>

" Shortkey to combine translated sentences
vmap <C-y>c :s/\n## .\{-\}\n@@ //g<cr>

" Shortkey to seperate original paragraphs
let pattern=['「.\{-\}」', '（.\{-\}）', '.\{-\}[。]', '.\+\n\@=']
" let pattern=['「.\{-\}」', '.\{-\}[、。]']
let matched='\(I cannot be matched\)'
for p in pattern
    let matched = matched . '\\|\(' . p . '\)'
endfor
exe 'nmap <c-y>. VypO@@ <esc>jV:s/' . matched . '/## &\r@@ \r/g<cr>j'

" Eliminate delay for fcitx-plugin 
set ttm=100
