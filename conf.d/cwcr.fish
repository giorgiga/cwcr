if set -q WAYLAND_DISPLAY
    command -sq wl-copy wl-paste
    or echo 'cwcr: you need to install wl-clipboard'
else if set -q DISPLAY
    test (uname) = Darwin; or command -sq xclip; or command -sq xsel
    or echo 'cwcr: you need to install xclip and/or xsel'
end

function __cwcr

    set cmd
    switch $argv[1]
        case 'cw'; set cmd 'cw'
        case 'cr'; set cmd 'cr'
        case '*';  return 1
    end

    if set -q WAYLAND_DISPLAY
        switch $cmd
            case 'cw'; wl-copy -n
            case 'cr'; wl-paste
        end
    else if set -q DISPLAY
        if test (uname) = Darwin
            switch $cmd
                case 'cw'; __cwcr_trim_last_newline | pbcopy
                case 'cr'; pbpaste
            end
        else if command -sq xclip
            switch $cmd
                case 'cw'; xclip -i -selection clipboard -r
                case 'cr'; xclip -o -selection clipboard
            end
        else if command -sq xsel
            switch $cmd
                case 'cw'; __cwcr_trim_last_newline | xsel -i -b
                case 'cr'; xsel -o -b 2> /dev/null
            end
        end
    else
        set -q XDG_RUNTIME_DIR; and set dir $XDG_RUNTIME_DIR; or set dir "/tmp/$USER"
        mkdir -f $dir
        switch $cmd
            case 'cw'; __cwcr_trim_last_newline > $dir/cwcr
            case 'cr'; test -f $dir/cwcr; and cat $dir/cwcr
        end
    end
 
end

function __cwcr_trim_last_newline
    if command -sq perl
        command perl -p -e 'chomp if eof'
    else
        set lines
        while read -l line
            if string match -qr . -- $line
                set -a lines $line
            end
        end
        echo -n (string join \n $lines | string collect)
    end
end
