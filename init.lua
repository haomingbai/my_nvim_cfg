-- 设置基础选项
vim.o.number = true        -- 显示行号
vim.o.relativenumber = true -- 显示相对行号
vim.o.mouse = 'a'          -- 启用鼠标支持
vim.o.hlsearch = true      -- 高亮搜索结果
vim.o.ignorecase = true    -- 搜索时忽略大小写
vim.o.smartcase = true     -- 智能大小写搜索

-- 设置自动缩进
vim.o.tabstop = 2          -- 一个 tab 等于 4 个空格
vim.o.shiftwidth = 2       -- 每次缩进的空格数
vim.o.expandtab = true     -- 使用空格代替 tab
vim.cmd [[
  autocmd FileType markdown setlocal tabstop=2 shiftwidth=2 expandtab
]] -- markdown tab

-- 配置颜色主题
vim.o.termguicolors = true -- 启用 true color 支持
vim.cmd('colorscheme vim') -- 使用默认的颜色主题

-- 插件管理器: Lazy.nvim
require("config.lazy")

-- LSP服务器管理插件设置
require('plugins.mason')

-- 代码补全插件设置
require('plugins.nvim-cmp')

-- 代码运行插件设置
require('plugins.code_runner')

-- 状态栏
require('plugins.bar')
