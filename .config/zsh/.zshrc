# Start Up order
# +------------------+-----------+-----------+------+
# |                  |Interactive|Interactive|Script|
# |                  |login      |non-login  |      |
# +------------------+-----------+-----------+------+
# |/etc/zshenv       |    A      |    A      |  A   |
# +------------------+-----------+-----------+------+
# |$ZDOTDIR/.zshenv  |    B      |    B      |  B   |
# +------------------+-----------+-----------+------+
# |/etc/zprofile     |    C      |           |      |
# +------------------+-----------+-----------+------+
# |$ZDOTDIR/.zprofile|    D      |           |      |
# +------------------+-----------+-----------+------+
# |/etc/zshrc        |    E      |    C      |      |
# +------------------+-----------+-----------+------+
# |$ZDOTDIR/.zshrc   |    F      |    D      |      |
# +------------------+-----------+-----------+------+
# |/etc/zlogin       |    G      |           |      |
# +------------------+-----------+-----------+------+
# |$ZDOTDIR/.zlogin  |    H      |           |      |
# +------------------+-----------+-----------+------+
# |                  |           |           |      |
# +------------------+-----------+-----------+------+
# |                  |           |           |      |
# +------------------+-----------+-----------+------+
# |$ZDOTDIR/.zlogout |    I      |           |      |
# +------------------+-----------+-----------+------+
# |/etc/zlogout      |    J      |           |      |
# +------------------+-----------+-----------+------+
ZPLUG_HOME="$ZDOTDIR/zplug/"
source "$HOME/.bashrc"
source "$ZPLUG_HOME/init.zsh"
source "$ZDOTDIR/plugins.zsh"
source "$ZDOTDIR/options.zsh"
source "$ZDOTDIR/history.zsh"
source "$ZDOTDIR/completion.zsh"
source "$ZDOTDIR/keybinds.zsh"
source "$ZDOTDIR/alias.zsh"
source "$ZDOTDIR/prompt.zsh"
