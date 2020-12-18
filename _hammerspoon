-- https://www.hammerspoon.org/docs/index.html

logger = hs.logger.new('logger', 'debug')

local function remap(mods, key, message, pressedfn, releasedfn, repeatfn)
  -- https://www.hammerspoon.org/docs/hs.hotkey.html#bind
  hs.hotkey.bind(mods, key, message, nil, message, nil)
end

-- bind option + h/j/k/l to arrows
remap({'option'}, 'h', function()
  hs.eventtap.keyStroke({}, 'left', 1000)
end)
remap({'option'}, 'j', function()
  hs.eventtap.keyStroke({}, 'down', 1000)
end)
remap({'option'}, 'k', function()
  hs.eventtap.keyStroke({}, 'up', 1000)
end)
remap({'option'}, 'l', function()
  hs.eventtap.keyStroke({}, 'right', 1000)
end)

-- bind control + [ to escape
hs.hotkey.bind({'control'}, '[', function()
  hs.eventtap.keyStroke({}, 'escape')
end)

-- hs.hotkey.bind({}, 'escape', function()
--   hs.eventtap.keyStroke({}, '`')
-- end)

hs.hotkey.bind({'shift'}, 'escape', function()
  hs.eventtap.keyStrokes('~')
end)

hs.hotkey.bind({'command', 'shift'}, 'u', function()
  hs.application.launchOrFocus('iTerm')
end)

hs.hotkey.bind({'command', 'shift'}, 'i', function()
  local nextAppMap = { Bear = 'Things3', Things3 = 'Bear' }
  local currentApp = hs.application.frontmostApplication()
  local nextApp = nextAppMap[currentApp:name()] or 'Bear'

  hs.application.launchOrFocus(nextApp)
end)

hs.hotkey.bind({'command', 'shift'}, 'o', function()
  hs.application.launchOrFocus('Google Chrome')
end)

hs.hotkey.bind({"command", "option"}, "[", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  local halfWidth = max.w / 2
  local oneQuarterWidth = halfWidth / 2
  local threeQuarterWidth = halfWidth + oneQuarterWidth
  local sevenEighthWidth = threeQuarterWidth + (oneQuarterWidth / 2)

  f.x = max.x
  f.y = max.y
  if f.w >= 0 and f.w < oneQuarterWidth then
    f.w = oneQuarterWidth
  elseif f.w >= oneQuarterWidth and f.w < halfWidth then
    f.w = halfWidth
  elseif f.w >= halfWidth and f.w < threeQuarterWidth then
    f.w = threeQuarterWidth
  elseif f.w >= threeQuarterWidth and f.w < sevenEighthWidth then
    f.w = sevenEighthWidth
  else
    f.w = oneQuarterWidth
  end

  f.h = max.h

  win:setFrame(f)
end)

hs.hotkey.bind({"command", "option"}, "]", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  local halfWidth = max.w / 2
  local oneQuarterWidth = halfWidth / 2
  local threeQuarterWidth = halfWidth + oneQuarterWidth
  local sevenEighthWidth = threeQuarterWidth + (oneQuarterWidth / 2)

  if f.w >= 0 and f.w < oneQuarterWidth then
    f.x = max.x + threeQuarterWidth
    f.w = oneQuarterWidth
  elseif f.w >= oneQuarterWidth and f.w < halfWidth then
    f.x = max.x + halfWidth
    f.w = halfWidth
  elseif f.w >= halfWidth and f.w < threeQuarterWidth then
    f.x = max.x + oneQuarterWidth
    f.w = threeQuarterWidth
  elseif f.w >= threeQuarterWidth and f.w < sevenEighthWidth then
    f.x = max.x + (oneQuarterWidth / 2)
    f.w = sevenEighthWidth
  else
    f.x = max.x + threeQuarterWidth
    f.w = oneQuarterWidth
  end

  f.y = max.y
  f.h = max.h

  win:setFrame(f)
end)

hs.hotkey.bind({"command", "option"}, "return", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x
  f.y = max.y
  f.w = max.w
  f.h = max.h
  win:setFrame(f)
end)
