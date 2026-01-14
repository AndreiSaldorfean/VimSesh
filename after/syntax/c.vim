" Match first-level curly braces
syntax match CurlyBrace /[{}]/
syntax match Brace /[()]/
syntax match SquareBrace /[\[\]]/
syntax match NewOperator /\<new\s\+\w\+\(\s*[*]\+\)\?\(\s*\[\s*\d*\s*\]\)\?\(\s*(\_[^)]*)\)\?/
highlight CurlyBrace ctermfg=81 guifg=#1895e2
highlight Brace ctermfg=214 guifg=#da70d6
highlight SquareBrace ctermfg=170 guifg=#f8b417
highlight NewOperator ctermfg=214 guifg=#da70d6
