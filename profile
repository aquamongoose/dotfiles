# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

export XENVIRONMENT="/home/bill/.Xresources"
export EDITOR=vi
sleep 10 && redshift -l 42.22:-72.64 &
sh /home/bill/.fehbg &
