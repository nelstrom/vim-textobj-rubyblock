" nnoremap <leader>r :wa <bar> ! ../vspec/bin/vspec ../vspec/ ../textobj-user . test/rubyblock_test.vim<CR>
silent filetype indent plugin on
runtime! macros/matchit.vim
runtime! plugin/textobj/*.vim

describe 'rubyblock'

  it 'should set a global variable'
    Expect exists('g:loaded_textobj_rubyblock') ==# 1
  end

end

describe 'default'

  it 'should create named key maps'
    for _ in ['<Plug>(textobj-rubyblock-a)',
          \         '<Plug>(textobj-rubyblock-i)']
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

  it 'selects inside of a class'
    execute "normal v\<Plug>(textobj-rubyblock-i)\<Esc>"
    Expect [line("'<"), col("'<")] ==# [2, 1]
    Expect [line("'>"), col("'>")] ==# [2, 14]
  end

end

describe '<Plug>(textobj-rubyblock-a)'
  before
    silent tabnew test/samples/class.rb
  end

  it 'selects inside of a class'
    execute "normal v\<Plug>(textobj-rubyblock-a)\<Esc>"
    Expect [line("'<"), col("'<")] ==# [1, 1]
    Expect [line("'>"), col("'>")] ==# [3, 4]
  end

end
