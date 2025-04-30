local cmp = require 'cmp'
local lspconfig = require('lspconfig')
local lsp = vim.lsp

local capabilities = require('cmp_nvim_lsp').default_capabilities(
  vim.lsp.protocol.make_client_capabilities()
)

capabilities.textDocument.completion.completionItem.snippetSupport = false

cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = {
    -- Tab: 切换补全条目或插入 Tab
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item() -- 切换到下一个补全条目
      else
        fallback()             -- 插入 Tab 字符
      end
    end, { 'i', 's' }),        -- i 代表插入模式，s 代表选择模式

    -- Shift+Tab: 切换到上一个补全条目
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item() -- 切换到上一个补全条目
      else
        fallback()             -- 插入 Shift+Tab 字符
      end
    end, { 'i', 's' }),

    -- 方向向下: 切换补全条目
    ['<Down>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item() -- 切换到下一个补全条目
      else
        fallback()             -- 向下移动
      end
    end, { 'i', 's' }),        -- i 代表插入模式，s 代表选择模式

    -- 方向向上: 切换到上一个补全条目
    ['<Up>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item() -- 切换到上一个补全条目
      else
        fallback()             -- 向上移动
      end
    end, { 'i', 's' }),

    -- 定义跳转
    ['<Leader>d'] = vim.lsp.buf.definition, -- 跳转到定义

    -- 查找引用
    ['<F24>'] = vim.lsp.buf.references, -- 查找引用: Shift+F12

    -- 查看文档
    ['<Leader>h'] = vim.lsp.buf.hover,          -- 查看文档
    ['<F12>'] = vim.lsp.buf.implementation,     -- 跳转到实现
    ['<Leader>s'] = vim.lsp.buf.signature_help, -- 查看函数签名
    ['<Esc>'] = cmp.mapping.abort(),

    -- Enter键的映射
    ['<CR>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.confirm({ select = true }) -- 如果补全条目可见，选择当前条目
      else
        fallback()                     -- 否则执行回车操作
      end
    end, { 'i', 's' }),                -- i 代表插入模式，s 代表选择模式
  },
  sources = {
    { name = 'nvim_lsp' },    -- LSP 补全源
    { name = 'buffer' },      -- 缓冲区补全源
    { name = 'path' },        -- 路径补全源
    { name = 'luasnip' },     -- LuaSnip 补全源
  },
})

vim.lsp.inlay_hint.enable(true) -- 启用 inlay hints

-- 配置 LSP 服务器
local on_attach = function(client, bufnr)
  -- 使用 LSP 功能
  -- 默认映射可以添加到这里，例如跳转到定义、查找引用、查看文档等。
  local buf_map = function(mode, lhs, rhs)
    vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, { noremap = true, silent = true })
  end

  require("lsp-inlayhints").on_attach(client, bufnr)

  -- 跳转到定义
  buf_map('n', '<F12>', '<Cmd>lua vim.lsp.buf.definition()<CR>')

  -- 查找引用 Shift + F12
  buf_map('n', '<F24>', '<Cmd>lua vim.lsp.buf.references()<CR>')

  -- 查看函数签名
  buf_map('n', '<Leader>s', '<Cmd>lua vim.lsp.buf.signature_help()<CR>')

  -- 查看函数文档
  buf_map('n', '<Leader>h', '<Cmd>lua vim.lsp.buf.hover()<CR>')

  -- 跳转到实现
  buf_map('n', '<F12>', '<Cmd>lua vim.lsp.buf.implementation()<CR>')

  -- 使用 LSP 格式化代码的快捷键
  -- vim.api.nvim_set_keymap('n', '<C-s-i>', '<Cmd>lua vim.lsp.buf.formatting()<CR>', { noremap = true, silent = true })
  buf_map('n', '<C-I>', '<Cmd>lua vim.lsp.buf.format()<CR>')
end

-- 配置 C++、Python 和 Lua 的 LSP
lspconfig.clangd.setup({
  on_attach = on_attach, -- C++ LSP
  cmd = {
    "clangd",
    "--compile-commands-dir=build", -- 设置编译命令目录（如果有）
    "--clang-tidy",                 -- 启用 clang-tidy
    "--fallback-style=google",      -- 设置代码风格
    "--header-insertion=iwyu",      -- 启用 "Include What You Use" (IWYU)
    "--inlay-hints",
    "--completion-style=detailed",
    "--function-arg-placeholders=0",
  },
  settings = {
    clangd = {
      InlayHints = {
        Designators = true,
        Enabled = true,
        ParameterNames = true,
        DeducedTypes = true
      },
      Hover = {
        ShowAKA = true
      }
    },
  },
})

lspconfig.pyright.setup({
  on_attach = on_attach, -- Python LSP
})

lspconfig.lua_ls.setup({
  on_attach = on_attach, -- Lua LSP
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
      },
      diagnostics = {
        globals = { 'vim' }, -- 将 vim 识别为全局变量
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true), -- 将 Neovim 的 runtime 文件夹添加到 workspace 库中
      },
      telemetry = {
        enable = false, -- 禁用遥测数据
      },
    },
  },
})

lspconfig.marksman.setup({
  on_attach = on_attach,
  cmd = {
    "marksman", "server",
  }
})

lspconfig.texlab.setup({
  on_attach = on_attach, -- 使用相同的 on_attach 配置
  settings = {
    texlab = {
      build = {
        executable = "xelatex",                              -- 你可以根据需要调整构建工具
        args = { "-pdf", "-interaction=nonstopmode", "%f" }, -- LaTeX 编译选项
        onSave = true,                                       -- 保存时自动构建
      },
      forwardSearch = {
        executable = "zathura", -- 或者你喜欢的 PDF 查看器
        args = { "--synctex-forward", "%l:%c:%f", "%p" },
      },
    },
  },
  -- filetypes = { "tex", "latex", "bib" }, -- 支持 LaTeX 和 BibTeX 文件
})

vim.o.updatetime = 300

-- -- 启用自动显示文档
-- vim.api.nvim_create_autocmd('CursorHold', {
--   callback = function()
--     -- 如果鼠标停留在有效的 LSP 位置，显示 hover 文档
--     if vim.lsp.get_clients() then
--       vim.lsp.buf.signature_help()
--     end
--   end,
--   desc = 'Automatically show hover documentation when the cursor holds',
-- })

-- 智能暗示
-- require("lsp-inlayhints").setup()

lsp.inlay_hint.enable()
