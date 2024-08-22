-- https://github.com/L3MON4D3/ls/blob/master/Examples/snippets.lua
-- https://github.com/rafamadriz/friendly-snippets/tree/main/snippets

local ls = require 'luasnip'

local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

ls.add_snippets("all", {
  s(
    "de",
    { t("require 'debug'; debugger") }
  ),
  s(
    "pr",
    { t("require 'pry'; binding.pry") }
  ),
  s(
    "cl",
    { t("console.log('"), i(1, "message"), t("');") }
  ),
  s(
    "ta",
    ls.text_node({
      "| Before | After |",
      "| ------ | ----- |",
      '| <img src="" width=300 /> | <img src="" width=300 /> |',
    })
  ),
})
