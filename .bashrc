alias pear="php /usr/lib/php/pear/pearcmd.php"
alias pecl="php /usr/lib/php/pear/peclcmd.php"

eval $(thefuck --alias)

if [[ $- == *i* ]] ; then
  export IS_INTERACTIVE=true
else
  export IS_INTERACTIVE=false
fi

if [[ -z $SSH_CONNECTION ]]; then
  export IS_REMOTE=false
else
  export IS_REMOTE=true
fi



# Colors ----------------------------------------------------------
export TERM=xterm-color
export GREP_OPTIONS='--color=auto' GREP_COLOR='1;32'
export CLICOLOR=1 

if [ "$OS" = "linux" ] ; then
  alias ls='ls --color=auto' # For linux, etc
  # ls colors, see: http://www.linux-sxs.org/housekeeping/lscolors.html
  export LS_COLORS='di=1:fi=0:ln=31:pi=5:so=5:bd=5:cd=5:or=31:mi=0:ex=35:*.rb=90'  #LS_COLORS is not supported by the default ls command in OS-X
else
  alias ls='ls -G'  # OS-X SPECIFIC - the -G command in OS-X is for colors, in Linux it's no groups
fi

# Setup some colors to use later in interactive shell or scripts
export COLOR_NC='\033[0m' # No Color
export COLOR_WHITE='\033[1;37m'
export COLOR_BLACK='\033[0;30m'
export COLOR_BLUE='\033[0;34m'
export COLOR_LIGHT_BLUE='\033[1;34m'
export COLOR_GREEN='\033[0;32m'
export COLOR_LIGHT_GREEN='\033[1;32m'
export COLOR_CYAN='\033[0;36m'
export COLOR_LIGHT_CYAN='\033[1;36m'
export COLOR_RED='\033[0;31m'
export COLOR_LIGHT_RED='\033[1;31m'
export COLOR_PURPLE='\033[0;35m'
export COLOR_LIGHT_PURPLE='\033[1;35m'
export COLOR_BROWN='\033[0;33m'
export COLOR_YELLOW='\033[1;33m'
export COLOR_GRAY='\033[1;30m'
export COLOR_LIGHT_GRAY='\033[0;37m'
alias colorslist="set | egrep 'COLOR_\w*'"  # lists all the colors



# History ----------------------------------------------------------
export HISTCONTROL=ignoredups
#export HISTCONTROL=erasedups
export HISTFILESIZE=3000
export HISTIGNORE="ls:cd:[bf]g:exit:..:...:ll:lla"
alias h=history
hf(){ 
  grep "$@" ~/.bash_history
}



if [ $IS_INTERACTIVE = 'true' ] ; then # Interactive shell only

  # Input stuff -------------------------------------------------------
  bind "set completion-ignore-case on" # note: bind used instead of sticking these in .inputrc
  bind "set show-all-if-ambiguous On" # show list automatically, without double tab
  bind "set bell-style none" # no bell

  # Use vi command mode
  #bind "set editing-mode vi"
  #set -o vi
  #bind -m vi-command -r 'v'

  shopt -s checkwinsize # After each command, checks the windows size and changes lines and columns



  # Completion -------------------------------------------------------

  # Turn on advanced bash completion if the file exists 
  # Get it here: http://www.caliban.org/bash/index.shtml#completion) or 
  # on OSX: sudo port install bash-completion
  if [ -f /etc/bash_completion ]; then
      . /etc/bash_completion
  fi
  if [ -f /opt/local/etc/bash_completion ]; then
    . /opt/local/etc/bash_completion
  fi
  if [ -f /usr/local/etc/bash_completion ]; then
    . /usr/local/etc/bash_completion
  fi

  # git completion
  source ~/bin/git-completion.bash
  # git prompt
  source ~/bin/gitprompt.sh

  # Add completion to source and .
  complete -F _command source 
  complete -F _command .

  complete -c aws_completer aws

  # Prompts ----------------------------------------------------------
  #git_dirty_flag() {
    #git status 2> /dev/null | grep -c : | awk '{if ($1 > 0) print "⚡"}'
  #}

# following not used/moved to gitprompt.sh
  prompt_func() {
      previous_return_value=$?;
      if [ $IS_REMOTE = 'true' ] ; then
        prompt="\n\[\033]0;${USER} ${PWD}\007\]\[${COLOR_PURPLE}\]\w \[${COLOR_GRAY}\]${USER}@${HOSTNAME%%.*}$(__git_ps1)\[${COLOR_NC}\]\n"
      else
        prompt="\n\[\033]0;${USER} ${PWD}\007\]\[${COLOR_GREEN}\]\w \[${COLOR_GRAY}\]${USER}@${HOSTNAME%%.*}$(__git_ps1)\[${COLOR_NC}\]\n"
      fi
      #prompt="\033]0;${PWD}\007\[${COLOR_GREEN}\]\w\[${COLOR_GRAY}\]$(__git_ps1)\[${COLOR_NC}\] "
      #prompt="\[${COLOR_GREEN}\]\w\[${COLOR_GRAY}\]$(__git_ps1)\[${COLOR_YELLOW}\]$(git_dirty_flag)\[${COLOR_NC}\] "

      if test $previous_return_value -eq 0
      then
          PS1="${prompt}> "
      else
          PS1="${prompt}\[${COLOR_RED}\]> \[${COLOR_NC}\]"
      fi
  }
#  PROMPT_COMMAND=prompt_func

  # export PS1="\[${COLOR_GREEN}\]\w\[${COLOR_NC}\] > "  # Primary prompt with only a path
  # export PS1="\[${COLOR_RED}\]\w > \[${COLOR_NC}\]"  # Primary prompt with only a path, for root, need condition to use this for root
  # export PS1="\[${COLOR_GRAY}\]\u@\h \[${COLOR_GREEN}\]\w > \[${COLOR_NC}\]"  # Primary prompt with user, host, and path 
  # This runs before the prompt and sets the title of the xterm* window.  If you set the title in the prompt
  # weird wrapping errors occur on some systems, so this method is superior
  #export PROMPT_COMMAND='echo -ne "\033]0;${PWD##*/} ${USER}@${HOSTNAME%%.*}"; echo -ne "\007"'  # user@host path

  export PS2='> '    # Secondary prompt
  export PS3='#? '   # Prompt 3
  export PS4='+'     # Prompt 4

  function xtitle {  # change the title of your xterm* window
    unset PROMPT_COMMAND
    echo -ne "\033]0;$1\007"
  }

fi



# Navigation -------------------------------------------------------
alias ..='cd ..'
alias ...='cd .. ; cd ..'
cl() { cd $1; ls -la; } 

source ~/bin/bashmarks.sh



# Editors ----------------------------------------------------------
#export EDITOR='mate -w'  # OS-X SPECIFIC - TextMate, w is to wait for TextMate window to close
#export EDITOR='gedit'  #Linux/gnome
export EDITOR='vim'  #Command line
export GIT_EDITOR='vim'
#alias gvim='/Applications/MacVim.app/Contents/MacOS/vim -g'

if [ "$OS" = "darwin" ] ; then
  alias v=mvim
  alias vc=vim
  alias vt='mvim --remote-tab'
else
  alias v=vim
fi



# Security ---------------------------------------------------------

# Folder shared by a group
# chmod g+s directory 
#find /foo -type f -print | xargs chmod g+rw,o-rwx,u+rw
#find /foo -type d -print | xargs chmod g+rwxs,o-rwx,u+rwx

# this might work just the same (not tested)
# chmod -R g+rwXs,o-rwx,u+rwX /foo



# Sluething----------------------------------------------------
findportuser() {
    lsof -i :"$1"
}

findhosts(){
  nmap -sP -n -oG - "$1"/24 | grep "Up" | awk '{print $2}' -
  echo "To scan those do: nmap $1-254" 
  echo "To scan and OS detect those do: sudo nmap -O $1-254" 
  echo "To intensly scan one do: sudo nmap -sV -vv -PN $1"
}

monitor_traffic(){
  # install ngrep with sudo port install ngrep
  sudo ngrep -W byline -qld en1 "$1" 
}

find_large_files(){
  find . -type f -size +50000k -exec ls -lh {} \; | awk '{ print $9 ": " $5 }'
}


# Other aliases ----------------------------------------------------
alias ll='ls -hl'
alias la='ls -a'
alias lla='ls -lah'

# Search
# Use ack for grepping and find if ack is available
# sudo port install p5-app-ack
if type -P ack &>/dev/null ; then 
  g(){
    ack "$*" --all-types --color-match=green --color-filename=blue --smart-case
  }
  grb(){
    ack "$*" --type=ruby --color-match=green --color-filename=blue --smart-case
  }
  gw(){
    ack "$*" --all-types --color-match=green --color-filename=blue --word-regexp --smart-case
  }
  gnolog(){
    ack "$*" --all-types --ignore-dir=log --color-match=green --color-filename=blue --smart-case
  }
  f(){
    ack -i -g ".*$*[^\/]*$" | highlight blue ".*/" green "$*[^/]"
  }
else
  g(){
    grep -Rin $1 *
  }
  f(){
    find . -iname "$1"
  }
fi


find_replace_log_changes(){
  find . -type f | xargs grep -n "$1" | tee files_changed.txt | sed 's/:.*$//' | xargs sed -i "s/$1/$2/g"
}


# Misc
alias reloadbash='source ~/.bash_profile'

alias ducks='du -cksh * | sort -rn|head -11' # Lists folders and files sizes in the current folder
alias bigfilesandfolders='du -hsx * | sort -rh | head -20'
alias m='more'
alias top='top -o cpu' # os x:

alias df='df -h' # Show disk usage

if [ "$OS" = "linux" ] ; then
  alias psaux='ps -AFH'
else
  alias psaux='ps aux'
fi
psgrep(){
  psaux | egrep "$1" | egrep -v "grep|highlight" | highlight green "$1"
}

if [ "$OS" = "linux" ] ; then
  alias systail='tail -f /var/log/syslog'
else
  alias systail='tail -f /var/log/system.log'
fi

# Shows most used commands, cool script I got this from: http://lifehacker.com/software/how-to/turbocharge-your-terminal-274317.php
alias profileme="history | awk '{print \$2}' | awk 'BEGIN{FS=\"|\"}{print \$1}' | sort | uniq -c | sort -n | tail -n 20 | sort -nr"

alias untar="tar xvzf"

alias cp_folder="cp -Rpv" #copies folder and all sub files and folders, preserving security and dates

alias mirror_website="wget -m -x -p --convert-links --no-host-directories --no-cache -erobots=off"

killhard() {
    kill -9 "$1"
}



# Ruby ----------------------------------------------------

# RVM
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" 

# Fixes problems with sending email in ruby
#export RUBYOPT="-r openssl"

# Spin: gem install spin kicker
alias spin="spin serve -Itest | highlight red ' [1-9]0* failures' purple '[_a-zA-Z0-9]*\.rb.[0-9]*' red 'Error:' red 'Failure:' red ' [1-9]0* errors' green ' 0 errors' green ' 0 failures'"
alias spin_kicker="kicker -r rails -b 'spin push'"



# Bring in the other files ----------------------------------------------------
if [ $IS_INTERACTIVE = 'true' ] ; then
  source ~/.bashrc_help

  source ~/bin/mq/mq.sh # MySQL tools
  source ~/bin/rr/rr.sh # Rails tools
  source ~/bin/gt/gt.sh # Git tools
  #source ~/bin/be/be.sh # Bundle exec
  source ~/bin/sv/sv.sh # SVN tools
fi

if [ -f ~/.bashrc_local ]; then
  source ~/.bashrc_local
fi



# Test ------------------------------------------------------------------------ 

#if [ "$OS" = "linux" ] ; then
#elif
#else
#fi

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting

#export MAVEN_OPTS="-XX:MaxPermSize=378M"

export GIT_MERGE_AUTOEDIT=no
eval $(thefuck --alias)

tlscli() {
	openssl s_client -connect $1:443 -servername $1 "${@:2}"
}
alias scli=tlscli


# Add GO items
export PATH=$PATH:/usr/local/opt/go/libexec/bin

