[ -f ~/.bashrc ] && source ~/.bashrc # get aliases and functions

if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
  PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

export HISTCONTROL=ignoreboth
shopt -s autocd
shopt -s cdspell
shopt -s histappend
shopt -s histverify
shopt -s checkwinsize
# complete -d cd

export GPG_TTY=$(tty)

# User specific environment and startup programs
[ -f ~/.config/user-dirs.dirs ] && . ~/.config/user-dirs.dirs
export XDG_DOWNLOAD_DIR
export XDG_DOCUMENTS_DIR
export XDG_MUSIC_DIR
export XDG_PICTURES_DIR
export XDG_VIDEOS_DIR
export XDG_DESKTOP_DIR
export XDG_PUBLICSHARE_DIR
export XDG_TEMPLATES_DIR

export GOPATH=~/src/tools/go

export CARGO_HOME=~/src/tools/cargo
export RUSTUP_HOME=~/src/tools/rustup
. "/home/rayes/src/tools/cargo/env"

[ -f "/home/rayes/.ghcup/env" ] && source "/home/rayes/.ghcup/env"


XMODIFIERS=@im=fcitx
GTK_IM_MODULE=fcitx
QT4_IM_MODULE=fcitx
QT_IM_MODULE=fcitx

# start services
# /home/rayes/.usersrv

[[ $(fgconsole 2>/dev/null) == 1 ]] && exec startx -- :1

