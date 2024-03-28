-- https://github.com/L3MON4D3/LuaSnip/blob/master/Examples/snippets.lua
-- https://github.com/rafamadriz/friendly-snippets/tree/main/snippets

local luasnip = require 'luasnip'

local s = luasnip.snippet
local t = luasnip.text_node
local i = luasnip.insert_node

luasnip.add_snippets("all", {
  s(
    "de",
    {t("require 'debug'; debugger")}
  ),
  s(
    "pr",
    {t("require 'pry'; binding.pry")}
  ),
  s(
    "cl",
    {t("console.log('"), i(1, "message"), t("');")}
  ),
})
