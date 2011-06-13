" titanium complete
" Version: 0.0.1
" Author : pekepeke <pekepekesamurai@gmail.com>
" License: Creative Commons Attribution 2.1 Japan License
"          <http://creativecommons.org/licenses/by/2.1/jp/deed.en>

if !exists('g:titanium_complete_head') " {{{2
  let g:titanium_complete_head = 0
endif

if !exists('g:titanium_complete_short_style') " {{{2
  let g:titanium_complete_short_style = 1
endif

if !exists('g:titanium_method_complete_disabled') " {{{2
  let g:titanium_method_complete_disabled = 1
endif

function! titanium#titaniumcomplete#enable_omnifunc() " {{{2
  " XXX (--;;;
  if &omnifunc !~ 'titanium#titaniumcomplete#Complete'
    let b:original_omnifunc=&omnifunc
  endif
  setl omnifunc=titanium#titaniumcomplete#Complete
endfunction

function! titanium#titaniumcomplete#Complete(findstart, base) " {{{2
  if a:findstart
    " XXX --;;
    if b:original_omnifunc != ''
      return call(function(b:original_omnifunc), [a:findstart, a:base])
    else
      let cur_word = strpart(getline('.'), 0, col('.') - 1)
      return match(cur_word, '\w*$')
    endif
  endif
  let l:matches = s:complete_titanium(a:base)
  if empty(l:matches)
    if b:original_omnifunc != ''
      return extend(
            \ call(function(b:original_omnifunc), [a:findstart, a:base]),
            \ s:convert_matches(s:complete_titanium_methods(a:base)))
    else
      return s:convert_matches(s:complete_titanium_methods(a:base))
    endif
  endif
  return s:convert_matches(l:matches)
endfunction

function! s:complete_titanium_methods(base) " {{{2
  if g:titanium_method_complete_disabled
    return []
  endif
  let l:words = titanium#complete#words()
  return titanium#complete#to_words(titanium#complete#find(l:words))
endfunction

function! s:convert_matches(matches) " {{{2
  return map(a:matches, '{ "word" : v:val, "kind" : titanium#complete#get_kind(v:val)}')
endfunction

function! s:complete_titanium(base) " {{{2
  let l:kwd = s:get_keyword_prefix().a:base
  if l:kwd == ""
    return []
  endif
  " read keywords
  let l:keyword = substitute(l:kwd, "^Ti\\.", "Titanium.", "es")
  let l:keyword = substitute(l:keyword, "\\\.", "\\.", "eg")

  " no namespace -> api full expand
  if stridx(l:keyword, ".") == -1 && g:titanium_complete_head == 0
    let l:list = titanium#complete#words()
    let l:matches = filter(l:list, 'v:val =~ "'.l:keyword.'"')
    if g:titanium_complete_short_style
      return map(l:matches, 'substitute(v:val, "^Titanium\\.", "Ti.", "e")')
    endif
    return l:matches
  endif

  return titanium#complete#to_words(
        \ titanium#complete#find(l:keyword))
endfunction

function! s:get_keyword_prefix() " {{{2
  let l:line = getline(".")
  if l:line == ""
    return ""
  endif

  let l:cur_pos = col(".") + 1
  let l:line = matchstr(strpart(line, 0, l:cur_pos), '[0-9a-zA-Z_\.]\+$')
  return strpart(l:line, 0, strridx(l:line, '.')+1)
  " let l:pos = strridx(l:line, " ", l:cur_pos)
  " let l:kwd = strpart(l:line, (l:pos == -1 ? 0 : l:pos+1), l:cur_pos - (l:pos+1))
  " return l:kwd
endfunction



