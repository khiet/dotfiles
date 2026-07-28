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
| `copy_mode` | `prefix [` | Same as tmux; herdr ships copy mode unbound |
| `sidebar_start_collapsed` | `true` | Compact status rail by default; `prefix b` toggles the full sidebar |
| `theme.name` | `dracula` | Matches Ghostty and tmux |
| `ui.accent` | `#50fa7b` | The tmux active pane border green |
| `prompt_new_tab_name` | `false` | tmux makes windows instantly |
| `mouse_capture` | `true` | On trial: wheel scrollback and click-to-focus, at the cost of Ghostty's Cmd-click URLs and native selection |
| `toast.delivery` | `terminal` | Ghostty raises the desktop notification when an agent finishes or blocks |
| `resume_agents_on_restore` | `true` | Agent sessions survive a server restart |
| lazygit popup | `prefix alt+g` | lazygit is already configured in this repo |

Everything else stays on herdr defaults, so `prefix ?` and the online docs
remain accurate.

herdr does not watch the config file: edits apply only after `prefix r` in a
running session, and `sidebar_start_collapsed` only on the next launch.

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
- `ctrl+a p` and `ctrl+a n` cycle tabs left and right
- `ctrl+a [` copy mode, same key as tmux

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

`ctrl+a w` vs `ctrl+a g`: different levels of the hierarchy, per the docs.
`w` opens navigate mode, a sidebar surface for the current session
(up/down between workspaces, h/j/k/l between panes). `g` opens the session
navigator, for jumping between named persistent sessions (`herdr session`).
The docs do not say whether `g` can also match workspaces within a session;
untested, so treat them as complements for now.

Optional, for zsh completions:

```bash
herdr completion zsh > "$XDG_CONFIG_HOME/zsh/completions/_herdr"
```

## Scrollback

`ctrl+a [` enters copy mode, which is tmux's copy mode: `h/j/k/l w/b/e { }` to
move, `/` and `?` to search with `n`/`N`, `v` or space to select, `y` or enter
to copy, `q` or esc to leave. It searches the whole buffer, unlike Ghostty's
find, which only matches what is on screen. This is the way to look back
through a pane, not `ctrl+a e`, which dumps the scrollback into nvim.

herdr ships copy mode unbound, so it exists only because `keys.copy_mode` is
set. It is absent from `herdr --default-config` in 0.7.5; `herdr config check`
accepts it.

Page up and page down are intercepted for pane scrollback and scroll without
entering a mode, but cannot search or copy.

The mouse wheel scrolls the focused pane, three lines per notch, but only
because `mouse_capture = true` is on trial. With the mouse left to Ghostty, as
tmux does, the wheel does nothing: Ghostty cannot scroll herdr's alt screen.
The trade is Ghostty's Cmd-click URLs and native selection inside panes, so if
that turns out to hurt more than the wheel helps, set `mouse_capture = false`
and rely on copy mode.

## Spaces

A space is herdr's top-level container, one level above tabs. The sidebar has a
section per level: `spaces` lists workspaces, `agents` lists agent panes. The
`grouped` label on the agents header is the `agent_panel_sort = "spaces"`
default, meaning agents are listed under the space they belong to; the
alternative is `"priority"`, an attention queue ordered by state across all
spaces.

Creating one:

- `ctrl+a shift+n` new space. `prompt_new_workspace_name` defaults to false, so
  it is created immediately with a generated name, and inherits the current
  pane's cwd because of `new_cwd = "follow"`. To root it elsewhere, `cd` first.
- `ctrl+a shift+w` rename, when the generated name is not useful.
- `ctrl+a shift+g` new git worktree, which gets its own space. This is the one
  worth trying: one space per branch, agents grouped under each.

From the shell, against the running server:

```bash
herdr workspace create --cwd ~/some-project --label some-project --focus
herdr workspace list
```

With a second space in play, `ctrl+a w` switches between them and the agents
panel starts showing more than one group.

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
