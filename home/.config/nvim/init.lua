--
-- Colorscheme
--

vim.cmd.colorscheme('nithub-dark')

--
-- Options
--

vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'
vim.o.clipboard = 'unnamedplus'

vim.o.undofile = true
vim.o.swapfile = false

vim.o.wrap = false
vim.o.linebreak = true
vim.o.breakindent = true
vim.o.scrolloff = 10

vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.inccommand = 'split'
vim.o.updatetime = 300

vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.o.smartindent = true

vim.o.splitright = true
vim.o.splitbelow = true

vim.o.completeopt = 'menuone,noinsert,fuzzy'
vim.o.spell = true
vim.o.spelllang = 'en_us'

vim.o.number = true
vim.o.numberwidth = 1
vim.o.statuscolumn = '%l %s%C'
vim.o.signcolumn = 'yes:1'

vim.o.laststatus = 1
vim.o.rulerformat = '%c  %t%m'

vim.o.cursorline = true
vim.o.cursorlineopt = 'number'

-- Uncomment these two line for pinpoint cursor
-- vim.o.cursorlineopt = 'both'
-- vim.o.cursorcolumn = true

vim.o.winborder = 'rounded'
vim.o.pumborder = 'rounded'

vim.diagnostic.config({
  underline = true,
  -- virtual_text = true,
  signs = true,
  float = true,
  severity_sort = true,
})

--
-- Plugins
--

-- Syntax highlight
vim.pack.add({ 'https://github.com/arborist-ts/arborist.nvim' })
require('arborist').setup()

-- LSP
vim.pack.add({ 'https://github.com/neovim/nvim-lspconfig' })
vim.lsp.config('lua_ls', {
  settings = {
    Lua = {
      workspace = {
        checkThirdParty = false,
        library = { vim.env.VIMRUNTIME },
      },
    },
  },
})
-- Enable even if not in a project/workspace
vim.lsp.config('oxlint', {
  root_markers = {},
  workspace_required = false,
})
vim.lsp.config('qmlls', { cmd = { 'qmlls6' } })
vim.lsp.enable({
  'lua_ls',
  'emmet_language_server',
  'tsc',
  'oxlint',
  'qmlls',
})

-- Formatter
vim.pack.add({ 'https://github.com/stevearc/conform.nvim' })
require('conform').setup({
  formatters_by_ft = {
    lua = { 'stylua' },
    markdown = { 'oxfmt' },
    html = { 'oxfmt' },
    css = { 'oxfmt' },
    javascript = { 'oxfmt' },
    typescript = { 'oxfmt' },
    json = { 'oxfmt' },
    jsonc = { 'oxfmt' },
    toml = { 'oxfmt' },
  },
  format_on_save = { lsp_format = 'fallback', timeout_ms = 500 },
})

-- Code completion
vim.pack.add({ 'https://github.com/nvim-mini/mini.nvim' })
require('mini.icons').setup()
MiniIcons.mock_nvim_web_devicons()
require('mini.completion').setup({ delay = { info = 10000000 } })

-- QOL
require('mini.diff').setup({
  view = {
    style = 'sign',
    signs = { add = '┃', change = '┃', delete = '▶' },
  },
})
require('mini.files').setup()
require('mini.pick').setup()
require('mini.extra').setup()

--
-- Keymaps
--

vim.keymap.set('n', '<Esc>', '<Cmd>nohlsearch<CR>', { desc = 'Remove search highlight' })
vim.keymap.set('n', '<Leader>bb', '<Cmd>b #<CR>', { desc = 'Switch to other buffer' })
vim.keymap.set('n', '<leader>gg', '<Cmd>tabnew | term lazygit<CR>i', { desc = 'LazyGit' })

-- Only use this when making a colorscheme
-- vim.keymap.set('n', '<C-I>', '<Cmd>Inspect<CR>', { desc = 'Inspect highlight group under cursor' })

-- stylua: ignore start
vim.keymap.set({ 'n', 'v' }, '<Leader>ca', function() vim.lsp.buf.code_action() end, { desc = 'Code Action' })
vim.keymap.set('n', '<Leader>cr', function() vim.lsp.buf.rename() end, { desc = 'Rename' })
vim.keymap.set('n', '<leader>pU', function() vim.pack.update() end, { desc = ' Update plugins' })

-- MiniPick & MiniExtra Keymaps
vim.keymap.set('n', '<leader><space>', function() MiniPick.builtin.files() end, { desc = 'Find Files' })
vim.keymap.set('n', '<leader>,', function() MiniPick.builtin.buffers() end, { desc = 'Buffers' })
vim.keymap.set('n', '<leader>/', function() MiniPick.builtin.grep_live() end, { desc = 'Grep' })
vim.keymap.set('n', '<leader>:', function() MiniExtra.pickers.history({ scope = ':' }) end, { desc = 'Command History' })
vim.keymap.set({ 'n', 'x' }, '<leader>sw', function() MiniPick.builtin.grep({ pattern = vim.fn.expand('<cword>') }) end, { desc = 'Word under cursor' })
vim.keymap.set('n', '<leader>sh', function() MiniPick.builtin.help() end, { desc = 'Help Pages' })
vim.keymap.set('n', '<leader>sH', function() MiniExtra.pickers.hl_groups() end, { desc = 'Highlights' })
vim.keymap.set('n', '<leader>sM', function() MiniExtra.pickers.manpages() end, { desc = 'Man Pages' })
vim.keymap.set('n', '<leader>sk', function() MiniExtra.pickers.keymaps() end, { desc = 'Keymaps' })
vim.keymap.set('n', '<leader>sd', function() MiniExtra.pickers.diagnostic() end, { desc = 'Diagnostics' })
vim.keymap.set('n', '<leader>sq', function() MiniExtra.pickers.list({ scope = 'quickfix' }) end, { desc = 'Quickfix List' })
vim.keymap.set('n', 'gd', function() MiniExtra.pickers.lsp({ scope = 'definition' }) end, { desc = 'Goto Definition' })
vim.keymap.set('n', 'gD', function() MiniExtra.pickers.lsp({ scope = 'declaration' }) end, { desc = 'Goto Declaration' })
vim.keymap.set('n', 'gr', function() MiniExtra.pickers.lsp({ scope = 'references' }) end, { desc = 'References' })
vim.keymap.set('n', 'gI', function() MiniExtra.pickers.lsp({ scope = 'implementation' }) end, { desc = 'Goto Implementation' })
vim.keymap.set('n', 'gy', function() MiniExtra.pickers.lsp({ scope = 'type_definition' }) end, { desc = 'Goto Type Definition' })
vim.keymap.set('n', '<leader>ss', function() MiniExtra.pickers.lsp({ scope = 'document_symbol' }) end, { desc = 'LSP Symbols' })
vim.keymap.set('n', '<leader>sS', function() MiniExtra.pickers.lsp({ scope = 'workspace_symbol' }) end, { desc = 'LSP Workspace Symbols' })

-- MiniFiles
vim.keymap.set('n', '<leader>e', function() if vim.bo.filetype ~= 'minifiles' then MiniFiles.open(vim.api.nvim_buf_get_name(0)) end end, { desc = 'Open Explorer' })
-- stylua: ignore end

--
-- Auto commands
--

-- From `:h lua-guide-autocommand-create`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Briefly highlight yanked text',
  callback = function()
    vim.hl.on_yank()
  end,
})

vim.api.nvim_create_autocmd('BufWritePre', {
  desc = 'Remove trailing whitespace on save',
  callback = function()
    local last_pos = vim.fn.getpos('.')
    vim.cmd([[%s/\s\+$//e]])
    vim.fn.setpos('.', last_pos)
  end,
})

vim.api.nvim_create_autocmd('TermOpen', {
  desc = 'Disable spellcheck and search highlight in terminal',
  callback = function()
    vim.opt_local.spell = false
    vim.schedule(function()
      vim.cmd.nohlsearch()
    end)
  end,
})

vim.api.nvim_create_autocmd('TermClose', {
  desc = 'Auto-close terminal buffers if the process exits cleanly',
  callback = function(args)
    if vim.v.event.status == 0 and vim.api.nvim_buf_is_valid(args.buf) then
      vim.api.nvim_buf_delete(args.buf, { force = true })
    end
  end,
})

--
-- User commands
--

vim.api.nvim_create_user_command('Uindent', function(opts)
  local size = tonumber(opts.args)
  vim.o.tabstop = size
  vim.o.softtabstop = size
  vim.o.shiftwidth = size
  print('Indentation set to ' .. size)
end, { nargs = 1 })
