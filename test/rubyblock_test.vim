" nnoremap <leader>r :wa <bar> ! ../vspec/bin/vspec ../vspec/ ../textobj-user . test/rubyblock_test.vim<CR>
silent filetype indent plugin on
runtime! macros/matchit.vim
runtime! plugin/textobj/*.vim
set visualbell

function! SelectInsideFrom(number, position)
  execute "normal ".a:number."G".a:position
  execute "normal v\<Plug>(textobj-rubyblock-i)\<Esc>"
  return [a:number, line("'<"), line("'>")]
endfunction

function! SelectAroundFrom(number, position)
  execute "normal ".a:number."G".a:position
  execute "normal v\<Plug>(textobj-rubyblock-a)\<Esc>"
  return [a:number, line("'<"), line("'>")]
endfunction

describe 'rubyblock'

  it 'should set a global variable'
    Expect exists('g:loaded_textobj_rubyblock') ==# 1
  end

end

describe 'default'

  it 'should create named key maps'
    for _ in ['<Plug>(textobj-rubyblock-a)', '<Plug>(textobj-rubyblock-i)']
      execute "Expect maparg(".string(_).", 'c') == ''"
      execute "Expect maparg(".string(_).", 'i') == ''"
      execute "Expect maparg(".string(_).", 'n') == ''"
      execute "Expect maparg(".string(_).", 'o') != ''"
      execute "Expect maparg(".string(_).", 'v') != ''"
    endfor
  end

  it 'should be set up mappings for visual and operator-pending modes only'
    Expect maparg('ar', 'c') ==# ''
    Expect maparg('ar', 'i') ==# ''
    Expect maparg('ar', 'n') ==# ''
    Expect maparg('ar', 'o') ==# '<Plug>(textobj-rubyblock-a)'
    Expect maparg('ar', 'v') ==# '<Plug>(textobj-rubyblock-a)'
    Expect maparg('ir', 'c') ==# ''
    Expect maparg('ir', 'i') ==# ''
    Expect maparg('ir', 'n') ==# ''
    Expect maparg('ir', 'o') ==# '<Plug>(textobj-rubyblock-i)'
    Expect maparg('ir', 'v') ==# '<Plug>(textobj-rubyblock-i)'
  end

end

describe '<Plug>(textobj-rubyblock-i)'
  before
    silent tabnew test/samples/class.rb
  end

  after
    silent tabclose
  end

  it 'selects inside of a class'
    Expect SelectInsideFrom(1, '^') ==# [1, 2, 2]
  end

end

describe '<Plug>(textobj-rubyblock-a)'
  before
    silent tabnew test/samples/class.rb
  end

  after
    silent tabclose
  end

  it 'selects all of a class'
    Expect SelectAroundFrom(1, '^') ==# [1, 1, 3]
  end

end

describe '<Plug>(textobj-rubyblock-i)'
  before
    silent tabnew test/samples/commented-end.rb
  end

  after
    silent tabclose
  end

  it 'ignores "end" keyword inside of a comment'
    execute "normal v\<Plug>(textobj-rubyblock-i)\<Esc>"
    TODO
    Expect SelectInsideFrom(1, '^') ==# [1, 2, 2]
  end

end

describe 'if/else blocks'
  before
    silent tabnew test/samples/if-else.rb
  end

  after
    silent tabclose
  end

  it 'ignores nested if/else block'
    for number in [1,2,8]
      Expect SelectInsideFrom(number, '^') ==# [number, 2, 7]
      Expect SelectInsideFrom(number, '0') ==# [number, 2, 7]
      Expect SelectAroundFrom(number, '0') ==# [number, 1, 8]
    endfor
    for number in [1,2,7,8]
      Expect SelectAroundFrom(number, '^') ==# [number, 1, 8]
    endfor
    " this behaviour (already tested in loop) is unintuitive!
    Expect SelectAroundFrom(7, '^') ==# [7, 1, 8]
  end

  it 'selects nested if/else block'
    for number in [3,4,5,6,7]
      Expect SelectInsideFrom(number, '^') ==# [number, 4, 6]
    endfor
    for number in [3,4,5,6]
      Expect SelectAroundFrom(number, '^') ==# [number, 3, 7]
    endfor
    Expect SelectAroundFrom(7, '0') ==# [7, 3, 7]
  end

end

