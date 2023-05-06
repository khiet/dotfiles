local function remap(mods, key, message, pressedfn, releasedfn, repeatfn)
  -- https://www.hammerspoon.org/docs/hs.hotkey.html#bind
  hs.hotkey.bind(mods, key, message, nil, message, nil)
end

-- disable default bindings
hs.hotkey.bind({ 'command' }, 'h', function()
end)
hs.hotkey.bind({ 'command' }, 'm', function()
end)
hs.hotkey.bind({ 'command', 'control' }, 'f', function()
end)

-- control + [ to escape
hs.hotkey.bind({ 'control' }, '[', function()
  hs.eventtap.keyStroke({}, 'escape')
end)

-- option + h/j/k/l to arrows
remap({ 'option' }, 'h', function()
  hs.eventtap.keyStroke({}, 'left', 1000)
end)
remap({ 'option' }, 'j', function()
  hs.eventtap.keyStroke({}, 'down', 1000)
end)
remap({ 'option' }, 'k', function()
  hs.eventtap.keyStroke({}, 'up', 1000)
end)
remap({ 'option' }, 'l', function()
  hs.eventtap.keyStroke({}, 'right', 1000)
end)
