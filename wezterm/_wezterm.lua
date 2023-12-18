local wezterm = require 'wezterm'
local config = wezterm.config_builder()
local act = wezterm.action

config.color_scheme = "Dracula (Official)"
config.colors = {
  selection_fg = '#21222c',
  selection_bg = '#50fa7b',
}
config.tab_bar_at_bottom = false
config.use_fancy_tab_bar = false
config.window_decorations = "RESIZE"
config.font = wezterm.font('Hack Nerd Font', { weight = 'Regular' })
config.font_size = 14.0
config.scrollback_lines = 50000
config.window_close_confirmation = 'NeverPrompt'
config.selection_word_boundary = ' \t\n{}[]()\"\'`:│,'

-- enable option key
config.send_composed_key_when_left_alt_is_pressed = true

config.keys = {
  { key = 'H', mods = 'SHIFT|CMD', action = act.ActivateTabRelative(-1) },
  { key = 'L', mods = 'SHIFT|CMD', action = act.ActivateTabRelative(1) },
  { key = 'w', mods = 'CMD',       action = wezterm.action.CloseCurrentPane { confirm = false } },
}

config.key_tables = {
  search_mode = {
    { key = 'Escape', mods = 'NONE', action = act.CopyMode 'Close' },
    { key = 'n',      mods = 'CTRL', action = act.CopyMode 'NextMatch' },
    { key = 'p',      mods = 'CTRL', action = act.CopyMode 'PriorMatch' },
    { key = 'r',      mods = 'CTRL', action = act.CopyMode 'CycleMatchType' },
    { key = 'h',      mods = 'CTRL', action = act.CopyMode 'ClearPattern' },
  }
}

return config
