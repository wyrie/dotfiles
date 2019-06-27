# History settings

# Allow use to re-edit a faild history substitution.
shopt -s histreedit
# History expansions will be verified before execution.
shopt -s histverify
# Append to the history file, don't overwrite it
shopt -s histappend
# Entries beginning with space aren't added into history, and duplicate
# entries will be erased (leaving the most recent entry).
export HISTCONTROL="ignoreboth"
# Lots o' history.
export HISTSIZE=1000000
export HISTFILESIZE=2000000

