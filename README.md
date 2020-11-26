# dotfiles

## Install [Homebrew](http://brew.sh/index.html)

## Install iterm and nerd font

```
brew cask install iterm2
brew tap homebrew/cask-fonts; brew cask install font-hack-nerd-font
```

## Clone dotfiles

```
cd; git clone git@github.com:khiet/dotfiles.git
```

## Symlink config file for zsh

```
cd; rm .zshrc; ln -s ~/dotfiles/_zshrc ~/.zshrc
```

## Install oh my zsh and plugins

```
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
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

mkdir -p $XDG_CONFIG_HOME/karabiner
ln -s ~/dotfiles/_karabiner.json $XDG_CONFIG_HOME/karabiner/karabiner.json

mkdir -p $XDG_CONFIG_HOME
ln -s ~/.vim $XDG_CONFIG_HOME/nvim
ln -s ~/.vimrc $XDG_CONFIG_HOME/nvim/init.vim
```

## Install Karabiner-Elements

```
brew cask install karabiner-elements
```

## Install nvim and plugins

### Install Prerequisites
```
brew install node
python3 -m pip install --user --upgrade pynvim
```

```
brew install nvim

:PlugInstall
```

## Install development packages

```
brew install tmux
brew install ripgrep
brew install fzf
```

## Install Mac apps

```
brew cask install rectangle
brew cask install copyq
brew cask install dropbox
```

## Install rbenv and Ruby

```
brew install rbenv
```

```
rbenv install 2.7.2
rbenv global 2.7.2
```

## Install other packages and apps

```
gem install colorls
gem install tmuxinator

brew install git
brew install ctags
brew install yarn
brew install parallel
brew install tldr
brew install htop
brew install ccat
brew install watch
brew install ffmpeg
brew install youtube-dl

brew cask install firefox
brew cask install sequel-pro
brew cask install postico
brew cask install zoomus
brew cask install vlc
```

## Install Visual Studio Code

```
brew cask install visual-studio-code
```

## Symlink config file

```
rm ~/Library/Application\ Support/Code/User/settings.json
ln -s ~/dotfiles/_settings.json ~/Library/Application\ Support/Code/User/settings.json
rm ~/Library/Application\ Support/Code/User/keybindings.json
ln -s ~/dotfiles/_keybindings.json ~/Library/Application\ Support/Code/User/keybindings.json
```
