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
            case 'cw'; command -sq wl-copy;  and wl-copy -n
            case 'cr'; command -sq wl-paste; and wl-paste
        end
    else if set -q DISPLAY
        if test (uname) = Darwin
            switch $cmd
                case 'cw'; command -sq pbcopy;  and perl -p -e 'chomp if eof' | pbcopy
                case 'cr'; command -sq pbpaste; and pbpaste
            end
        else if command -sq xclip
            switch $cmd
                case 'cw'; xclip -i -selection clipboard -r
                case 'cr'; xclip -o -selection clipboard
            end
        else if command -sq xsel
            switch $cmd
                case 'cw'; perl -p -e 'chomp if eof' | xsel -i -b
                case 'cr'; xsel -o -b 2> /dev/null
            end
        end
    else
        set -q XDG_RUNTIME_DIR; and set dir $XDG_RUNTIME_DIR; or set dir "/tmp/$USER"
        mkdir -f $dir
        switch $cmd
            case 'cw'; perl -p -e 'chomp if eof' > $dir/cwcr
            case 'cr'; test -f $dir/cwcr; and cat $dir/cwcr
        end
    end
 
end
