# Files will be created with these permissions:
# files 644 -rw-r--r-- (666 minus 022)
# dirs  755 drwxr-xr-x (777 minus 022)
umask 022

# Always use color output for `ls`
if is_osx; then
  alias ls="command ls -G"
else
  alias ls="command ls --color"
fi

alias grep='grep --color=auto'

# Directory listing
if [[ "$(type -P tree)" ]]; then
  alias ll='tree --dirsfirst -aLpughDFiC 1'
  alias lsd='ll -d'
else
  alias ll='ls -alF'
  alias la='ls -A'
  alias l='ls -CF'
  alias lsd='CLICOLOR_FORCE=1 ll | grep --color=never "^d"'
fi
