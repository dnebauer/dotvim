""
" Autocmd events to log.
"
" The following autocmds are deliberately not logged because of side effects:
" - SourceCmd
" - FileAppendCmd
" - FileWriteCmd
" - BufWriteCmd
" - FileReadCmd
" - BufReadCmd
" - FuncUndefined
let s:aulist = [
            \ 'BufAdd',               'BufCreate',
            \ 'BufDelete',            'BufEnter',
            \ 'BufFilePost',          'BufFilePre',
            \ 'BufHidden',            'BufLeave',
            \ 'BufNew',               'BufNewFile',
            \ 'BufRead',              'BufReadPost',
            \ 'BufReadPre',           'BufUnload',
            \ 'BufWinEnter',          'BufWinLeave',
            \ 'BufWipeout',           'BufWrite',
            \ 'BufWritePost',         'BufWritePre',
            \ 'CmdUndefined',         'CmdwinEnter',
            \ 'CmdwinLeave',          'ColorScheme',
            \ 'CompleteDone',         'CursorHold',
            \ 'CursorHoldI',          'CursorMoved',
            \ 'CursorMovedI',         'EncodingChanged',
            \ 'FileAppendPost',       'FileAppendPre',
            \ 'FileChangedRO',        'FileChangedShell',
            \ 'FileChangedShellPost', 'FileReadPost',
            \ 'FileReadPre',          'FileType',
            \ 'FileWritePost',        'FileWritePre',
            \ 'FilterReadPost',       'FilterReadPre',
            \ 'FilterWritePost',      'FilterWritePre',
            \ 'FocusGained',          'FocusLost',
            \ 'GUIEnter',             'GUIFailed',
            \ 'InsertChange',         'InsertCharPre',
            \ 'InsertEnter',          'InsertLeave',
            \ 'MenuPopup',            'QuickFixCmdPost',
            \ 'QuickFixCmdPre',       'QuitPre',
            \ 'RemoteReply',          'SessionLoadPost',
            \ 'ShellCmdPost',         'ShellFilterPost',
            \ 'SourcePre',            'SpellFileMissing',
            \ 'StdinReadPost',        'StdinReadPre',
            \ 'SwapExists',           'Syntax',
            \ 'TabEnter',             'TabLeave',
            \ 'TermChanged',          'TermResponse',
            \ 'TextChanged',          'TextChangedI',
            \ 'User',                 'VimEnter',
            \ 'VimLeave',             'VimLeavePre',
            \ 'VimResized',           'WinEnter',
            \ 'WinLeave',
            \ ]

""
" Log file path.
"
" Can be set from variable g:dn_autocmds_log or by command
" @command(AutocmdsLogFile). Otherwise defaults to file named
" "vim-autocmds-log" in the user's home directory.
let s:logfile = ''

""
" Autocmd logging status.
"
" Whether autocmd event logging is currently enabled.
let s:enabled = 0


""
" @private
" Display error message.
function! s:error(message) abort
    echohl Error
    echomsg "\n" . a:message
    echohl Normal
endfunction

""
" @private
" Write a message to the autocmd events log file.
function! s:log(message) abort
    " need to have autocmd logging enabled
    if !s:enabled
        call s:error('Autocmd event logging is not enabled')
        return
    endif
    " write log message
    silent execute '!echo "'
                \ . strftime('%T', localtime()) . ' - ' . a:message . '"'
                \ ' >> ' . s:logfile
endfunction


""
" @private
" Toggle autocmds logging on and off. Writes a timestamped message to the log
" file.
function! dn#log_autocmds#_toggle() abort
    augroup LogAutocmd
        autocmd!
    augroup END

    let l:date = strftime('%F', localtime())
    let s:enabled = get(s:, 'enabled', 0) ? 0 : 1

    " stop logging
    if !s:enabled  " reversed logic because s:enabled just toggled
        echomsg 'Log file is ' . s:logfile
        call s:log('Stopped autocmd log (' . l:date . ')')
        return
    endif

    " start logging
    if empty(s:logfile)  " can't log without logfile!
        call s:error('No log file path has been set')
        return
    endif
    call s:log('Started autocmd log (' . l:date . ')')
    echomsg 'Log file is ' . s:logfile
    augroup LogAutocmd
        for l:au in s:aulist
            silent execute 'autocmd' l:au '* call s:log(''' . l:au . ''')'
        endfor
    augroup END
endfunction

""
" @private
" Display status of autocmds event logging and the log file path.
function! dn#log_autocmds#_status() abort
    " display logging status
    let l:status = (s:enabled) ? 'ENABLED' : 'DISABLED'
    echomsg 'Autocmds event logging is ' . l:status
    " display logfile
    let l:path = (s:logfile) ? 'not set' : s:logfile
    echomsg 'Log file is ' . l:path
endfunction

""
" @private
" Log future autocmd events and notes to file {path}.
" If {path} is the name of the current log file, the function has no
" effect. If the plugin is currently logging to a different file, that file is
" closed and the new log file opened.
" If the {path} is invalid or unwritable an error will occur when the plugin
" next attempts to write to the log. If logging is enabled when this function
" is invoked, the plugin tries to write to the file immediately with a
" timestamped message recording the time of logging activation.
function! dn#log_autocmds#_logfile(path) abort
    " return if no path provided
    if empty(a:path)
        call s:error('No log file path provided')
        return
    endif
    " no action required if log file path already set to this value
    let l:path = simplify(resolve(fnamemodify(a:path, ':p')))
    if !empty(s:logfile) && l:path ==# s:logfile
        return
    endif
    " okay, set logfile path
    let l:enabled = s:enabled
    if l:enabled
        call dn#log_autocmds#_toggle()
    endif
    let s:logfile = l:path
    if l:enabled
        call dn#log_autocmds#_toggle()
    endif
endfunction

""
" @private
" Write message to log file. Requires autocmd event logging to be enabled; if
" it is not, an error message is displayed.
function! dn#log_autocmds#_annotate(message) abort
    " return if no message provided
    if empty(a:message)
        call s:error('No log message provided')
        return
    endif
    " display error if not currently logging
    if !s:enabled
        call s:error('Autocmd event logging is not enabled')
        return
    endif
    " log message
    call s:log(a:message)
endfunction

""
" @private
" Delete log file if it exists.
function! dn#log_autocmds#_delete() abort
    if s:enabled
        call dn#log_autocmds#_toggle()
    endif
    if filewritable(s:logfile)
        let l:result = delete(s:logfile)
        let l:errors = []
        if l:result != 0
            call add(l:errors, 'Operating system reported delete error')
        endif
        if filewritable(s:logfile)
            call add(l:errors, 'Log file was not deleted')
        endif
        if !empty(l:errors)
            call insert(l:errors, 'Log file: ' . s:logfile)
            call s:error(join(l:errors, "\n"))
        endif
    endif
endfunction

" vim: set foldmethod=marker :
