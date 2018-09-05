# dotfiles

### Install vim, tmux, ad, etc.

```
brew install vim
brew install tmux
brew install the_silver_searcher
brew install fzf

gem install tmuxinator

npm install --g prettier
```

### git clone

```
cd; git clone git@github.com:khiet/dotfiles.git
```

### Symlink config files

```
ln -s dotfiles ~/.vim
ln -s dotfiles/_vimrc ~/.vimrc
ln -s dotfiles/_gitconfig ~/.gitconfig
ln -s dotfiles/_bash_profile ~/.bash_profile
ln -s dotfiles/_ctags ~/.ctags
ln -s dotfiles/_tmux.conf ~/.tmux.conf
ln -s dotfiles/_tm_properties ~/.tm_properties
ln -s dotfiles/_hushlogin ~/.hushlogin
ln -s dotfiles/_ignore ~/.ignore
ln -s dotfiles/_prettierrc ~/.prettierrc
```

### Install plugins

```
:PlugInstall
```

### Install git-aware-prompt

https://github.com/jimeh/git-aware-prompt

### Install reattach-to-user-namespace

https://robots.thoughtbot.com/tmux-copy-paste-on-os-x-a-better-future

### Other software

```
brew cask install textmate
brew cask install visual-studio-code
brew cask install kdiff3
brew cask install firefox
```
