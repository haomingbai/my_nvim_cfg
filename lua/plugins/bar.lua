-- Lualine
require('lualine').setup({
  options = {
    icons_enabled = false,
    theme = 'powerline',
    component_separators = { '|', '|' },   -- 使用竖线分隔组件
    section_separators = { '-', '-' },     -- 使用横线分隔部分
  },
})
