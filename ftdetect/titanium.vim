" Titanium ftdetect
" Version: 0.0.1
" Author : pekepeke <pekepekesamurai@gmail.com>
" License: Creative Commons Attribution 2.1 Japan License
"          <http://creativecommons.org/licenses/by/2.1/jp/deed.en>

augroup titanium-autocmd
  au!
  autocmd BufNewFile,BufRead *.html,*.php,*.rb,*.py,*.js,*.coffee call s:detect_titanium()
augroup END

function! s:detect_titanium()
  if exists('b:titanium_proj')
    return
  endif
  let b:titanium_proj = fnameescape(globpath(expand('<afile>:p:h'), 'tiapp.xml'))
  if empty(b:titanium_proj)
    let b:titanium_proj  = fnameescape(globpath(expand('<afile>:p:h:h'), 'tiapp.xml'))

    if empty(b:titanium_proj)
      let b:titanium_proj = fnameescape(globpath(expand('<afile>:p:h:h:h'), 'tiapp.xml'))
      if empty(b:titanium_proj)
        let b:titanium_proj = fnameescape(globpath(expand('<afile>:p:h:h:h:h'), 'tiapp.xml'))
      endif
    endif
  endif
  if !empty(b:titanium_proj)
    let b:titanium_proj = fnamemodify(b:titanium_proj, ':p:h')
    " XXX (--;;
    silent exe 'setl' 'ft='.&ft.'.titanium'
  else
    unlet b:titanium_proj
  endif
endfunction

