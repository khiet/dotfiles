return {
  {
    "vimwiki/vimwiki",
    branch = "dev",
    config = function()
      vim.g.vimwiki_list = {{
          path = (os.getenv("DEVS_HOME") .. "/vim/notes/vimwiki"),
          syntax = 'markdown',
          ext = '.md'
      }}

      vim.g.vimwiki_key_mappings = {{
          all_maps = 1,
          global = 0,
          headers = 0,
          text_objs = 0,
          table_format = 0,
          table_mappings = 0,
          lists = 0,
          links = 1,
          html = 0,
          mouse = 0,
      }}

      vim.cmd("au BufWinEnter *.md setlocal syntax=markdown")
    end
  }
}

