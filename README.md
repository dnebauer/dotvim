# vim-dn-log-autocmds

A vim plugin that logs autocmd events.

## Features

Provides the two commands:

|Command        |Effect                                                      |
|---------------|------------------------------------------------------------|
|:LogAutocmds   |Toggles logging of autocmd events.                          |
|               |The plugin will echo messages advising the user whether the plugin was just enabled or disabled, and providing the path to the log file.|
|:AutocmdLogFile|Change the path to the log file.                            |
|               |Defaults to a file named `vim-log-autocmds` in a temporary directory selected according to the algorithm used by vim for creating temporary files (see `:h tempfile`).|
|               |If the variable `g:dn_log_autocmds` is set at the time the plugin is loaded, its value will be used as the path of the log file. The plugin will not check the validity of the path supplied. An invalid or unwritable path will result in an error when the plugin attempts to log an autocmd event.|

## Credits ##

This plugin was forked from github repository
[dotvim](https://github.com/lervag/dotvim) created by Karl Yngve Lervåg
([lervag](mailto:karl.yngve+git@gmail.com)).

## License ##

At the time of forking the [dotvim](https://github.com/lervag/dotvim)
repository did not include any license. While github [terms of
service](https://help.github.com/articles/github-terms-of-service/) allow users
to fork repositories, Mr Lervåg's rights are otherwise reserved.

As far as my own rights in this work, I have used the [CC0
license](http://creativecommons.org/publicdomain/zero/1.0/) to ensure that to
the extent possible under law, I have waived all copyright and related or
neighboring rights to this work.
