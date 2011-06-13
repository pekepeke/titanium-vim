" A ref source for tidesktopref
" Version: 0.0.1
" Author : pekepeke <pekepekesamurai@gmail.com>
" License: Creative Commons Attribution 2.1 Japan License
"          <http://creativecommons.org/licenses/by/2.1/jp/deed.en>

let s:save_cpo = &cpo
set cpo&vim

" config. {{{1
if !exists('g:ref_tidesktopref_cmd')
  let g:ref_tidesktopref_cmd = 'tidesktopref'
endif
if !exists('g:ref_tidesktopref_complete_head')
  let g:ref_tidesktopref_complete_head = 0
endif
if !exists('g:ref_tidesktopref_docroot') " {{{2
  if exists('$TIDESKTOPREF_DOCROOT')
    let g:ref_tidesktopref_docroot = $TIDESKTOPREF_DOCROOT
  elseif executable('tidesktopref')
    let g:ref_tidesktopref_docroot = substitute(
          \ system(g:ref_tidesktopref_cmd . ' -d'),
          \ '[\r\n]', '', 'g')
  endif
endif

let s:source = {'name': 'tidesktopref'} " {{{1

function! s:source.available() " {{{2
  return executable(g:ref_tidesktopref_cmd) && exists('g:ref_tidesktopref_docroot')
endfunction

function! s:source.get_body(query) " {{{2
  let res =  ref#system(g:ref_tidesktopref_cmd . ' ' . a:query).stdout
  return s:tidesktopref_body_filter(res)
endfunction

function! s:source.opened(query) " {{{2
  call s:syntax(a:query)
endfunction

function! s:source.leave() " {{{2
  syntax clear
endfunction

function! s:source.complete(query) " {{{2
  let files = split(globpath(g:ref_tidesktopref_docroot, "/**/*.html"), "\n")
  call map(files, 'substitute(fnamemodify(v:val, ":t:r"), "-.\\+$", "", "e")')
  if a:query == ""
    return files
  endif
  let is_shortname = stridx(a:query, 'Ti.') == 0
  "  ignore escape... --;
  let query = escape(substitute(a:query, '^Ti\.', 'Titanium.', 'e'), '.')
  let query = g:ref_tidesktopref_complete_head ? '^'.query : '.*'.query
  "call filter(files, 'v:val =~ "^'.query.'\\.\\?[a-zA-Z]\\+$"')
  call filter(files, 'v:val =~? "'.query.'.*"')
  return is_shortname ? map(files, 'substitute(v:val, "^Titanium\\.", "Ti.", "e")') : files
endfunction

function! s:source.get_keyword() " {{{2
  let isk = &l:iskeyword
  setlocal isk& isk+=- isk+=. isk+=:
  let kwd = expand('<cword>')
  let &l:iskeyword = isk

  if stridx(kwd, '.') == -1 && exists("b:ref_history_pos")
    let buf_name = b:ref_history[b:ref_history_pos][1]
    if stridx(buf_name, kwd) == -1 && buf_name != ""
      let kwd = buf_name . '.' . kwd
    endif
  endif
  return kwd
endfunction

" functions. {{{1
function! s:syntax(query) " {{{2
  if exists('b:current_syntax') && b:current_syntax == 'ref-tidesktopref'
    return
  endif
  syntax clear
  unlet! b:current_syntax

  syntax include @refJs syntax/javascript.vim
  syntax region jsHereDoc    matchgroup=jsStringStartEnd start=+\n\(var\s\)\@=+ end=+^$+ contains=@refJs
  syntax region jsHereDoc    matchgroup=jsStringStartEnd start=+^\(.*\s=\s\)\@=+ end=+^$+ contains=@refJs
  syntax region jsHereDoc    matchgroup=jsStringStartEnd start=+\n\(function\s\)\@=+ end=+^$+ contains=@refJs
  syntax region jsHereDoc    matchgroup=jsStringStartEnd start=+\n\(//\s\)\@=+ end=+^$+ contains=@refJs

  "syntax region tidesktoprefKeyword  matchgroup=tidesktoprefKeyword start=+^\(Summary$\|Syntax$\|Parameters$\|Description$\|Properties$\|Methods$\|Events$\|Examples$\|See\sAlso$\)\@=+ end=+$+
  syntax region tidesktoprefKeyword  matchgroup=tidesktoprefKeyword start=+^\(Objects$\|Parameters$\|Functions$\|Desktop\sAPI\sReference$\|Properties$\|Methods$\|Events$\|Notes$\|Design$\|Code\sExamples$\|Arguments$\|Return\sType$\)\@=+ end=+$+
  highlight def link tidesktoprefKeyword Title

  let b:current_syntax = 'ref-tidesktopref'
endfunction

function! s:tidesktopref_body_filter(body) " {{{2
  return a:body
endfunction

function! ref#tidesktopref#define() " {{{2
  return s:source
endfunction

call ref#register_detection('tidesktop', 'tidesktopref')

let &cpo = s:save_cpo
unlet s:save_cpo

