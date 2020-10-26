# dotfiles

### Install [Homebrew](http://brew.sh/index.html)

### Install nvim, tmux, rg, and fzf

```
brew cask install iterm2
brew tap homebrew/cask-fonts; brew cask install font-hack-nerd-font
brew install git
brew install nvim
brew install reattach-to-user-namespace
brew install tmux
brew install ripgrep
brew install fzf
brew install ansiweather
```

### git clone

```
cd; git clone git@github.com:khiet/dotfiles.git
```

### Symlink config files

```
ln -s dotfiles ~/.vim
ln -s ~/dotfiles/_vimrc ~/.vimrc
ln -s ~/dotfiles/_gitconfig ~/.gitconfig
ln -s ~/dotfiles/_ctags ~/.ctags
ln -s ~/dotfiles/_tmux.conf ~/.tmux.conf
ln -s ~/dotfiles/_tm_properties ~/.tm_properties
ln -s ~/dotfiles/_hushlogin ~/.hushlogin
ln -s ~/dotfiles/_prettierrc ~/.prettierrc
ln -s ~/dotfiles/_ripgreprc ~/.ripgreprc

mkdir -p $XDG_CONFIG_HOME
ln -s ~/.vim $XDG_CONFIG_HOME/nvim
ln -s ~/.vimrc $XDG_CONFIG_HOME/nvim/init.vim

mkdir -p $XDG_CONFIG_HOME/karabiner
ln -s ~/dotfiles/_karabiner.json $XDG_CONFIG_HOME/karabiner/karabiner.json
```

### Install plugins

```
:PlugInstall
```

### Symlink config file

```
cd; rm .zshrc; ln -s ~/dotfiles/_zshrc ~/.zshrc
```

### Install oh my zsh and plugins

```
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
```

### Mac software

```
brew cask install copyq
brew cask install firefox
brew cask install sequel-pro
brew cask install postico
brew cask install dropbox
brew cask install rectangle
brew cask install vlc
brew cask install zoomus
brew cask install postman
brew cask install karabiner-elements
brew cask install evernote
brew install ffmpeg
brew install ctags
brew install tldr
brew install htop
brew install ccat
brew install youtube-dl
brew install awscli
brew install watch
```

### Install Visual Studio Code

```
brew cask install visual-studio-code
```

### Symlink config file

```
rm ~/Library/Application\ Support/Code/User/settings.json; ln -s ~/dotfiles/_settings.json ~/Library/Application\ Support/Code/User/settings.json
rm ~/Library/Application\ Support/Code/User/keybindings.json; ln -s ~/dotfiles/_keybindings.json ~/Library/Application\ Support/Code/User/keybindings.json
```
