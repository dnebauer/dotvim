" Commands

" LogAutocmds               - toggle logging    {{{1

""
" Toggle logging of autocmd events.
command -nargs=0 LogAutocmds
            \ call dn#log_autocmds#_toggle()

" AutocmdsLoggingStatus     - display logging status    {{{1

""
" Get status of autocmd event logging, i.e., whether it is enabled or not, and
" display the log file path.
command -nargs=0 AutocmdsLoggingStatus
            \ call dn#log_autocmds#_status()

" AutocmdsLogFile {path}    - set autocmd log file path    {{{1

""
" Log future autocmd events and notes to file {path}.
"
" If {path} is the name of the current log file, the command will have no
" effect. If the plugin is currently logging to a different file, that file is
" closed and the new log file opened.
"
" If the {path} is invalid or unwritable an error will occur when the plugin
" next attempts to write to the log. If logging is enabled when this command
" is used, the plugin tries to write to the file immediately with a
" timestamped message recording the time of logging activation.
command -complete=file -nargs=1 AutocmdsLogFile
            \ call dn#log_autocmds#_logfile(<q-args>)

" AnnotateAutocmdsLog {msg} - write message to log    {{{1

""
" Write {message} to the log file on its own line.
command -nargs=1 AnnotateAutocmdsLog
            \ call dn#log_autocmds#_annotate(<q-args>)

" DeleteAutocmdsLog         - delete log file    {{{1

""
" Delete log file if it exists.
command -nargs=0 DeleteAutocmdsLog
            \ call dn#log_autocmds#_delete()
" }}}1

" vim: set foldmethod=marker :
