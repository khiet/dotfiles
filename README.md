# dotfiles

## Install [Homebrew](http://brew.sh/index.html)

## Install iterm and nerd font

```
brew install --cask iterm2
brew tap homebrew/cask-fonts; brew install --cask font-hack-nerd-font
```

## Clone dotfiles

```
cd; git clone git@github.com:khiet/dotfiles.git
```

## Install oh my zsh and plugins

```
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
```

## Symlink config file for zsh

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

ln -s ~/dotfiles/.hammerspoon ~/.hammerspoon

mkdir -p $XDG_CONFIG_HOME
ln -s ~/.vim $XDG_CONFIG_HOME/nvim
ln -s ~/.vimrc $XDG_CONFIG_HOME/nvim/init.vim

ln -s ~/dotfiles/bat $XDG_CONFIG_HOME/bat
```

## Install Hammerspoon

```
brew install --cask hammerspoon
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
brew install --cask maccy
brew install --cask dropbox
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
brew install bat
brew install watch
brew install ffmpeg
brew install youtube-dl

brew install --cask beyond-compare
brew install --cask firefox
brew install --cask postico
brew install --cask postman
brew install --cask zoomus
brew install --cask appcleaner
brew install --cask vlc
brew install --cask sequel-pro

npm install -g vtop
```

## Install Visual Studio Code

```
brew install --cask visual-studio-code
```

## Symlink config file

```
rm ~/Library/Application\ Support/Code/User/settings.json
ln -s ~/dotfiles/_settings.json ~/Library/Application\ Support/Code/User/settings.json
rm ~/Library/Application\ Support/Code/User/keybindings.json
ln -s ~/dotfiles/_keybindings.json ~/Library/Application\ Support/Code/User/keybindings.json
```
