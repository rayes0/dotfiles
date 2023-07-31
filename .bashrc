if [[ $- != *i* ]] ; then
	# Shell is non-interactive.  Be done now!
	return
fi

# aliases
alias l='ls'
alias sl='ls'
alias ls='ls --color=auto'
alias la='ls -A'
alias ll='ls -alF'
alias sudo='doas'

alias grep='grep --color=auto'
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history | tail -n 1 | sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')" "Command finished running"'

alias t='ping www.fedoraproject.org'
alias nfetch='curl --silent -L 'https://raw.githubusercontent.com/dylanaraps/neofetch/master/neofetch' | bash'
alias cfetch='curl --silent -L 'https://raw.githubusercontent.com/rayes0/scripts/main/cutefetch/cutefetch' | bash'

#alias mpv='flatpak run io.mpv.Mpv'
#alias mpvcomp='flatpak run io.mpv.Mpv --deband=no'

alias inhib='systemd-inhibit --what=handle-lid-switch sleep 1d'
alias kindlessh='ssh root@192.168.15.244'
function kindlecp() {
  rsync "$1" 'root@192.168.15.244:/mnt/us/'
}

alias fu='flatpak upgrade'
# alias dnu='doas dnf upgrade'
alias pu='doas nvim /etc/portage/package.use/custom'

alias vi='nvim'
alias vim='nvim'

# alias con-gif='convert "${1}" "${1%.*}.gif"'

# prompt
 if [ -z "${TMUX}" ]; then
 	PS1="\[$(tput setaf 3)\]• \[\e[3m\]\[$(tput setaf 4)\]\w \[\e[0m\]$ \[$(tput sgr0)\] "
 else
 	PS1="> \[$(tput setaf 3)\]• \[\e[3m\]\[$(tput setaf 4)\]\w \[\e[0m\]$ \[$(tput sgr0)\] "
 fi

# completion
[[ $PS1 && -f /usr/share/bash-completion/bash_completion ]] && \
    . /usr/share/bash-completion/bash_completion
complete -cf doas

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
	for rc in ~/.bashrc.d/*; do
		if [ -f "$rc" ]; then
			. "$rc"
		fi
	done
fi

unset rc

[ -f "/home/rayes/src/.ghcup/env" ] && source "/home/rayes/src/.ghcup/env" # ghcup-env

# . "/home/rayes/src/tools/cargo/env"

# set window title
if [[ $- =~ "i" ]]; then  # only run when interactive to stop breaking scp
  case $TERM in
    (rxvt*)
      trap 'printf "\033]0;urxvt > %s\007" "${BASH_COMMAND//[^[:print:]]/}"' DEBUG
      echo -ne "\033]0;urxvt\007" ;;
    (xterm*)
      trap 'printf "\033]0;%s\007" "${BASH_COMMAND//[^[:print:]]/}"' DEBUG
      PS1=$PS1'\[$(vterm_prompt_end)\]'
      echo -ne "\033]0;terminal\007" ;;
  esac
fi

