" Commands

" LogEvents              - toggle logging    {{{1

""
" Toggle logging of events.
command -nargs=0 LogEvents
            \ call dn#logevents#_toggle()

" EventLoggingStatus     - display event logging status    {{{1

""
" Get status of event logging, i.e., whether it is enabled or not, and display
" the log file path.
command -nargs=0 EventLoggingStatus
            \ call dn#logevents#_status()

" EventLogFile {path}    - set event log file path    {{{1

""
" Log future events and notes to file {path}.
"
" If {path} is the name of the current log file, the command will have no
" effect. If the plugin is currently logging to a different file, that file is
" closed and the new log file opened.
"
" If the {path} is invalid or unwritable an error will occur when the plugin
" next attempts to write to the log. If logging is enabled when this command
" is used, the plugin tries to write to the file immediately with a
" timestamped message recording the time of logging activation.
command -complete=file -nargs=1 EventLogFile
            \ call dn#logevents#_logfile(<q-args>)

" AnnotateEventLog {msg} - write message to log    {{{1

""
" Write {message} to the log file on its own line.
command -nargs=1 AnnotateEventLog
            \ call dn#logevents#_annotate(<q-args>)

" DeleteEventLog         - delete log file    {{{1

""
" Delete log file if it exists.
command -nargs=0 DeleteEventLog
            \ call dn#logevents#_delete()
" }}}1

" vim: set foldmethod=marker :
