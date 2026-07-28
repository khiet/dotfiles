# herdr

Scratch notes for trialling herdr. Not committed.

- Config: `herdr/_config.toml`, symlinked to `$XDG_CONFIG_HOME/herdr/config.toml`
- Docs: https://herdr.dev/docs/
- Installed via Homebrew, `brew "herdr"` in the Brewfile

herdr is an agent multiplexer. It runs standalone in a Ghostty tab, not inside
tmux, so it takes over the `ctrl+a` prefix without conflict.

## Settings picked

| Setting | Value | Why |
| --- | --- | --- |
| `prefix` | `ctrl+a` | Same as tmux |
| `focus_pane_*` | `prefix h/j/k/l` | Same as tmux (also herdr's default) |
| `reload_config` | `prefix r` | tmux binds `r` to reload; herdr defaults to `shift+r` |
| `resize_mode` | `prefix shift+r` | Displaced by the swap above; tmux resizes on shifted keys |
| `last_pane` | `prefix space` | Nearest thing to tmux `prefix Space` |
| `split_vertical` | `prefix %` | Same as tmux; herdr calls it "split right" |
| `split_horizontal` | `prefix "` | Same as tmux; herdr calls it "split down" |
| `previous_tab` / `next_tab` | `prefix [` / `prefix ]` | Browser-style tab cycling; herdr defaults to `p`/`n` |
| `theme.name` | `dracula` | Matches Ghostty and tmux |
| `ui.accent` | `#50fa7b` | The tmux active pane border green |
| `prompt_new_tab_name` | `false` | tmux makes windows instantly |
| `mouse_capture` | `false` | Matches tmux; keeps Cmd-click URLs and native selection |
| `toast.delivery` | `terminal` | Ghostty raises the desktop notification when an agent finishes or blocks |
| `resume_agents_on_restore` | `true` | Agent sessions survive a server restart |
| lazygit popup | `prefix alt+g` | lazygit is already configured in this repo |

Everything else stays on herdr defaults, so `prefix ?` and the online docs
remain accurate.

Two bindings have no clean tmux equivalent and are the most likely to need
changing after real use: `prefix space` for last-pane and `prefix shift+r`
for resize mode.

## 10-minute trial

### 1. Launch (1 min)

```bash
cd ~/some-project && herdr
```

Plain Ghostty tab, not inside tmux. Notifications go through Ghostty
(`delivery = "terminal"`), so make sure Ghostty is allowed in macOS
notification settings. Then `ctrl+a ?` for help.

### 2. Panes and tabs (2 min)

Existing tmux muscle memory, nothing new to learn:

- `ctrl+a %` split side by side, `ctrl+a "` split stacked
- `ctrl+a h/j/k/l` move, `ctrl+a space` jump back
- `ctrl+a z` zoom, `ctrl+a c` new tab, `ctrl+a 1..9` switch
- `ctrl+a [` and `ctrl+a ]` cycle tabs left and right

### 3. The actual point: run two agents (3 min)

Split into two panes and start a real agent in each, for example `claude` in
one and a test run in the other. Watch the left sidebar: each pane gets a
state (working, blocked, done). That live view is what herdr exists for and
what tmux cannot do.

### 4. Detach and reattach (1 min)

```
ctrl+a q          # detach, agents keep running
herdr             # reattach, from any terminal
```

Do this while an agent is mid-task. Confirming work survives detach is worth
verifying before relying on it.

### 5. Walk away (2 min)

Start something slow, switch to another app, wait for the macOS notification
when it finishes or needs input. If notifications never arrive, check
Ghostty's macOS notification permission first; failing that, change
`delivery` to `"system"` (herdr asks macOS directly) or `"herdr"` (in-app
toasts) in the config and `ctrl+a r` to reload.

### 6. Extras if time (1 min)

- `ctrl+a w` workspace picker (the tmux-sessionx replacement)
- `ctrl+a alt+g` lazygit popup
- `ctrl+a e` open scrollback in nvim
- `ctrl+a shift+g` new git worktree, useful for parallel agent branches

Optional, for zsh completions:

```bash
herdr completion zsh > "$XDG_CONFIG_HOME/zsh/completions/_herdr"
```

## What to judge it on

tmux already handles steps 2 and 4 fine. If herdr earns a place it will be on
steps 3 and 5: knowing which of several agents is blocked without cycling
through windows. If that does not feel valuable, the tmux config is untouched
either way.

## Useful commands

```bash
herdr                     # launch or attach
herdr --default-config    # every option with its default
herdr config check        # validate config.toml after editing
herdr status              # client and server status
herdr server stop         # stop the background server
herdr --no-session        # run monolithically, escape hatch
```

## If it does not work out

```bash
rm "$XDG_CONFIG_HOME/herdr/config.toml"
brew uninstall herdr
```

Then revert the `brew "herdr"` line in the Brewfile, the herdr block in
`README.md`, and delete `herdr/`. The relevant commits are `9d5ad0a` and
`bb7ef48`.
