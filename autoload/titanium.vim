" basic functions for titanium
" Version: 0.0.1
" Author : pekepeke <pekepekesamurai@gmail.com>
" License: Creative Commons Attribution 2.1 Japan License
"          <http://creativecommons.org/licenses/by/2.1/jp/deed.en>

" public {{{1
function! titanium#is_mac() " {{{2
  return has('macunix') || (executable('uname') && system('uname') =~? '^darwin')
endfunction

function! titanium#is_win() " {{{2
  return has('win16') || has('win32') || has('win64')
endfunction

function! titanium#error(msg) " {{{2
  echoerr a:msg
endfunction

function! titanium#warn(msg) " {{{2
  echohl WarningMsg
  echomsg a:msg
  echohl None
endfunction

function! titanium#get_projdir() " {{{2
    return b:titanium_proj
endfunction
function! titanium#is_project() " {{{2
  return exists('b:titanium_proj')
endfunction

function! titanium#is_desktop() " {{{2
  " XXX ><
  return titanium#is_project() && filereadable(b:titanium_proj.'/Resources/index.html')
endfunction

function! titanium#get_sdk_path() " {{{2
  if exists('b:titanium_current_project_sdk_path')
    " XXX cache ... don't need?
    return b:titanium_current_project_sdk_path
  endif
  " find sdk
  " TODO get sdk ver & sdk path from ... where?
  let l:sdk_ver = '*'
  if exists('g:titanium_sdk_root_dir')
    let l:sdk_dir = reverse(
          \ split(glob(g:titanium_sdk_root_dir. '/*/'.l:sdk_ver), '\n'))
  elseif titanium#is_win()
    let l:sdk_dir = substitute($PROGRAMDATA != "" 
          \ ? $PROGRAMDATA 
          \ : $ALLUSERSPROFILE.'/Application Data', '\\', '/', 'g')
    let l:sdk_dirs = reverse(
          \ split(glob(l:sdk_dir.'/Titanium/'.s:get_sdk_prefix().'/*/'.l:sdk_ver), '\n'))
  elseif titanium#is_mac()
    let l:sdk_dirs = reverse(
          \ split(glob('/Library/Application\ Support/Titanium/'.s:get_sdk_prefix().'/osx/'.l:sdk_ver), "\n"))
  else
    " TODO on unix env
  endif
  if exists('l:sdk_dirs') && len(l:sdk_dirs)
    let b:titanium_current_project_sdk_path = l:sdk_dirs[0]
    return l:sdk_dirs[0]
  endif
  return ''
endfunction

function! titanium#get_android_sdk_path() " {{{2
  if exists('g:titanium_android_sdk_path')
    return g:titanium_android_sdk_path
  endif
  if exists('$ANDROID_HOME')
    return $ANDROID_HOME
  elseif titanium#is_win()
    for path in split(glob($PROGRAMFILES.'android-sdk-windows*), "\n")
      if isdirectory(path)
        return path
      endif
    endfor
  elseif titanium#is_mac()
    for path in split(glob('/Applications/android-sdk-mac_*'))
      if isdirectory(path)
        return path
      endif
    endfor
  else
    " TODO on unix env
  endif
  return ''
endfunction


function! titanium#get_keywordfile_path() " {{{2
  return titanium#is_desktop() ? 
        \ g:titanium_desktop_complete_keywords_path :
        \ g:titanium_mobile_complete_keywords_path
endfunction


" private {{{1
function! s:find_complete_keywords_path(mode) " {{{2
  let fname = (a:mode ==? 'desktop' ? 'lib/tidesktop.txt' : 'lib/timobile.txt')
  let l:files = split(globpath(&rtp, fname), "\n")
  if len(l:files) > 0
    return l:files[0]
  endif
endfunction


function! s:get_sdk_prefix() " {{{2
  return titanium#is_desktop() ? "sdk" : "mobilesdk"
endfunction


" public vars {{{1
if !exists('g:titanium_desktop_complete_keywords_path') " {{{2
  let g:titanium_desktop_complete_keywords_path 
        \ = <SID>find_complete_keywords_path('desktop')
endif
if !exists('g:titanium_mobile_complete_keywords_path') " {{{2
  let g:titanium_mobile_complete_keywords_path 
        \ = <SID>find_complete_keywords_path('mobile')
endif
