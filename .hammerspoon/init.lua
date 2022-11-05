-- https://www.hammerspoon.org/docs/index.html

local logger = hs.logger.new('logger', 'debug')
-- e.g. logger.i('debug info')

local function remap(mods, key, message, pressedfn, releasedfn, repeatfn)
  -- https://www.hammerspoon.org/docs/hs.hotkey.html#bind
  hs.hotkey.bind(mods, key, message, nil, message, nil)
end

local function sendSystemKey(key)
  -- https://www.hammerspoon.org/docs/hs.eventtap.event.html#newSystemKeyEvent
  hs.eventtap.event.newSystemKeyEvent(key, true):post()
  hs.eventtap.event.newSystemKeyEvent(key, false):post()
end

-- Bind option + h/j/k/l to arrows

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

-- Map ESC, ` and ~ as:
--
-- ESC	ESC or control + [
-- `	fn1 + ESC
-- ~	shift + ESC

-- bind control + [ to escape
hs.hotkey.bind({'control'}, '[', function()
  hs.eventtap.keyStroke({}, 'escape')
end)

hs.hotkey.bind({'shift'}, 'escape', function()
  hs.eventtap.keyStrokes('~')
end)

-- Disable default bindings

hs.hotkey.bind({'command'}, 'h', function()
end)
hs.hotkey.bind({'command'}, 'm', function()
end)
hs.hotkey.bind({'command', 'control'}, 'f', function()
end)

-- local function getBrowserUrl(browserName)
--     local _, url = hs.osascript.applescript('tell application "' .. browserName .. '" to return URL of active tab of front window')
-- 
--     return url
-- end
-- 
-- local mapInlineCode = false
-- local inlineCode = hs.hotkey.bind({'command'}, 'e', function()
--   if mapInlineCode then
--     local focusedAppName = hs.window.focusedWindow():application():name()
--     local url = getBrowserUrl(focusedAppName)
--     if string.find(url, "linear.app") then
--       hs.eventtap.keyStroke({'command', 'shift'}, 'c')
--     end
--   end
-- end)
-- 
-- local function toggleInlineCode(appName)
--   hs.window.filter.new(appName)
--     :subscribe(hs.window.filter.windowFocused, function()
--       inlineCode:enable()
--     end)
--     :subscribe(hs.window.filter.windowUnfocused, function()
--       inlineCode:disable()
--     end)
-- end
-- 
-- toggleInlineCode("Google Chrome")
-- toggleInlineCode("Slack")

-- Control volumes

hs.eventtap.new({hs.eventtap.event.types.scrollWheel}, function(e)
  -- event from mouse and not trackpad
  if e:getProperty(hs.eventtap.event.properties.scrollWheelEventMomentumPhase) == 0 then
    if e:getProperty(hs.eventtap.event.properties.scrollWheelEventScrollPhase) == 0 then
      local horizontalScrolDelta = e:getProperty(hs.eventtap.event.properties.scrollWheelEventDeltaAxis2)

      if horizontalScrolDelta < 0 then
        sendSystemKey("SOUND_UP")
      elseif horizontalScrolDelta > 0 then
        sendSystemKey("SOUND_DOWN")
      end
    end
  end
end):start()

-- Manage windows

hs.hotkey.bind({"command", "option"}, "[", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  local halfWidth = max.w / 2
  local oneQuarterWidth = halfWidth / 2
  local threeQuarterWidth = halfWidth + oneQuarterWidth

  f.x = max.x
  f.y = max.y
  if f.w >= 0 and f.w < oneQuarterWidth then
    f.w = oneQuarterWidth
  elseif f.w >= oneQuarterWidth and f.w < halfWidth then
    f.w = halfWidth
  elseif f.w >= halfWidth and f.w < threeQuarterWidth then
    f.w = threeQuarterWidth
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

  if f.w >= 0 and f.w < oneQuarterWidth then
    f.x = max.x + threeQuarterWidth
    f.w = oneQuarterWidth
  elseif f.w >= oneQuarterWidth and f.w < halfWidth then
    f.x = max.x + halfWidth
    f.w = halfWidth
  elseif f.w >= halfWidth and f.w < threeQuarterWidth then
    f.x = max.x + oneQuarterWidth
    f.w = threeQuarterWidth
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
