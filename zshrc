# Filename:      /etc/zsh/zshrc
# Purpose:       setup file for the shell 'zsh'
# Author:        (c) Andreas Niederl <rico32@gmx.net>
# License:       This file is licensed under the GPL v2.
##############################################################################
#
# Zsh start up sequence (in this order):
#  1) /etc/zshenv   (login + interactive + other)
#  2)   ~/.zshenv   (login + interactive + other) [always, unless -f is specified]
#  3) /etc/zprofile (login)
#  4)   ~/.zprofile (login)
#  5) /etc/zshrc    (login + interactive) [interactive shells, unless -f is specified]
#  6)   ~/.zshrc    (login + interactive)
#  7) /etc/zlogin   (login)
#  8)   ~/.zlogin   (login)
# Upon termination:
#     .zlogout      (login)


# source GRML's zshrc {{{1
GRML_WARN_SKEL=0

[[ -r /etc/zsh/grml_zshrc ]]     && GRML_ZSHRC=/etc/zsh/grml_zshrc
[[ -r ${HOME}/.zsh/grml_zshrc ]] && GRML_ZSHRC=${HOME}/.zsh/grml_zshrc

[[ -n "${GRML_ZSHRC}" ]] && source ${GRML_ZSHRC}


# Gentoo specific {{{1
isgentoo() {
  [ -f /etc/gentoo-release ] && return 0
  return 1
}

# additional options {{{1
#===============================================================================

# don't substitute aliases on completion
setopt complete_aliases

# use % escape sequences in prompt
setopt prompt_percent

#===============================================================================


# customize key bindings {{{1
#===============================================================================
if [[ "$TERM" != emacs ]] ; then
	[[ -z "$terminfo[kdch1]" ]] || bindkey -M vicmd "$terminfo[kdch1]" delete-char
	[[ -z "$terminfo[cuu1]"  ]] || bindkey -M viins "$terminfo[cuu1]"  up-line-or-history
	[[ -z "$terminfo[kcuu1]" ]] || bindkey -M viins "$terminfo[kcuu1]" up-line-or-history
	[[ -z "$terminfo[kcud1]" ]] || bindkey -M viins "$terminfo[kcud1]" down-line-or-history
	# ncurses stuff:
	[[ "$terminfo[kcuu1]" == $'\eO'* ]] && bindkey -M viins "${terminfo[kcuu1]/O/[}" up-line-or-history
	[[ "$terminfo[kcud1]" == $'\eO'* ]] && bindkey -M viins "${terminfo[kcud1]/O/[}" down-line-or-history
fi


[[ "${EDITOR}" == *vim   ]]  && bindkey -v       #    vi keybindings
[[ "${EDITOR}" == *emacs ]]  && bindkey -e       # emacs keybindings

# incremental backward search
bindkey "^R"   history-incremental-search-backward

bindkey "\e[A" up-line-or-history
bindkey "\e[B" down-line-or-history

bindkey '\e[3~' delete-char             # Del
bindkey '\e[2~' overwrite-mode          # Insert


# map composite keys for home/end (laptop only?)
bindkey '\e[5~' beginning-of-line
bindkey '\e[6~' end-of-line

#===============================================================================


# directory hashes {{{1
#===============================================================================

if isgentoo ; then
  hash -d port=/usr/portage
  hash -d dist=/usr/portage/distfiles
  hash -d httpr=/var/cache/http-replicator
  hash -d eport=/etc/portage
  hash -d ekey=/etc/portage/package.keywords
  hash -d euse=/etc/portage/package.use
  hash -d emask=/etc/portage/package.mask
  hash -d overlay=/usr/local/portage/layman/private
fi

#===============================================================================


# aliases {{{1
#===============================================================================

alias ping='ping -c4'
alias diff='diff -u'

# let's be careful with those
alias rm="rm -i"
alias mv="mv -i"
alias cp="cp -i"

# always continue interrupted wgets
alias wget='wget -c'

# grep aliases
alias rgrep='grep -r'
alias pgrep='pgrep -l'

alias path='echo $PATH'

# strip comments and blank lines from config files for quoting
alias confcat="sed -e 's/#.*//;/^\s*$/d' "$@""

# for mailing lists which remail me my passwords
alias genpass='head -n10 /dev/urandom | uuencode -m - | head -n6 | tail -n5'

alias g='git'
compdef g=git

# screen
alias rscreen='screen -D -R'

# remind
alias week='rem -c+1'
alias month='rem -c'

# synergy
alias syserver='killall -9 --quiet synergys ; sleep 1 ; synergys -a localhost && ssh -f -N -o ControlPath=none syn_ares'
alias syclient='killall -9 --quiet synergyc ; sleep 1 ; synergyc localhost'

# gentoo {{{2
#-------------------------------------------------------------------------------
if isgentoo ; then
	alias emerge='emerge -av'
	alias uemerge='emerge -uvND'
	compdef _portage uemerge=emerge

	alias smerge='emerge --update --reinstall changed-use --ask @system'
	alias wmerge='emerge --update --deep --reinstall changed-use --ask --with-bdeps y @world'
fi
#-------------------------------------------------------------------------------

# colorful terminal {{{2
#-------------------------------------------------------------------------------

# use nicer clones for df and top
[ -x /usr/bin/pydf ] && alias df='/usr/bin/pydf'  || alias df='df -h'
[ -x /usr/bin/htop ] && alias top='/usr/bin/htop'

# use the generic colouriser (grc) if available
if [[ "$TERM" != dumb ]] && [[ -x /usr/bin/grc ]] ; then
    alias cl='/usr/bin/grc -es --colour=auto'

    alias configure='cl ./configure'
    alias diff='cl diff -u'
    alias make='cl make'
    alias gcc='cl gcc'
    alias g++='cl g++'
    alias as='cl as'
    alias gas='cl gas'
    alias ld='cl ld'
    alias netstat='cl netstat'
    alias ping='cl ping -c4'
    alias traceroute='cl traceroute'
    alias cvs='cl cvs'
    alias hg='cl hg'
    alias svn='cl svn'
fi

#===============================================================================


# additional completion settings {{{1
#===============================================================================
# nicer process completion
zstyle ':completion:*:processes' command ps --forest -u $EUID -o pid,cmd
zstyle ':completion:*:processes' insert-ids menu yes select
zstyle ':completion:*:*:(kill|killall|wait):*' tag-order 'jobs processes'
zstyle ':completion:*:*:(kill|killall|wait):*' group-order jobs

# colors for completion list
zstyle ':completion:*:default'          list-colors 'tc=35' 'ma=41;37' 'st=43;36' 'di=31;1' 'ex=33;1' 'ln=32' '*CVS=35' '*rej=31;1' '*orig=35'
zstyle ':completion:*:processes'        list-colors '=(#b)( #[0-9]#)[^[/0-9a-zA-Z]#(*)=34=37;1=30;1'
zstyle ':completion:*:parameters'       list-colors '=_*=33' '=[^a-zA-Z]*=31'
zstyle ':completion:*:functions'        list-colors '=_*=33' '=*-*=31'
zstyle ':completion:*:original'         list-colors '=*=31;1'
zstyle ':completion:*:all-expansions'   list-colors '=*=32'
zstyle ':completion:*:reserved-words'   list-colors '=*=31'
zstyle ':completion:*:(jobs|directory-stack|indexes)' list-colors '=(#b)(*) -- (*)=35;1=31;1=33;1'
zstyle ':completion:*:(options|values)' list-colors '=(#b)(*)-- (*)=35;1=31;1=33;1' '=*=31;1'
zstyle ':completion:*::lp*:jobs'        list-colors '=(#b)* [0-9] ##([^     ]##) ##([^      ]##) ##([^      ]##) ##(*)=35=32=31;1=33;1=32'

#===============================================================================


# screen + ssh-agent {{{1
#===============================================================================

if [[ "$TERM" = "screen" ]] ; then
  # remove dead sessions
  screen -lists | grep -i '(dead' > /dev/null && screen -wipe > /dev/null
fi


# setup ssh agent socket
if [[ -n "${SSH_AUTH_SOCK}" ]] && \
   [[ -z "${STY}" ]] && \
   [[ ! -e "$(readlink -f ${HOME}/.ssh/sockets/agent-socket)" ]]
then
  local agent_sock=${HOME}/.ssh/sockets/agent-socket
  rm -f ${agent_sock}
  ln -s ${SSH_AUTH_SOCK} ${agent_sock}
fi

#===============================================================================


# functions {{{1
#===============================================================================

# pdflatex + bibtex fu {{{2
#-------------------------------------------------------------------------------
blatex() {
        local doc="${1}"
        local doc_base="${1%.tex}"

        pdflatex "${doc}"      && \
        bibtex   "${doc_base}" && \
        pdflatex "${doc}"      && \
        pdflatex "${doc}"      && \
        "${DOC_VIEWER}" "${doc_base}".pdf &
}
compdef _tex blatex=pdflatex
#-------------------------------------------------------------------------------

# gentoo {{{2
#-------------------------------------------------------------------------------
if isgentoo ; then
	emanifest() {
		GENTOO_MIRRORS="" ebuild ${1} manifest
	}
fi
#-------------------------------------------------------------------------------

# currency exchange {{{2
#-------------------------------------------------------------------------------
# calculate EUR prices for UK prices and add VAT
EXC_POUND_EURO=1.3636
uk() {
  echo $((($1 + $1 * 0.2 ) * ${EXC_POUND_EURO}))
}
#-------------------------------------------------------------------------------

# chmod {{{2
#-------------------------------------------------------------------------------
sanitize-file-mode() {
  if [[ "${1}" == "-r" ]] ; then
    for i in $(find "${2}" -type d) ; do
      chmod 755 "${i}"
    done
    for i in $(find "${2}" -type f) ; do
      chmod 644 "${i}"
    done
  else
    [[ -d "${1}" ]] && chmod 755 "${1}"
    [[ -f "${1}" ]] && chmod 644 "${1}"
  fi
}
#-------------------------------------------------------------------------------

# temporary directory {{{2
#-------------------------------------------------------------------------------
# http://www.splitbrain.org/blog/2008-02/27-keeping_your_home_directory_organized
export TD="$HOME/tmp/`date +'%Y-%m'`"
td(){
  local td=$TD
  if [ ! -z "$1" ]; then
    td="$HOME/tmp/`date -d "$1 days" +'%Y-%m-%d'`";
  fi
  mkdir -p $td; cd $td
}
#-------------------------------------------------------------------------------


# popd + rm $olddir {{{2
rmpop() {
  local oldpwd=$(pwd)
  popd -q
  rm -rf ${oldpwd}
}


# switches CRT output on/off on my laptop {{{2
#-------------------------------------------------------------------------------
beamer() {
  if [[ "${1}" == "on" ]] ; then
    xrandr --output LVDS --mode 1024x768 --rate 60.0
    xrandr --output VGA  --mode 1024x768 --rate 60.0
  elif [[ "${1}" == "off" ]] ; then
    xrandr --output VGA  --off
    xrandr --output LVDS --mode 1440x900 --rate 60.2
  else
    echo "Usage: ${0} on|off"
    echo ""
  fi
}
#-------------------------------------------------------------------------------


# small dvd burn function including per file checksums {{{2
#-------------------------------------------------------------------------------
growisofs_opts="-Z /dev/dvd -dvd-compat"
mkisofs_opts="-iso-level 3 -J -r -udf"
burn_mountpoint="/cdrom"
burn() {
  local files= volid= chksum="MD5SUM"

  if [[ ${1} == -V ]] ; then
    volid=${2}
    shift 2
  fi
  files=(${@})

  cfv -C -t md5 -f ${chksum} ${files}
  echo "growisofs ${growisofs_opts} ${mkisofs_opts} ${volid:+-V ${volid}} ${files} ${chksum}"
  growisofs ${(z)growisofs_opts} ${(z)mkisofs_opts} ${volid:+-V ${volid}} ${files} ${chksum}

  mount ${burn_mountpoint}
  pushd -q ${burn_mountpoint}
  cfv -f ${chksum}
  popd -q
  umount ${burn_mountpoint}

  command rm -f ${chksum}
}
#-------------------------------------------------------------------------------
#===============================================================================


# terminal {{{1
#===============================================================================

# Stop Ctrl+S and Ctrl+Q from being annoying
stty start ""
stty stop ""

#===============================================================================


# prompt {{{1
#===============================================================================

# set up my gentoo prompt
autoload -U promptinit
promptinit && prompt gentoo

#===============================================================================


## END OF FILE #################################################################
# vim:foldmethod=marker
