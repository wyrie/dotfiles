# Editing

export EDITOR=vim

# If mvim is installed, use it instead of native vim
if [[ "$(which mvim)" ]]; then
    EDITOR="mvim -v"
    alias vim="$EDITOR"
fi

export VISUAL="$EDITOR"
