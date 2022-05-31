# dotfiles

## Install [Homebrew](http://brew.sh/index.html)

## Clone dotfiles

```
cd; git clone git@github.com:khiet/dotfiles.git
```

## Install oh my zsh and plugins

```
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
```

#### Symlink config file for zsh

```
cd; rm .zshrc; ln -s ~/dotfiles/_zshrc ~/.zshrc
```

## Symlink config files

```
ln -s dotfiles ~/.vim
ln -s ~/dotfiles/_vimrc ~/.vimrc
ln -s ~/dotfiles/_gitconfig ~/.gitconfig
ln -s ~/dotfiles/_ctags ~/.ctags
ln -s ~/dotfiles/_tmux.conf ~/.tmux.conf
ln -s ~/dotfiles/_hushlogin ~/.hushlogin
ln -s ~/dotfiles/_ripgreprc ~/.ripgreprc
ln -s ~/dotfiles/_rgignore ~/.rgignore

ln -s ~/dotfiles/.hammerspoon ~/.hammerspoon

mkdir -p $XDG_CONFIG_HOME
ln -s ~/.vim $XDG_CONFIG_HOME/nvim
ln -s ~/.vimrc $XDG_CONFIG_HOME/nvim/init.vim

ln -s ~/dotfiles/bat $XDG_CONFIG_HOME/bat

ln -s ~/dotfiles/pry $XDG_CONFIG_HOME/pry
ln -s ~/dotfiles/lazygit/_config.yml $XDG_CONFIG_HOME/lazygit/config.yml
```

## Install brew software

```
cd ~/dotfiles; brew bundle
```

## Install neovim dependencies

```
python3 -m pip install --user --upgrade pynvim
```
