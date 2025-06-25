local M = {}

-- 模板目录
local template_dir = vim.fn.stdpath("config") .. "/templates"

-- 占位符替换函数
local function apply_template_vars(lines, filepath)
  local filename = vim.fn.fnamemodify(filepath, ":t")
  local date    = os.date("%Y-%m-%d")
  local year    = os.date("%Y")

  for i, line in ipairs(lines) do
    line = line:gsub("%${FILE}", filename)    -- 如果你要匹配 ${FILE}，则用 "%${FILE}"
               :gsub("%${DATE}", date)
               :gsub("%${YEAR}", year)
    lines[i] = line
  end
  return lines
end

-- 主逻辑：新文件事件
vim.api.nvim_create_autocmd("BufNewFile", {
  pattern = "*.*",  -- 只有带后缀的文件
  callback = function(ctx)
    local ext = ctx.match:match("^.+%.([^%.]+)$")
    if not ext then return end

    -- 找模板
    local tpl_path = string.format("%s/%s.tpl", template_dir, ext)
    if vim.fn.filereadable(tpl_path) ~= 1 then
      return
    end

    -- 读文件、替换变量
    local tpl_lines = vim.fn.readfile(tpl_path)
    tpl_lines = apply_template_vars(tpl_lines, ctx.match)

    -- 插入到 buffer 顶部
    vim.api.nvim_buf_set_lines(ctx.buf, 0, 0, false, tpl_lines)
  end,
})

return M
