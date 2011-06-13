" titanium syntax
" Version: 0.0.1
" Author : pekepeke <pekepekesamurai@gmail.com>
" License: Creative Commons Attribution 2.1 Japan License
"          <http://creativecommons.org/licenses/by/2.1/jp/deed.en>

if !exists('b:current_syntax') || b:current_syntax =~ '-\?titanium'
  finish
endif

" XXX うまい具合にsyntax定義する方法がよくわからない。。。--;
" if exists('b:current_syntax')
  " let apply_syntax = b:current_syntax
" else
  " let ext = expand('%:t:e')
  " let apply_syntax = ext ==# 'js' ? 'javascript' :
        " \ (ext ==# 'py' ? 'python' :
        " \ (ext ==# 'rb' ? 'ruby' :
        " \ (ext ==# 'php' ? 'php' : '')))
  " unlet ext
  " if apply_syntax == ''
    " unlet apply_syntax
    " finish
  " endif
" endif
" if version < 600
  " syntax clear
" endif
" silent exe 'runtime! syntax/'.apply_syntax.'.vim'
" unlet apply_syntax

syn match titaniumKeyword '\s*\(Ti\|Titanium\)\.[a-zA-Z_\.]\+'
hi def link titaniumKeyword Define

if exists('b:current_syntax')
  let b:current_syntax = b:current_syntax . '-titanium'
else
  let b:current_syntax = 'titanium'
endif

" vim: ts=4
