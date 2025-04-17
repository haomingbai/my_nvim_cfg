require('nvim-treesitter.configs').setup {
  -- 安装 language parser
  -- :TSInstallInfo 命令查看支持的语言
  ensure_installed = { "html", "css", "vim", "lua", "javascript", "typescript", "tsx", "cpp", "c", "cuda", "python" },
  -- 启用代码高亮功能
  highlight = {
    enable = true,
  },
  -- 启用增量选择
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<CR>',
      node_incremental = '<CR>',
      node_decremental = '<BS>',
      scope_incremental = '<TAB>',
    }
  },
}
