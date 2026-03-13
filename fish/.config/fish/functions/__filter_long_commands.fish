function __filter_long_commands --on-event fish_preexec
    if test (string length -- "$argv") -gt 200
        builtin history delete -- "$argv"
    end
end
