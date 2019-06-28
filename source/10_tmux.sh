# Start new tmux session or reattach to an existing session, but only if not
# already inside a tmux session.
function tm() {
  local is_source=; [[ "$1" == "SOURCE" ]] && is_source=1 && shift
  local tmux_no_logout=~/.dotfiles/caches/tmux-no-logout
  if [[ ! "$TMUX" ]]; then
    # Clean up any orphaned "no logout" file.
    [[ -e $tmux_no_logout ]] && rm $tmux_no_logout
    # Actually start tmux.
    tmux ls >/dev/null 2>&1 && tmux attach "$@" || tmux "$@"
    # If "no logout" doesn't exist, exit.
    [[ -e $tmux_no_logout ]] && rm $tmux_no_logout || exit
  elif [[ ! "$is_source" ]]; then
    echo "Already in a tmux session!"
  fi
}

# Start tmux now (at login), but only if in a login shell and not already
# started (and possibly detached) in this shell.
if shopt -q login_shell && [[ ! "$TMUX_AUTO_STARTED" ]]; then
  TMUX_AUTO_STARTED=1
  # tm SOURCE
fi

# Run an arbitrary command in the current tmux window (if only one pane)
# otherwise create a new window and run the command there.
function run_in_fresh_tmux_window() {
  local panes="$(tmux list-panes | wc -l)"
  if [[ "$panes" != 1 ]]; then
    tmux new-window "bash --rcfile <(echo '. ~/.bashrc; $*')"
  else
    "$@"
  fi
}

