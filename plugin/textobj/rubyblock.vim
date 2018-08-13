if exists('g:loaded_textobj_rubyblock')  "{{{1
  finish
endif

" Interface  "{{{1
call textobj#user#plugin('rubyblock', {
\      '-': {
\        '*sfile*': expand('<sfile>:p'),
\        'select-a': 'ar',  '*select-a-function*': 's:select_a',
\        'select-i': 'ir',  '*select-i-function*': 's:select_i'
\      }
\    })

" Misc.  "{{{1
let s:comment_escape = '\v^[^#]*'
let s:block_openers = '\zs(<def>|<if>|<unless>|<do>|<module>|<class>|<case>'
let s:block_openers .= '|<for>|<while>|<until>|<begin>)'
let s:start_pattern = s:comment_escape . s:block_openers
let s:mid_pattern = s:comment_escape
let s:mid_pattern .= '\zs(<else>|<elsif>|<when>|<rescue>|<ensure>)'
let s:end_pattern = s:comment_escape . '\zs<end>'
let s:skip_pattern = 'getline(".") =~ "\\v\\S\\s<(if|unless)>\\s\\S"'

if !exists('g:textobj_rubyblock_mids')
  let g:textobj_rubyblock_mids = 0
endif

function! s:select_a()
  let s:flags = 'W'

  call searchpair(s:start_pattern,'',s:end_pattern, s:flags, s:skip_pattern)
  let end_pos = getpos('.')

  " Jump to match
  normal %
  let start_pos = getpos('.')

  return ['V', start_pos, end_pos]
endfunction

function! s:select_i()
  let s:flags = 'W'
  if expand('<cword>') == 'end'
    let s:flags = 'cW'
  endif

  let l:mid = ''
  if g:textobj_rubyblock_mids
    let l:mid = s:mid_pattern
  endif

  call searchpair(s:start_pattern,l:mid,s:end_pattern, s:flags, s:skip_pattern)

  " Move up one line, and save position
  normal k^
  let end_pos = getpos('.')

  if g:textobj_rubyblock_mids
    " Move down again, find match right before, and save position
    normal j^
    let l:last_position = getpos('.')
    let l:start_line = l:last_position[1]
    normal %
    while getpos('.')[1] != l:start_line
      let l:last_position = getpos('.')
      normal %
    endwhile
    call setpos('.', l:last_position)
    normal j^
    let start_pos = getpos('.')
  else
    " Move down again, jump to match, then down one line and save position
    normal j^%j
    let start_pos = getpos('.')
  endif

  return ['V', start_pos, end_pos]
endfunction

" Fin.  "{{{1

let g:loaded_textobj_rubyblock = 1

" __END__
" vim: foldmethod=marker
