" Vim global plugin for logging autocmd events
" Last change: 2018 Jul 23
" Maintainer: David Nebauer
" License: CC0

" Housekeeping    {{{1
if exists('g:loaded_dn_log_events') | finish | endif
let g:loaded_dn_log_events = 1

let s:save_cpo = &cpoptions
set cpoptions&vim

" Introduction to plugin   {{{1

""
" @section Introduction, intro
" @order intro config logfile events commands
" A plugin that logs events to file.
"
" The log file location is set by default (in most cases), and can be set with
" a global variable or plugin command. See @section(logfile) for further
" details.
"
" Not all events are logged. See @section(events) for further details.
"
" Logging is off by default. It is toggled on and off with the command
" @command(LogEvents). Current logging status can be displayed with the
" command @command(EventLoggingStatus).
"
" User messages can be written to the log file (see command
" @command(AnnotateEventLog)) and the log file deleted (see command
" @command(DeleteEventLog)).

" Explain logfile path    {{{1

""
" @section Log file, logfile
" The default log file name is "vim-events-log" in the user's home directory.
" The plugin will look for the home directory. On Windows systems it will look
" for the variable $USERPROFILE. On all other systems it will look for the
" variable $HOME. If the variable is found, the default log file is set to
" "$USERPROFILE/vim-events-log" or "$HOME/vim-events-log".
"
" If the variable |g:dn_events_log| is set at the time of plugin
" initialisation, the log file path is set to the value of the variable.
"
" At any time the log file path can be changed using the
" @command(EventLogFile).
"
" The plugin does not check whether the logfile path is valid. If the logfile
" path is invalid it will result in system errors when the plugin attempts to
" write to the log file.

" Set default log file    {{{1

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
" @setting g:dn_events_log
" The path to the log file. Must be set before the @plugin(name) plugin
" is initialised, and is intended to be set in |vimrc|. See @section(logfile)
" for further details on setting the log file path.

""
" @private
" Set default log file path.
function s:set_logfile() abort
    " user-set path takes precedence
    if exists('g:dn_events_log')
        call dn#logevents#_logfile(g:dn_events_log)
        return
    endif
    " default value
    let l:default_file = 'vim-events-log'
    let l:os = s:os()
    let l:logfile = ''
    if l:os ==# 'windows' && exists('$USERPROFILE')
        let l:logfile = $USERPROFILE . '/' . l:default_file
    endif
    if empty(l:logfile) && exists('$HOME')
        let l:logfile = $HOME . '/' . l:default_file
    endif
    if !empty(l:logfile)
        call dn#logevents#_logfile(l:logfile)
    endif
endfunction

call s:set_logfile()

" Explain events    {{{1

""
" @section Events, events
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
" If an event does not appear in either list above, it has been missed!

" Housekeeping    {{{1

let &cpoptions = s:save_cpo
unlet s:save_cpo
" }}}1

" vim: set foldmethod=marker :
