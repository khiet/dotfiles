# dotfiles

## Install [Homebrew](http://brew.sh/index.html)

## Clone dotfiles

```
cd; git clone git@github.com:khiet/dotfiles.git
```

#### Symlink config file for zsh

```
cd; rm .zshrc; ln -s ~/dotfiles/_zshrc ~/.zshrc
```

## Symlink config files

```
ln -s ~/dotfiles/_gitconfig ~/.gitconfig
ln -s ~/dotfiles/_ctags ~/.ctags
ln -s ~/dotfiles/_tmux.conf ~/.tmux.conf
ln -s ~/dotfiles/_hushlogin ~/.hushlogin
ln -s ~/dotfiles/_ripgreprc ~/.ripgreprc
ln -s ~/dotfiles/_rgignore ~/.rgignore

ln -s ~/dotfiles/_hammerspoon ~/.hammerspoon

mkdir -p $XDG_CONFIG_HOME
ln -s ~/dotfiles $XDG_CONFIG_HOME/nvim

ln -s ~/dotfiles/bat $XDG_CONFIG_HOME/bat

ln -s ~/dotfiles/pry $XDG_CONFIG_HOME/pry

mkdir -p $XDG_CONFIG_HOME/lazygit
ln -s ~/dotfiles/lazygit/_config.yml $XDG_CONFIG_HOME/lazygit/config.yml

mkdir -p $XDG_CONFIG_HOME/wezterm
ln -s ~/dotfiles/wezterm/_wezterm.lua $XDG_CONFIG_HOME/wezterm/wezterm.lua
ln -s ~/dotfiles/_starship.toml $XDG_CONFIG_HOME/starship.toml
```

## Install brew software

```
cd ~/dotfiles; brew bundle
```
