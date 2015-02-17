" Vim syntax file
" Language: Translation file

if exists("b:current_syntax")
    finish
endif

syn match tranlatedText /[^#<>]*/ contained
syn match ref /<#[^#<>]*#>/ contained
syn match originalText /^## .*/ 
syn match currentPos /@_@/

syn region translatedRegion start=/@@ / end="$" contains=ref,tranlatedText keepend
hi link tranlatedText Constant
hi link originalText Comment
hi link ref Comment
hi link currentPos Label
