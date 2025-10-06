-- 配置 Mason 插件
require('mason').setup()

-- 配置 Mason-LSPConfig 插件
require('mason-lspconfig').setup({
  ensure_installed = { "clangd", "pyright", "lua_ls", "marksman", "texlab", "asm_lsp", "rust_analyzer", "glsl_analyzer", "pyright" },  -- 自动安装的 LSP 服务器
})
