-- 映射快捷键 运行代码
vim.api.nvim_set_keymap('n', '<F5>', '<Cmd>lua require("code_runner").run_code()<CR>', { noremap = true, silent = true })

require('code_runner').setup({
  -- 配置不同语言的运行命令
  filetype = {
    python = function(...)
      local py_run = {
        "python3",
        "-u",
        "$fileName",
      }
      vim.fn.execute("silent! write")
      require("code_runner.commands").run_from_fn(py_run)
    end,
    javascript = "node",
    c = function(...)
      c_base = {
        "cd $dir &&",
        "gcc $fileName -o",
        "/tmp/$fileNameWithoutExt",
        "-Wall",
      }
      local c_exec = {
        "&& time /tmp/$fileNameWithoutExt &&",
        "rm /tmp/$fileNameWithoutExt",
      }
      vim.fn.execute("silent! write")
      vim.ui.input({ prompt = "Add more args:" }, function(input)
        c_base[4] = input
        vim.print(vim.tbl_extend("force", c_base, c_exec))
        require("code_runner.commands").run_from_fn(vim.list_extend(c_base, c_exec))
      end)
    end,
    cpp = function(...)
      cpp_base = {
        "cd $dir &&",
        "g++ -std=c++23 $fileName -o",
        "/tmp/$fileNameWithoutExt",
        "-Wall",
      }
      local c_exec = {
        "&& time /tmp/$fileNameWithoutExt &&",
        "rm /tmp/$fileNameWithoutExt",
      }
      vim.fn.execute("silent! write")
      vim.ui.input({ prompt = "Add more args:" }, function(input)
        cpp_base[4] = input
        vim.print(vim.tbl_extend("force", cpp_base, c_exec))
        require("code_runner.commands").run_from_fn(vim.list_extend(cpp_base, c_exec))
      end)
    end,
  }
})
