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
ln -s ~/dotfiles/opencode/_opencode.jsonc $XDG_CONFIG_HOME/opencode/opencode.jsonc
ln -s ~/dotfiles/opencode/AGENTS.md $XDG_CONFIG_HOME/opencode/AGENTS.md
ln -s ~/dotfiles/opencode/agents $XDG_CONFIG_HOME/opencode/agents
ln -s ~/dotfiles/opencode/commands $XDG_CONFIG_HOME/opencode/commands
ln -s ~/dotfiles/opencode/skills $XDG_CONFIG_HOME/opencode/skills

mkdir -p ~/.claude
ln -s ~/dotfiles/opencode/commands ~/.claude/commands
ln -s ~/dotfiles/opencode/skills ~/.claude/skills
ln -s ~/dotfiles/.claude/settings.json ~/.claude/settings.json
ln -s ~/dotfiles/.claude/CLAUDE.md ~/.claude/CLAUDE.md

ln -s ~/dotfiles/_starship.toml $XDG_CONFIG_HOME/starship.toml

mkdir -p $XDG_CONFIG_HOME/atuin
ln -s ~/dotfiles/_atuin_config.toml $XDG_CONFIG_HOME/atuin/config.toml
```

#### Claude Code permissions

`.claude/settings.json` mirrors opencode's permission allowlist. `opencode/_opencode.jsonc`
is the single source of truth — after editing its permissions, regenerate and commit:

```bash
scripts/gen-claude-settings.sh
```

#### Claude Code MCP servers

`opencode/_opencode.jsonc` is also the single source of truth for MCP servers. Claude stores
user-scope servers in `~/.claude.json` (which it rewrites itself, so it can't be symlinked).
Instead, register them from the opencode config — re-run after editing the `mcp` block:

```bash
scripts/gen-claude-mcp.sh
```

Every server in the `mcp` block is registered at user scope (available in every project).

## Install brew software

```bash
cd ~/dotfiles; brew bundle
```
