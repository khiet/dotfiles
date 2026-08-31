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

mkdir -p $XDG_CONFIG_HOME/herdr
ln -s ~/dotfiles/herdr/_config.toml $XDG_CONFIG_HOME/herdr/config.toml

mkdir -p $XDG_CONFIG_HOME/lazygit
ln -s ~/dotfiles/lazygit/_config.yml $XDG_CONFIG_HOME/lazygit/config.yml

mkdir -p $XDG_CONFIG_HOME/ghostty
ln -s ~/dotfiles/ghostty/_config $XDG_CONFIG_HOME/ghostty/config

# Pi reads ~/.pi/agent only (no XDG support); its MCP adapter reads the shared
# $XDG_CONFIG_HOME/mcp/mcp.json.
mkdir -p ~/.pi/agent $XDG_CONFIG_HOME/mcp
ln -s ~/dotfiles/pi/settings.json ~/.pi/agent/settings.json
ln -s ~/dotfiles/pi/keybindings.json ~/.pi/agent/keybindings.json
ln -s ~/dotfiles/pi/AGENTS.md ~/.pi/agent/AGENTS.md
ln -s ~/dotfiles/pi/commands ~/.pi/agent/prompts
ln -s ~/dotfiles/pi/skills ~/.pi/agent/skills
ln -s ~/dotfiles/pi/themes ~/.pi/agent/themes
ln -s ~/dotfiles/pi/extensions ~/.pi/agent/extensions
ln -s ~/dotfiles/pi/mcp.json $XDG_CONFIG_HOME/mcp/mcp.json

mkdir -p ~/.claude
ln -s ~/dotfiles/pi/commands ~/.claude/commands
ln -s ~/dotfiles/pi/skills ~/.claude/skills
ln -s ~/dotfiles/.claude/settings.json ~/.claude/settings.json
ln -s ~/dotfiles/.claude/CLAUDE.md ~/.claude/CLAUDE.md

ln -s ~/dotfiles/_starship.toml $XDG_CONFIG_HOME/starship.toml

mkdir -p $XDG_CONFIG_HOME/atuin
ln -s ~/dotfiles/_atuin_config.toml $XDG_CONFIG_HOME/atuin/config.toml
```

#### Pi

Pi has no built-in MCP; `pi/settings.json` declares the `pi-mcp-adapter` package, but
global packages are not auto-installed. Once per machine, after symlinking:

1. `pi install npm:pi-mcp-adapter`
2. In pi, `/login` and pick GitHub Copilot (`gpt-5.6-sol` is billed to the Copilot plan)
3. `/mcp-auth linear` and `/mcp-auth sentry` (OAuth tokens live in the OS keychain)
4. Optional, for Bedrock via SSO: `aws sso login --profile <profile>`, then `/login amazon-bedrock` and
   choose the AWS profile option. Ctrl+P cycles between the Copilot and Bedrock models in `enabledModels`.

`pi install` and `/model` write to `~/.pi/agent/settings.json`, which is the symlinked repo
file, so commit those edits.

#### Claude Code MCP servers

`pi/mcp.json` is the single source of truth for MCP servers. Claude stores user-scope
servers in `~/.claude.json` (which it rewrites itself, so it can't be symlinked). Instead,
register them from the pi config — re-run after editing `mcpServers`:

```bash
scripts/gen-claude-mcp.sh
```

Every server, including ones marked `disabled` for pi, is registered at user scope
(available in every project). The deny list in `.claude/settings.json` is maintained by hand.

#### GitHub skills

`scripts/github-skills.tsv` lists GitHub repos and gists to sync into `pi/skills`.
After editing that manifest, regenerate and commit:

```bash
scripts/sync-github-skills.sh
```

## Install brew software

```bash
cd ~/dotfiles; brew bundle
```
