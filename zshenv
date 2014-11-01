# Filename:      /etc/zsh/zshenv
# Purpose:       setup file for the shell 'zsh'
# Author:        (c) Andreas Niederl <rico32@gmx.net>
# License:       This file is licensed under the GPL v2.
##############################################################################


#===============================================================================
# gentoo profile.env {{{1
#===============================================================================

if [[ -r /etc/gentoo-release ]] ; then
  [[ -r /etc/profile.env ]] && source /etc/profile.env
else
	# we have to assume $ROOTPATH isn't set
	ROOTPATH=${PATH}
fi

#===============================================================================
# $PATH {{{1
#===============================================================================

if (( EUID == 0 )); then
	export PATH="/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin:${ROOTPATH}"
else
	export PATH="${HOME}/bin:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:${PATH}"
fi
unset ROOTPATH

#===============================================================================
# zsh regular check settings {{{1
#===============================================================================

#export MAIL=${MAIL:-${HOME}/.maildir}
export MAIL=${HOME}/.maildir
mailpath=(${mailpath:-$MAIL/new})
# check every 30 seconds for new mail
MAILCHECK=${MAILCHECK:-30}

# watch login records for everyone but me
watch=(${watch:-notme})

#===============================================================================
# environment variables {{{1
#===============================================================================

export TMPPREFIX=${TPMPREFIX:-$HOME/tmp}
export INPUTRC=${INPUTRC:-$HOME/.inputrc}
export CCACHE_DIR=${CCACHE_DIR:-$HOME/.ccache}

export EDITOR=${EDITOR:-/usr/bin/vim}
export BROWSER=${BROWSER:-/usr/bin/firefox}

export PAGER=${PAGER:-less}

# custom /etc/screenrc
export SYSSCREENRC=${SYSSCREENRC:-/etc/screen/screenrc}

#-------------------------------------------------------------------------------
# ack {{{2
#-------------------------------------------------------------------------------

# use a pager
export ACK_PAGER="less"
export ACK_PAGER_COLOR="less -R"

# custom colors
export ACK_COLOR_MATCH="black on_cyan"
export ACK_COLOR_LINENO="yellow on_black"

#-------------------------------------------------------------------------------
# lesspipe {{{2
#-------------------------------------------------------------------------------
if [[ -x /usr/bin/lesspipe.sh ]] ; then
    export LESSOPEN="|lesspipe.sh %s"
elif [[ -x /usr/bin/lesspipe ]] ; then
    export LESSOPEN="|lesspipe %s"
fi

#-------------------------------------------------------------------------------
# texdoc {{{2
#-------------------------------------------------------------------------------

export DOC_VIEWER=${DOC_VIEWER:-/usr/bin/evince}

export DVI_VIEWER=" ${DVI_VIEWER:- ${DOC_VIEWER}}"
export PDF_VIEWER=" ${PDF_VIEWER:- ${DOC_VIEWER}}"
export PS_VIEWER="  ${PS_VIEWER:-  ${DOC_VIEWER}}"
export HTML_VIEWER="${HTML_VIEWER:-${BROWSER}}"

export TEXDOCVIEW_dvi=" ${DVI_VIEWER}  %s"
export TEXDOCVIEW_pdf=" ${PDF_VIEWER}  %s"
export TEXDOCVIEW_ps="  ${PS_VIEWER}   %s"
export TEXDOCVIEW_html="${HTML_VIEWER} %s"

#-------------------------------------------------------------------------------
# zsh vars {{{2
#-------------------------------------------------------------------------------

[[ -d /etc/zsh/functions ]] && export FPATH=/etc/zsh/functions:$FPATH

export ZSHDIR=$HOME/.zsh

# for custom functions
[[ -d $ZSHDIR/functions  ]] && export FPATH=$ZSHDIR/functions:$FPATH

# automatically remove duplicates from these arrays
typeset -U path cdpath fpath manpath

#===============================================================================

shopts=$-
setopt nullglob
for sh in /etc/profile.d/*.sh ; do
       [ -r "$sh" ] && . "$sh"
done
unsetopt nullglob
set -$shopts
unset sh shopts


