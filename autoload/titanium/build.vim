" functions for titanium build proj
" Version: 0.0.1
" Author : pekepeke <pekepekesamurai@gmail.com>
" License: Creative Commons Attribution 2.1 Japan License
"          <http://creativecommons.org/licenses/by/2.1/jp/deed.en>


function! s:get_build_command(device, params) " {{{2
  let l:sdk_path = titanium#get_sdk_path()
  if !titanium#is_project() || l:sdk_path == ""
    return ''
  endif
  let l:proj_dir = titanium#get_projdir()
  let l:device = a:device
  if l:device ==? 'desktop'
    " run app after ver 1.1.0
    " XXX param
    return join([fnameescape(l:sdk_path . '/tibuild.py'), 
          \ '-run', 
          \ fnameescape(l:proj_dir), 
          \ '-d', 
          \ fnameescape(l:proj_dir . '/dist'), 
          \ join(a:params, ' '),
          \ ], ' ')
  elseif l:device ==? 'ipad'
    " XXX param
    return join([fnameescape(l:sdk_path . '/iphone/builder.py'),
          \ 'run', 
          \ fnameescape(l:proj_dir), 
          \ empty(a:params) ? '3.2 0 0 ipad' : join(a:params, ' '),
          \ ], ' ')
  elseif l:device ==? 'android'
    " TODO runnable?
    let l:android_sdk = fnameescape(titanium#get_android_sdk_path())
    if isdirectory(l:android_sdk)
      " return join([fnameescape(l:sdk_path . '/android/builder.py'), 
            " \ 'run-emulator', 
            " \ fnameescape(l:proj_dir), 
            " \ l:android_sdk, 
            " \ ], ' ')
      " XXX param
      return join([fnameescape(l:sdk_path . '/android/builder.py'), 
            \ 'emulator', 
            \ 'ProjName', 
            \ l:android_sdk, 
            \ fnameescape(l:proj_dir), 
            \ 'projid', 
            \ empty(a:params) ? '4 HVGA' : join(a:params, ' '),
            \ ], ' ')
    endif
  else " case iphone
    " XXX param
    return join([fnameescape(l:sdk_path . '/iphone/builder.py'), 
          \ 'run', fnameescape(l:proj_dir), 
          \ join(a:params, ' '),
          \ ], ' ')
  endif
endfunction

function! titanium#build#execute(...) " {{{2
  if titanium#is_desktop()
    let l:device = 'desktop'
    let l:params = a:000
  else
    let l:device = a:0 > 0 && a:1 != "" ?
          \ a:1 : (titanium#is_mac() ? "iphone" : "android")
    let l:params = a:0 > 0 ? a:000[1:] : []
  endif

  let l:build_command = s:get_build_command(l:device, l:params)
  if l:build_command == ''
    call titanium#warn('command not found.')
  else
    " TODO run app synchronously is useless...
    if exists(':VimShellInteractive') == 2
      exe 'VimShellInteractive' l:build_command
    else
      exe '!'.l:build_command
    endif
  endif
endfunction

function! titanium#build#can() " {{{2
  return titanium#is_project()
endfunction

function! titanium#build#can_multi() " {{{2
  return !titanium#is_desktop() && titanium#is_mac()
endfunction

function! titanium#build#device_complete(A, L, P) " {{{2
  let l:devices = ['iphone', 'ipad', 'android']
  let l:matches = []
  for l:device in l:devices
    if l:device =~? '^' . a:A
      call add(l:matches, l:device)
    endif
  endfor
  return l:matches
endfunction

