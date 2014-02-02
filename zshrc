############
# ~/.zshrc #
############

# Permettre à less di lire plusieurs formats
#export LESSCHARSET=latin9
#eval $(lesspipe)

autoload -U zmv
autoload -U zcp
# Charge les couleurs
autoload -U colors
colors

autoload -Uz vcs_info

autoload -Uz compinit
compinit

autoload zargs

autoload -U tetris
zle -N tetris
bindkey £ tetris

zmodload zsh/complist

magic-abbrev-expand() {
    local MATCH
    LBUFFER=${LBUFFER%%(#m)[_a-zA-Z0-9]#}
    LBUFFER+=${abbreviations[$MATCH]:-$MATCH}
    zle self-insert
}

no-magic-abbrev-expand() {
  LBUFFER+=' '
}

auto-ls () {
  if [[ $#BUFFER -eq 0 ]]; then
      echo ""
      ls --color
      zle redisplay
  else
      zle .$WIDGET
  fi
}

zle -N auto-ls
zle -N accept-line auto-ls
zle -N other-widget auto-ls


zle -N magic-abbrev-expand
zle -N no-magic-abbrev-expand
bindkey " " magic-abbrev-expand
bindkey "^x " no-magic-abbrev-expand
#############################
# Configuration des options #
#############################

setopt AUTO_PUSHD PUSHDMINUS
setopt PUSHD_IGNORE_DUPS
setopt PUSHDSILENT PUSHDTOHOME
setopt AUTOCD # Faire un cd sans cd

#setopt printeightbit
#setopt CORRECTALL # correction des commandes
setopt COMPLETE_IN_WORD # Complétion à l'interieur d'un mot
setopt ALWAYS_TO_END # Positionne à la fin lors de la complétion
setopt APPENDHISTORY # Ajout les historiques
setopt NOTIFY # Notifie instantanément les fin de process
#setopt inc_append_history # Chaque ligne est ajoutée dans l'historique à mesure qu'elle est tapée
setopt EXTENDEDGLOB # Permet d utiliser le find de zsh
setopt NOHUP
# Pour avoir le même historique dans tous les shells
setopt INC_APPEND_HISTORY SHARE_HISTORY
# Mode verbose (date, ...) ; incompatible avec les autres shells
setopt EXTENDED_HISTORY

unsetopt HIST_VERIFY # Supprime la vérification lors de l usage de "!cmd"
unsetopt LIST_AMBIGUOUS # Modifie la manière dont est gérée l autocomplétement

# Supprime les  répétitions dans le fichier  d'historique, ne conservant
# que la dernière occurrence ajoutée
setopt HIST_IGNORE_ALL_DUPS

# La recherche dans  l historique avec l éditeur de commandes  de zsh ne
# montre  pas  une même  ligne  plus  d une fois,  même  si  elle a  été
# enregistrée
setopt HIST_FIND_NO_DUPS

# Permet d'utiliser des variables en prompt
setopt PROMPT_SUBST

# Gestion des raccourcis (emacs ou vi)
# les deux formes fonctionnent
set -o emacs
#bindkey -v

# Améliore les messages d auto-complètement
zstyle :compinstall filename '/home/michel/.zshrc'
zstyle ':completion:*:descriptions' format '%U%B%d%b%u'
zstyle ':completion:*:warnings' format '%BDésolé, rien de trouvé pour: %d%b'
zstyle ':completion:*:*:kill:*:processes' list-colors "=(#b) #([0-9]#)*=36=31"

#########################
## Définition du prompt #
#########################
export PROMPT='%{$fg[red]%}%n%{$reset_color%}@local %B%{$fg[blue]%}%~%b%{$reset_color%} ${vcs_info_msg_0_}%f%(?.. [%?])%# '
#export PROMPT='%{$fg[red]%}%n%{$reset_color%}@%M:%B%{$fg[blue]%}%~%b%{$reset_color%} ${vcs_info_msg_0_}%f%(?.. [%?])%# '
export RPROMPT="[%{$fg[green]%}%*%{$reset_color%}]"
export PS2='>'

################################
# Initialisation des variables #
################################

# Gestion de lhistorique
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=${HISTSIZE}

if [ -d ~/.bin ]; then
    export PATH="${HOME}/.bin:${PATH}"
fi

# Pas de coredump
limit coredumpsize 0

###################################
# Chargement des fichiers annexes #
###################################

# Alias
if [ -f ~/.zsh_aliases ]; then
  source ~/.zsh_aliases
fi

# Fonctions
if [ -f ~/.zsh_functions ]; then
  source ~/.zsh_functions
fi

# Permet d avoir la completion après la commande start
compdef _precommand start
compdef _precommand exec32

#export PAGER="/bin/sh -c \"unset PAGER;col -b -x | \\
#    vim -R -c 'set ft=man nomod nolist' -c 'map q :q<CR>' \
#    -c 'map <SPACE> <C-D>' -c 'map b <C-U>' \
#    -c 'nmap K :Man <C-R>=expand(\\\"<cword>\\\")<CR><CR>' -\""

# Permet d'avoir les man en couleur
export LESS_TERMCAP_mb=$'\E[01;31m'    # début de blink
export LESS_TERMCAP_md=$'\E[01;31m'    # début de gras
export LESS_TERMCAP_me=$'\E[0m'        # fin
export LESS_TERMCAP_so=$'\E[01;44;33m' # début de la ligne d`état
export LESS_TERMCAP_se=$'\E[0m'        # fin
export LESS_TERMCAP_us=$'\E[01;32m'    # début de souligné
export LESS_TERMCAP_ue=$'\E[0m'        # fin

export PAGER=less
export LESS="-FSRX"
export GREP_OPTIONS="--color=auto"

export LANG="fr_FR.UTF8"
export LC_CTYPE="fr_FR.UTF8"
export LC_MESSAGES="fr_FR.UTF8"
export LC_ALL="fr_FR.UTF8"

#export XDG_DATA_HOME="$XDG_DATA_DIRS:$HOME/.data"
export XDG_DATA_HOME="$HOME/.data"
export XDG_CONFIG_HOME="$HOME/.config/"
export XDG_CACHE_HOME="/tmp/${USER}-cache"

[[ -d "${XDG_CACHE_HOME}" ]] || mkdir -p "${XDG_CACHE_HOME}"

typeset -Ag abbreviations
abbreviations=(
  "Ia"    "| awk"
  "Ig"    "| grep"
  "Ip"    "| $PAGER"
  "Ih"    "| head"
  "It"    "| tail"
  "Is"    "| sort"
  "Iw"    "| wc"
)

source /usr/share/autojump/autojump.zsh

export EDITOR=vim

#export JAVA_HOME='/usr/lib/jvm/java-7-openjdk-amd64'
export JAVA_HOME='/usr/lib/jvm/java-6-openjdk-amd64'
export ANT_HOME='/produits/apache-ant-1.8.2'
#export JAVA_HOME='/produits/oracle_mw/jdk160_21'
export FIGNORE='.svn'

cdpath=( ~ ~/Documents ~/Projets )
export DIRSTACKSIZE=8
export MAVEN_OPTS="-Xmx256M -XX:MaxPermSize=256m"

export MW_HOME=/opt/wls1035_dev
export PEC_HOME="${HOME}/Projets/dgmepec"
hash -d pec="${HOME}/Projets/PEC"
hash -d tma="${HOME}/Documents/PEC/TMA"

export GOROOT="/opt/go"
export GOPATH="$HOME/go"
export PATH="$PATH:$GOPATH/bin:$GOROOT/bin"

#eval "$(fasd --init auto)"
#export _JAVA_AWT_WM_NONREPARENTING=1
#wmname LG3D
#export AWT_TOOLKIT='MToolkit'

export M2_HOME="/opt/apache-maven-3.0.3"

export ANSIBLE_HOSTS="${XDG_CONFIG_HOME}/ansible/ansible_hosts"
