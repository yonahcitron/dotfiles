# Env vars to get the Homebrew-Linux package manager working properly.
export HOMEBREW_PREFIX="/opt/homebrew";
export HOMEBREW_CELLAR="$HOMEBREW_PREFIX/Cellar";
export HOMEBREW_REPOSITORY="$HOMEBREW_PREFIX/Library";
fpath[1,0]="$HOMEBREW_PREFIX/share/zsh/site-functions";
export PATH="$HOMEBREW_PREFIX/bin:$HOMEBREW_PREFIX/sbin${PATH+:$PATH}";
[ -z "${MANPATH-}" ] || export MANPATH=":${MANPATH#:}";
export INFOPATH="$HOMEBREW_PREFIX/share/info:${INFOPATH:-}";

