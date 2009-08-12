# /etc/zsh/zprofile
# $Header: /var/cvsroot/gentoo-x86/app-shells/zsh/files/zprofile,v 1.5 2008/05/23 12:02:51 tove Exp $

shopts=$-
setopt nullglob
for sh in /etc/profile.d/*.sh ; do
	[ -r "$sh" ] && . "$sh"
done
unsetopt nullglob
set -$shopts
unset sh shopts
