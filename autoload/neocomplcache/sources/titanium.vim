" titanium neocomplcache plugin
" Version: 0.0.1
" Author : pekepeke <pekepekesamurai@gmail.com>
" License: Creative Commons Attribution 2.1 Japan License
"          <http://creativecommons.org/licenses/by/2.1/jp/deed.en>

" define source {{{1
let s:source = {
      \ 'name': 'titanium',
      \ 'kind' : 'ftplugin',
      \ 'filetypes': { 
      \    'ruby': 1,
      \    'javascript': 1 , 'coffee': 1,
      \    'php': 1, 'python': 1,
      \    'ruby.titanium': 1,
      \    'javascript.titanium': 1 , 'coffee.titanium': 1,
      \    'php.titanium': 1, 'python.titanium': 1,
      \   },
      \ }

function! s:source.initialize() " {{{2
endfunction

function! s:source.finalize() " {{{2
endfunction

function! s:source.get_keyword_pos(cur_text) " {{{2
  return match(a:cur_text[:getpos('.')[2]], 'Ti\S\+')
endfunction

function! s:source.get_complete_words(cur_keyword_pos, cur_keyword_str) " {{{2
  if !titanium#is_project()
    return []
  endif
  let words = titanium#complete#find(a:cur_keyword_str)
  let cur_keyword_str = a:cur_keyword_str
  return map(words, "{'word' : v:val, "
        \ . "'menu' : 'titanium['.titanium#complete#get_kind(v:val).']' "
        \ . "}")
endfunction

function! neocomplcache#sources#titanium#define() " {{{2
  return s:source
endfunction

