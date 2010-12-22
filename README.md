A custom text object for selecting ruby blocks.

Depends on Kana's [textobj-user plugin][u].

Test suite requires [vspec][] (also by Kana).

Running the specs
-----------------

To run the specs, you call vspec as follows:

    vspec {input-script} [{non-standard-runtimepath} ...]

In this case, the non-standard runtimepath must include the vspec plugin, the textobj-user plugin (which is a dependency for this plugin) and this plugin.

Assuming you use [pathogen][] to manage your plugins, then the plugins required to run the test suite will be found in the following locations:

    ~/dotfiles
              /vim
                  /textobj-user
                  /textobj-rubyblock
                  /vspec

So to run the `basic.input` tests, you would run:

    cd ~/dotfiles/vim/textobj-rubyblock
    ../vspec/bin/vspec test/basic.input ../vspec/ ../textobj-user/ .



[u]: https://github.com/kana/vim-textobj-user
[vspec]: https://github.com/kana/vim-vspec
