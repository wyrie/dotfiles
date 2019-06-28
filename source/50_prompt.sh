source "$HOME/bin/git-prompt.sh"

GIT_PS1_SHOWCOLORHINTS=1

red=$'\e[1;31m'
green=$'\e[32m'
yellow=$'\e[33m'
blue=$'\e[34m'
magenta=$'\e[35m'
cyan=$'\e[36m'
gray=$'\e[38;5;242m'
#gray=$'\e[30m'
end=$'\e[0m'

function nonzero_return() {
	RETVAL=$?
  [[ $RETVAL -ne 0 ]] && color="$red" || color="$green"
  printf "${color}$RETVAL${end}"
}

function _user() {
  [[ ${EUID} == 0 ]] && color="$red" || color="$yellow"
  printf "${color}${USER}${end}"
}

function _git_prompt() {
  shopt -s nocasematch
  local git_status="`git status -unormal 2>&1`"
  if ! [[ "$git_status" =~ Not\ a\ git\ repo ]]; then
    if [[ "$git_status" =~ nothing\ to\ commit ]]; then
      color="$green"
    elif [[ "$git_status" =~ nothing\ added\ to\ commit\ but\ untracked\ files\ present ]]; then
      color="$red"
    else
      color="$yellow"
    fi
     printf "${color}$(__git_ps1)${end}"
  fi
}

# outputs name and status of vagrant machine if passed path is child of a
# vagrant project
function vagrant_local_status() {
  # https://github.com/monochromegane/vagrant-global-status
  local VGS="vagrant-global-status"

  # note: a fully resolved path (no symlinks) is required because the path that
  # vagrant-global-status outputs also resolves symlinks.
  local TARGET_PATH=""

  # this function accepts a single (optional) argument, the path to check
  # against vagrant-global-status.
  if [ $# -lt 1 ]; then
    # resolve symlinks of current dir
    TARGET_PATH="`pwd -P`"

  # check to see if the passed dir exists
  elif [[ $# -eq 1 && -d $1 ]]; then
    # resolve symlinks of passed dir
    TARGET_PATH="$( cd $1 ; pwd -P )"
  else
    return 1
  fi

  # return immediately if we can't find the tool in $PATH
  if [ "`which $VGS`" = "" ]; then
    return 1
  fi

  # capture output of vagrant-global-status. we'll need to process it a few
  # more times later.
  local VAGRANT_STATUS="`$VGS`"

  # extract dir paths (5th col)
  local ALL_VM_PATHS=$(echo "$VAGRANT_STATUS" | awk '{ print $5 }')

  # holds the path to the VM (a parent of TARGET_PATH)
  local MATCHED_VM_PATH=""

  # attempt to match one one of the paths with TARGET_PATH
  for p in $ALL_VM_PATHS; do
    # test if TARGET_PATH is a child dir of a candidate path by attempting to
    # remove candidate path from begnning of TARGET_PATH, (re-)combining with
    # candiate path, and checking to see if it's identical to TARGET_PATH.
    if [ "${p}${TARGET_PATH##$p}" = "$TARGET_PATH" ]; then
      MATCHED_VM_PATH=$p
      break
    fi
  done

  # bail if we didn't match anything
  if [ "$MATCHED_VM_PATH" = "" ]; then
    # this is still considered a success
    return 0
  fi

  # holds entire status line(s). we'll process it later
  local MATCHED_VM=$(echo "$VAGRANT_STATUS" | grep $MATCHED_VM_PATH)

  # count the number of VMs we've matched, stripping out leading spaces from
  # wc output
  local NUM_VMS=$(echo $MATCHED_VM | wc -l | sed -e 's/ //g')

  # FIXME: no multi-machine vagrant right now.
  # https://docs.vagrantup.com/v2/multi-machine/
  if [ "${NUM_VMS}" = "1" ]; then
    # for the line that matches, get extract the desired status info
    local VM_NAME="$(echo $MATCHED_VM | awk '{ print $2}')"
    local VM_STATUS="$(echo $MATCHED_VM | awk '{ print $4}')"

    # FIXME: make output more succinct. need to account for all status values
    # (poweroff|running|saved|...)
    echo ${VM_NAME}:${VM_STATUS}
  fi

  return 0;
}

function _vagrant_prompt() {
   local vagrant_status="$(vagrant_local_status)"
   if [ "${vagrant_status}" != "" ]; then
     printf " [${vagrant_status}]"
   fi
}

function _prompt_command() {
  printf "\n$(nonzero_return) ${blue}$(date '+%H:%M:%S')  ${yellow}$(_user)  ${magenta}$(pwd)${end}$(_git_prompt) $(__docker_machine_ps1)${end}\n"
}

export PROMPT_COMMAND=_prompt_command
export PS1="\[${gray}\]ʎ \[${end}\]"
