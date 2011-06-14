" titanium filetype plugin
" Version: 0.0.1
" Author : pekepeke <pekepekesamurai@gmail.com>
" License: Creative Commons Attribution 2.1 Japan License
"          <http://creativecommons.org/licenses/by/2.1/jp/deed.en>


if exists('b:did_ftplugin_titanium') " {{{1
  finish
endif

" variables {{{2
if !exists('g:titanium_disable_keymap')
  let g:titanium_disable_keymap = 0
endif

" basic {{{2

if &include != '' | setl include+=\| | endif
setl include+=^\s*Ti.include\|^\s*Titanium.include\|\s*url\s*:\s*\|\s*test\s*:\s*
"setl includeexpr=v:fname
if !g:titanium_disable_keymap
  call titanium#titaniumcomplete#enable_omnifunc()
endif


" build commands {{{2
if titanium#build#can()
  if titanium#build#can_multi()
    command! -nargs=* -complete=customlist,titanium#build#device_complete -buffer
          \ TitaniumBuild call titanium#build#execute(<f-args>)
  else
    command! -nargs=* -buffer
          \ TitaniumBuild call titanium#build#execute(<f-args>)
  endif
endif

" buffer mappings {{{2
if titanium#command#unite_utilizable()
  nnoremap <silent><buffer> <Plug>(titanium_unite_completion)
        \ :call titanium#command#unite_completion()<CR>
  inoremap <silent><buffer> <Plug>(titanium_unite_completion)
        \ :call titanium#command#unite_completion()<CR>
  if !hasmapto('<Plug>(titanium_unite_completion)', 'n')
        \ && maparg('<LocalLeader>i', 'n', 'rhs') == ''
    nmap <silent><buffer> <LocalLeader>i
          \ <Plug>(titanium_unite_completion)
  endif
endif

if titanium#command#help_utilizable()
  if titanium#is_desktop()
    command! -nargs=* -buffer TiDesktopHelp call titanium#command#help_open(<f-args>)
  else
    command! -nargs=* -buffer TiMobileHelp call titanium#command#help_open(<f-args>)
  endif
  if !g:titanium_disable_keymap
    nnoremap <buffer><silent> K :call titanium#command#K()<CR>
  endif
endif

let b:did_ftplugin_titanium = 1

