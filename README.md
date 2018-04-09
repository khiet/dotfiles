vimfiles
=======================

### Install vim, tmux, ad, etc.
```
brew install vim
brew install tmux
brew install the_silver_searcher
brew install fzf

gem install tmuxinator
```

### git clone
```
cd; git clone git@github.com:khiet/vimfiles.git
```

### Symlink config files
```
ln -s vimfiles ~/.vim
ln -s vimfiles/_vimrc ~/.vimrc
ln -s vimfiles/_gitconfig ~/.gitconfig
ln -s vimfiles/_bash_profile ~/.bash_profile
ln -s vimfiles/_ctags ~/.ctags
ln -s vimfiles/_tmux.conf ~/.tmux.conf
ln -s vimfiles/_tm_properties ~/.tm_properties
ln -s vimfiles/_hushlogin ~/.hushlogin
ln -s vimfiles/_ignore ~/.ignore
```

### Install plugins
```
:PlugInstall
```

### Install git-aware-prompt
https://github.com/jimeh/git-aware-prompt

### Install reattach-to-user-namespace
https://robots.thoughtbot.com/tmux-copy-paste-on-os-x-a-better-future
