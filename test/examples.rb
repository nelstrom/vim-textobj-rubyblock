class Foo
  include Bar
end

class Foo
  # words containing 'end' to be ignored
  include Bendy
  include Girlfriend
  include Endothermic
end

class Foo
  # [cursor]
  # Ignore the word 'end' if it appears in a comment!
end

class Foo
  # [cursor]
  "one #{end}" # the '#' symbol is not always a comment!
end

class Foo
  # [cursor]
  # vir/var should select Foo class
  if true
    # do not select inner block only
    # search forwards.
    # For each *keyword*, add to stack
    # for each 'end', remove *keyword* from stack
    # if an 'end' is found when stack is empty, jump to match '%'
  else
    # selecting 'all' of an if/else construct means from the opening
    # 'if' to the closing 'end'.
  end
end

module Foo
  class Bar
    def Baz
      [1,2,3].each do |i|
        i + 1
      end
    end
  end
end

[1,2,3,4,5].map do |i|
  # don't forget that a method can be called on 'end'!
  i + 1
end.max
