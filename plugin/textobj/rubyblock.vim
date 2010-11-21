if exists('g:loaded_textobj_rubyblock')  "{{{1
  finish
endif

" Interface  "{{{1
call textobj#user#plugin('rubyblock', {
\      '-': {
\        '*sfile*': expand('<sfile>:p'),
\        'select-a': 'ae',  '*select-a-function*': 's:select_a',
\        'select-i': 'ie',  '*select-i-function*': 's:select_i'
\      }
\    })

" Misc.  "{{{1
let s:comment_escape = '\v^[^#]*'
let s:block_openers = '\zs(<def>|<if>|<do>|<module>|<class>)'
let s:start_pattern = s:comment_escape . s:block_openers
let s:end_pattern = s:comment_escape . '\zs<end>'

function! s:select_a()
  call searchpair(s:start_pattern,'',s:end_pattern, 'W')
  let end_pos = getpos('.')

  normal %
  let start_pos = getpos('.')

  return ['V', start_pos, end_pos]
endfunction

function! s:select_i()
  call searchpair(s:start_pattern,'',s:end_pattern, 'W')
  let end_pos = getpos('.')
  let end_pos[1] = end_pos[1] - 1

  normal %
  let start_pos = getpos('.')
  let start_pos[1] = start_pos[1] + 1

  return ['V', start_pos, end_pos]
endfunction

" Fin.  "{{{1

let g:loaded_textobj_rubyblock = 1

" __END__
" vim: foldmethod=marker
