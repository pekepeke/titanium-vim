" titanium complete functions
" Version: 0.0.1
" Author : pekepeke <pekepekesamurai@gmail.com>
" License: Creative Commons Attribution 2.1 Japan License
"          <http://creativecommons.org/licenses/by/2.1/jp/deed.en>

function! titanium#complete#words() " {{{2
  let l:path = titanium#get_keywordfile_path()
  if !filereadable(l:path)
    return []
  endif
  return readfile(l:path)
endfunction

function! s:replace(kwd, src, to)
  if type([]) == type(a:kwd)
    return map(a:kwd, 'substitute(v:val, "^'.a:src.'\\.", "'.a:to.'.", "e")')
  else
    return substitute(a:kwd, '^'.a:src.'\.', a:to.'.', 'e')
  endif
endfunction
function! s:to_short(kwd) " {{{2
  return s:replace(a:kwd, 'Titanium', 'Ti')
endfunction

function! s:to_long(kwd) " {{{2
  return s:replace(a:kwd, 'Ti', 'Titanium')
endfunction

function! s:is_shortname(kwd) " {{{2
  return a:kwd =~ '^Ti\.'
endfunction

function! titanium#complete#methods(base) " {{{2
  let l:words = titanium#complete#words()
  let l:is_short = s:is_shortname(a:base)
  let l:kwd = l:is_short ? s:to_long(a:base) : a:base
  let l:words = filter(l:words, 'v:val =~ "^'.l:kwd.'[^\\.]*(\\?$"')
  if l:is_short
    let l:words = s:to_short(l:words)
  endif
  return l:words
endfunction

function! titanium#complete#find(base) " {{{2
  let l:words = titanium#complete#words()
  let l:is_short = s:is_shortname(a:base)
  let l:kwd = l:is_short ? s:to_long(a:base) : a:base
  let l:words = filter(l:words, 'v:val =~ "^'.l:kwd.'[^\\.]*(\\?$"')
  if l:is_short
    let l:words = s:to_short(l:words)
  endif
  return l:words
endfunction

function! titanium#complete#to_words(words) " {{{2
  return map(a:words, 'substitute(v:val, "^.*\\.\\([^\\.]\\+\\)$", "\\1", "")')
endfunction

function! titanium#complete#get_kind(s) " {{{2
  if a:s =~ '($'
    return "m"
  elseif a:s =~ '(^|\.)[A-Z_]\+'
    return "p"
  else
    return "c"
  endif
endfunction

