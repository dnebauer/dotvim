" Vim global plugin for logging autocmd events
" Last change: 2018 Jul 21
" Maintainer: David Nebauer
" License: CC0

if exists('g:loaded_dn_log_autocmds') | finish | endif
let g:loaded_dn_log_autocmds = 1

let s:save_cpo = &cpoptions
set cpoptions&vim

""
" @section Introduction, intro
" @order intro logfile events commands
" A plugin that logs autocmd events to a log file.
"
" The log file location is set by default (in most cases), and can be set with
" a global variable or plugin command. See @section(logfile) for further
" details.
"
" Not all events are logged. See @section(events) for further details.
"
" Logging is off by default. It is toggled on and off with the command
" @command(LogAutocmds). Current logging status can be displayed with the
" command @command(AutocmdsLoggingStatus).
"
" User messages can be written to the log file (see command @command(AnnotateAutocmdsLog)) and the log file deleted (see command @command(DeleteAutocmdsLog)).

""
" @section Log file, logfile
" The default log file name is "vim-autocmds-log" in the user's home
" directory. The plugin will look for the home directory. On Windows systems
" it will look for the variable $USERPROFILE. On all other systems it will
" look for the variable $HOME. If the variable is found, the default log file
" is set to "$USERPROFILE/vim-autocmds-log" or "$HOME/vim-autocmds-log".
"
" If the variable g:dn_autocmds_log is set at the time of plugin
" initialisation, the log file path is set to the value of the variable.
"
" At any time the log file path can be changed using the
" @command(AutocmdsLogFile).
"
" The plugin does not check whether the logfile path is valid. If the logfile
" path is invalid it will result in system errors when the plugin attempts to
" write to the log file.

""
" @private
" Provide operating system type.
function s:os() abort
    if has('win32') || has ('win64') || has('win95') || has('win32unix')
        return 'windows'
    elseif has('unix')
        return 'unix'
    else
        return 'other'
    endif
endfunction

""
" @private
" Set default log file path.
function s:set_logfile() abort
    " user-set path takes precedence
    if exists('g:dn_autocmds_log')
        call dn#log_autocmds#_logfile(g:dn_autocmds_log)
        return
    endif
    " default value
    let l:default_file = 'vim-autocmds-log'
    let l:os = s:os()
    let l:logfile = ''
    if l:os ==# 'windows' && exists('$USERPROFILE')
        let l:logfile = $USERPROFILE . '/' . l:default_file
    endif
    if empty(l:logfile) && exists('$HOME')
        let l:logfile = $HOME . '/' . l:default_file
    endif
    echoerr 'Logfile value: >>' . l:logfile . '<<'
    if !empty(l:logfile)
        call dn#log_autocmds#_logfile(l:logfile)
    endif
endfunction

call s:set_logfile()

""
" @section Autocmd Events, events
"
" The following events are logged:
"
" BufAdd, BufCreate, BufDelete, BufEnter, BufFilePost, BufFilePre, BufHidden,
" BufLeave, BufNew, BufNewFile, BufRead, BufReadPost, BufReadPre, BufUnload,
" BufWinEnter, BufWinLeave, BufWipeout, BufWrite, BufWritePost, BufWritePre,
" CmdUndefined, CmdwinEnter, CmdwinLeave, ColorScheme, CompleteDone,
" CursorHold, CursorHoldI, CursorMoved, CursorMovedI, EncodingChanged,
" FileAppendPost, FileAppendPre, FileChangedRO, FileChangedShell,
" FileChangedShellPost, FileReadPost, FileReadPre, FileType, FileWritePost,
" FileWritePre, FilterReadPost, FilterReadPre, FilterWritePost,
" FilterWritePre, FocusGained, FocusLost, GUIEnter, GUIFailed, InsertChange,
" InsertCharPre, InsertEnter, InsertLeave, MenuPopup, QuickFixCmdPost,
" QuickFixCmdPre, QuitPre, RemoteReply, SessionLoadPost, ShellCmdPost,
" ShellFilterPost, SourcePre, SpellFileMissing, StdinReadPost, StdinReadPre,
" SwapExists, Syntax, TabEnter, TabLeave, TermChanged, TermResponse,
" TextChanged, TextChangedI, User, VimEnter, VimLeave, VimLeavePre,
" VimResized, WinEnter, and WinLeave.
"
" The following events are intentionally not logged because, according to the
" original project, they resulted in "side effects":
"
" BufReadCmd, BufWriteCmd, FileAppendCmd, FileReadCmd, FileWriteCmd,
" FuncUndefined, and SourceCmd.
" 
" If an autocmd event does not appear in either list above, it has been
" missed!

let &cpoptions = s:save_cpo
unlet s:save_cpo
