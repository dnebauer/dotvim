# vim-dn-log-autocmds

A vim plugin that logs autocmd events.

## Features

Provides the following commands:

|Command             |Notes                                                  |
|--------------------|-------------------------------------------------------|
|:LogAutocmds        |Toggles logging of autocmd events.                     |
|                    |Creates log file if it does not exist. Appends to log file if it already exists.|
|                    |The plugin will echo messages advising the user whether the plugin was just enabled or disabled, and providing the path to the log file.|
|                    |Causes an error if no log file path is set when
attempting to enable autocmd logging.|
|:AutocmdsLogFile    |Change the path to the log file.                       |
|                    |Default log file is `$HOME/vim-autocmds-log` (*nix) or `$USERPROFILE/vim-autocmds-log` (Windows). Other operating systems have no default log file.|
|                    |If the variable `g:dn_autocmds_log` is set at the time the plugin is loaded, its value will be used as the path of the log file. The plugin will not check the validity of the path supplied. An invalid or unwritable path will result in an error when the plugin attempts to log an autocmd event.|
|:AnnotateAutocmdsLog|Add a single line note to the autocmds log file.       |
|                    |Displays an error message if autocmd logging is not
enabled.|
|:DeleteAutocmdsLog  |Deletes log file if it exists.                         |

# Events #

The following events are logged:

* BufAdd, BufCreate, BufDelete, BufEnter, BufFilePost, BufFilePre, BufHidden,
  BufLeave, BufNew, BufNewFile, BufRead, BufReadPost, BufReadPre, BufUnload,
  BufWinEnter, BufWinLeave, BufWipeout, BufWrite, BufWritePost, BufWritePre,
  CmdUndefined, CmdwinEnter, CmdwinLeave, ColorScheme, CompleteDone,
  CursorHold, CursorHoldI, CursorMoved, CursorMovedI, EncodingChanged,
  FileAppendPost, FileAppendPre, FileChangedRO, FileChangedShell,
  FileChangedShellPost, FileReadPost, FileReadPre, FileType, FileWritePost,
  FileWritePre, FilterReadPost, FilterReadPre, FilterWritePost, FilterWritePre,
  FocusGained, FocusLost, GUIEnter, GUIFailed, InsertChange, InsertCharPre,
  InsertEnter, InsertLeave, MenuPopup, QuickFixCmdPost, QuickFixCmdPre,
  QuitPre, RemoteReply, SessionLoadPost, ShellCmdPost, ShellFilterPost,
  SourcePre, SpellFileMissing, StdinReadPost, StdinReadPre, SwapExists, Syntax,
  TabEnter, TabLeave, TermChanged, TermResponse, TextChanged, TextChangedI,
  User, VimEnter, VimLeave, VimLeavePre, VimResized, WinEnter, and WinLeave.

The following events are intentionally not logged because, according to the
original project, they resulted in 'side effects':

* BufReadCmd, BufWriteCmd, FileAppendCmd, FileReadCmd, FileWriteCmd,
  FuncUndefined, and SourceCmd.

If an autocmd event does not appear in either list it has been missed!

## Credits ##

This plugin was forked from github repository
[dotvim](https://github.com/lervag/dotvim) created by Karl Yngve Lervåg
([lervag](https://github.com/lervag)).

## License ##

At the time of forking the [dotvim](https://github.com/lervag/dotvim)
repository did not include any license. While github [terms of
service](https://help.github.com/articles/github-terms-of-service/) allow users
to fork repositories, Mr Lervåg's rights are otherwise reserved.

As far as my own rights are concerned, I have used the [CC0
license](http://creativecommons.org/publicdomain/zero/1.0/) to ensure that to
the extent possible under law, I have waived all copyright and related or
neighboring rights to this work.
