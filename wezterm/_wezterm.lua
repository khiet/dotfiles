local wezterm = require 'wezterm'
local act = wezterm.action

return {
  color_scheme = "Dracula (Official)",
  colors = {
    selection_fg = '#21222c',
    selection_bg = '#50fa7b',
  },
  tab_bar_at_bottom = false,
  use_fancy_tab_bar = false,
  window_decorations = "RESIZE",
  font = wezterm.font('Hack Nerd Font', { weight = 'Regular' }),
  font_size = 14.0,
  scrollback_lines = 50000,
  window_close_confirmation = 'NeverPrompt',
  selection_word_boundary = ' \t\n{}[]()\"\'`:│',

  keys = {
    { key = 'H', mods = 'SHIFT|CMD', action = act.ActivateTabRelative(-1) },
    { key = 'L', mods = 'SHIFT|CMD', action = act.ActivateTabRelative(1) },
    { key = 'w', mods = 'CMD',       action = wezterm.action.CloseCurrentPane { confirm = false } },
  },

  key_tables = {
    search_mode = {
      { key = 'Escape', mods = 'NONE', action = act.CopyMode 'Close' },
      { key = 'n',      mods = 'CTRL', action = act.CopyMode 'NextMatch' },
      { key = 'p',      mods = 'CTRL', action = act.CopyMode 'PriorMatch' },
      { key = 'r',      mods = 'CTRL', action = act.CopyMode 'CycleMatchType' },
      { key = 'h',      mods = 'CTRL', action = act.CopyMode 'ClearPattern' },
    },
  },
}
