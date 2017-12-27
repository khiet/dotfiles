vimfiles
=======================

Rails development setup
=======================

### Install vim, tmux and gg
```
brew install vim
brew install tmux
brew install the_silver_searcher
```

### Install submodules
```
cd vimfiles
git submodule init
git submodule update
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
```

### Install reattach-to-user-namespace
https://robots.thoughtbot.com/tmux-copy-paste-on-os-x-a-better-future

### Install git-aware-prompt
https://github.com/jimeh/git-aware-prompt
