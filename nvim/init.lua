-- defaults
vim.o.mouse = ''
vim.cmd('syntax off')
vim.cmd('filetype indent off')

-- enable syntax highlighting, indention, and linters on "B"
vim.api.nvim_create_user_command('B', function()
  vim.cmd('syntax on')
  vim.cmd('filetype indent on')

  -- linters
  -- requires git clone https://github.com/mfussenegger/nvim-lint ~/.config/nvim/pack/plugins/start/nvim-lint
  local ok, lint = pcall(require, "lint")
  if ok then
  local linters_by_ft = {}

    -- lua
    if vim.fn.executable("luacheck") == 1 then
      linters_by_ft.lua = { "luacheck" }
    end

    -- python
    if vim.fn.executable("flake8") == 1 then
      linters_by_ft.python = { "flake8" }
    end

    -- shell
    if vim.fn.executable("shellcheck") == 1 then
      linters_by_ft.sh   = { "shellcheck" }
      linters_by_ft.bash = { "shellcheck" }
      linters_by_ft.ksh  = { "shellcheck" }
    end

    lint.linters_by_ft = linters_by_ft

    vim.api.nvim_create_autocmd({ "BufWritePost" }, {
      callback = function()
        lint.try_lint()
      end,
    })
  else
    vim.notify("nvim-lint not found; skipping linter setup ", vim.log.levels.WARN)
  end
end, {})
