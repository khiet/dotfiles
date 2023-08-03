-- Manage windows

hs.hotkey.bind({ "command", "option" }, "[", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local screenFrame = screen:frame()

  local fullWidth = screenFrame.w
  local halfWidth = math.floor(fullWidth / 2)
  local oneQuarterWidth = math.floor(fullWidth  / 4)
  local threeQuarterWidth = fullWidth - oneQuarterWidth

  f.x = screenFrame.x
  if f.w >= 0 and f.w < halfWidth then
    f.w = halfWidth
  elseif f.w >= halfWidth and f.w < threeQuarterWidth then
    f.w = threeQuarterWidth
  else
    f.w = oneQuarterWidth
  end

  f.y = screenFrame.y
  f.h = screenFrame.h

  win:setFrame(f)
end)

hs.hotkey.bind({ "command", "option" }, "]", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local screenFrame = screen:frame()

  local fullWidth = screenFrame.w
  local halfWidth = math.floor(fullWidth / 2)
  local oneQuarterWidth = math.floor(fullWidth  / 4)
  local threeQuarterWidth = fullWidth - oneQuarterWidth

  if f.w >= 0 and f.w < halfWidth then
    f.x = screenFrame.x + halfWidth
    f.w = halfWidth
  elseif f.w >= halfWidth and f.w < threeQuarterWidth then
    f.x = screenFrame.x + oneQuarterWidth
    f.w = threeQuarterWidth
  else
    f.x = screenFrame.x + threeQuarterWidth
    f.w = oneQuarterWidth
  end

  f.y = screenFrame.y
  f.h = screenFrame.h

  win:setFrame(f)
end)

hs.hotkey.bind({ "command", "option" }, "return", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local screenFrame = screen:frame()

  f.x = screenFrame.x
  f.y = screenFrame.y
  f.w = screenFrame.w
  f.h = screenFrame.h
  win:setFrame(f)
end)
