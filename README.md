# dotfiles

### Install [Homebrew](http://brew.sh/index.html)

### Install vim, tmux, ag, and fzf

```
brew cask install iterm2
brew install git
brew install vim
brew install reattach-to-user-namespace
brew install tmux
brew install the_silver_searcher
brew install fzf
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
ln -s ~/dotfiles/_bash_profile ~/.bash_profile
ln -s ~/dotfiles/_ctags ~/.ctags
ln -s ~/dotfiles/_tmux.conf ~/.tmux.conf
ln -s ~/dotfiles/_tm_properties ~/.tm_properties
ln -s ~/dotfiles/_hushlogin ~/.hushlogin
ln -s ~/dotfiles/_ignore ~/.ignore
ln -s ~/dotfiles/_prettierrc ~/.prettierrc
```

### Install plugins

```
:PlugInstall
```

### chsh to zsh

```
chsh -s $(which zsh)
```

### Symlink config file

```
cd; rm .zshrc; ln -s ~/dotfiles/_zshrc ~/.zshrc
```

### Install oh my zsh and plugins

```
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
git clone https://github.com/supercrabtree/k $ZSH_CUSTOM/plugins/k
```

### Mac software

```
brew cask install copyq
brew cask install firefox
brew cask install textmate
brew cask install skype
brew cask install sequel-pro
brew cask install psequel
brew cask install dropbox
brew cask install spectacle
brew cask install vlc
brew cask install zoomus
brew cask install postman
brew install ffmpeg
brew install ctags
brew install tldr
brew install htop
brew install youtube-dl
brew install awscli
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
