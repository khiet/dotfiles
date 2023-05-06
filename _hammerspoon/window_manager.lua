-- Manage windows

hs.hotkey.bind({ "command", "option" }, "[", function()
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

hs.hotkey.bind({ "command", "option" }, "]", function()
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

hs.hotkey.bind({ "command", "option" }, "return", function()
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
