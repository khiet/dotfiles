# dotfiles

## Install [Homebrew](http://brew.sh/index.html)

## Clone dotfiles

```bash
cd; git clone git@github.com:khiet/dotfiles.git
```

#### Symlink config file for zsh

```bash
cd; rm .zshrc; ln -s ~/dotfiles/_zshrc ~/.zshrc
```

## Symlink config files

```bash
ln -s ~/dotfiles/_gitconfig ~/.gitconfig
ln -s ~/dotfiles/_ctags ~/.ctags
ln -s ~/dotfiles/_hushlogin ~/.hushlogin
ln -s ~/dotfiles/_ripgreprc ~/.ripgreprc
ln -s ~/dotfiles/_rgignore ~/.rgignore

ln -s ~/dotfiles/_hammerspoon ~/.hammerspoon

mkdir -p $XDG_CONFIG_HOME

ln -s ~/dotfiles $XDG_CONFIG_HOME/nvim
ln -s ~/dotfiles/bat $XDG_CONFIG_HOME/bat
ln -s ~/dotfiles/pry $XDG_CONFIG_HOME/pry

mkdir -p $XDG_CONFIG_HOME/tmux
ln -s ~/dotfiles/tmux/_tmux.conf $XDG_CONFIG_HOME/tmux/tmux.conf

mkdir -p $XDG_CONFIG_HOME/lazygit
ln -s ~/dotfiles/lazygit/_config.yml $XDG_CONFIG_HOME/lazygit/config.yml

mkdir -p $XDG_CONFIG_HOME/ghostty
ln -s ~/dotfiles/ghostty/_config $XDG_CONFIG_HOME/ghostty/config

mkdir -p $XDG_CONFIG_HOME/opencode
ln -s ~/dotfiles/opencode/prompts $XDG_CONFIG_HOME/opencode/prompts
ln -s ~/dotfiles/opencode/_opencode.jsonc $XDG_CONFIG_HOME/opencode/opencode.jsonc
ln -s ~/dotfiles/opencode/_opencode-notifier.json $XDG_CONFIG_HOME/opencode/opencode-notifier.json
ln -s ~/dotfiles/opencode/plugins/opencode-notifier/opencode-notify.sh ~/.local/bin/opencode-notify.sh

ln -s ~/dotfiles/_starship.toml $XDG_CONFIG_HOME/starship.toml

rm $XDG_CONFIG_HOME/atuin/config.toml && ln -s ~/dotfiles/_atuin_config.toml $XDG_CONFIG_HOME/atuin/config.toml
```

## Install brew software

```bash
cd ~/dotfiles; brew bundle --no-lock
```
