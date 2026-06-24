function e --description 'Open editor with fzf or file'
    argparse h/help -- $argv
    or return

    if set -q _flag_help
        echo "Usage: e [+LINE] [FILE]"
        echo "Open FILE in \$EDITOR. If FILE is omitted, use fzf to select one."
        echo ""
        echo "Options:"
        echo "  -h, --help  Show this help"
        return 0
    end

    set -l argc (count $argv)
    if test $argc -gt 1
        if string match -q '+*' -- $argv[1]
            $EDITOR $argv[1] $argv[2]
        else
            echo "multiple args currently unsupported"
        end
    else
        if test $argc -eq 0; or test -z "$argv[1]"
            fzf --bind "enter:become($EDITOR {+})"
        else
            $EDITOR $argv[1]
        end
    end
end
