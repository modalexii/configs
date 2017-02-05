# ~/.bashrc: executed by bash(1) for non-login shells.

# If not running interactively, don"t do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don"t put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth

# append to the history file, don"t overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=250
HISTFILESIZE=200

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls="ls --color=auto"
    #alias dir="dir --color=auto"
    #alias vdir="vdir --color=auto"

    alias grep="grep --color=auto"
    alias fgrep="fgrep --color=auto"
    alias egrep="egrep --color=auto"
fi

# coloRED GCC warnings and errors
export GCC_COLORS="error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01"

# Alias definitions.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don"t need to enable
# this, if it"s already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

export VISUAL=vi
export EDITOR="$VISUAL"

set_prompt () {
  LASTEXIT=$? # Must come first!

  # Intense Colors
  BLACK="\[\e[1;30m\]"
  RED="\[\e[1;31m\]"
  GREEN="\[\e[1;32m\]"
  YELLOW="\[\e[1;33m\]"
  BLUE="\[\e[1;34m\]"
  PURPLE="\[\e[1;35m\]"
  CYAN="\[\e[1;36m\]"
  WHITE="\[\e[1;37m\]"

  # Bold+Intense
  BIBLACK="\[\e[1;90m\]"
  BIRED="\[\e[1;91m\]"
  BIGREEN="\[\e[1;92m\]"
  BIYELLOW="\[\e[1;93m\]"
  BIBLUE="\[\e[1;94m\]"
  BIPURPLE="\[\e[1;95m\]"
  BICYAN="\[\e[1;96m\]"
  BIWHITE="\[\e[1;97m\]"

  RESET="\[\e[0m\]"

  X=$(echo -e "\u2717")
  RADIOACTIVE=$(echo -e "\u2622")
  HDD=$(echo -e "\u26c1")

  MEMFREE=$(free | grep Mem | awk '{print $3/$2 * 100.0}')

  # You will want to update these device names
  HDDFREE=$(df -k | grep -e hgfs -e sda | awk '{print substr($5,0,length($5)-1)}')

  if [ $LASTEXIT -ne 0 ]; then
    EXITSPEC="$BIRED$X$LASTEXIT "
  else
    EXITSPEC=""
  fi

  if (( $(bc <<< "$MEMFREE<10") == 1 )); then
    MEMWARN="$BIRED$RADIOACTIVE "
  else
    MEMWARN=""
  fi

  for d in $HDDFREE; do
    if [[ "$d" -lt "15" ]]; then
      HDDWARN="$BIRED$HDD "
      break
    else
      HDDWARN=""
    fi
  done

  PS1="$YELLOW\u$PURPLE@$YELLOW\h $MEMWARN$HDDWARN$EXITSPEC$CYAN\w $YELLOW\$$RESET " 
}

PROMPT_COMMAND="set_prompt"

