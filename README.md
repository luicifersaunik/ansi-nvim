# ansi-nvim

A colorscheme that adapts to your terminal colors through ANSI values

> [!WARNING]
> This extension is still under development; if you experience problems please open an issue!

## Features

- Support for Neovim's built-in LSP
- Treesitter highlighting
- Plugin integrations:
  - Telescope
  - Indent Blankline
  - Nvim-notify
  - Rainbow parentheses
  - Nvim-cmp
  - vim-illuminate
  - LSP semantic tokens
  - mini.completion
  - nvim-dap-ui

## Installation

### Using [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  'stevedylandev/ansi-nvim',
  lazy = false,
  priority = 1000,
  config = function()
    vim.cmd('colorscheme ansi')
    vim.opt.termguicolors = false
  end,
}
```

### Using [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use {
  'stevedylandev/ansi-nvim',
  config = function()
    vim.cmd('colorscheme ansi')
    vim.opt.termguicolors = false
  end
}
```

## Usage

Simply set the colorscheme in your Neovim configuration:

```lua
vim.cmd('colorscheme ansi')
```

If you don't see colors, make sure you have true color tured **off**. This is often turned on for colorschemes

```lua
vim.opt.termguicolors = false
```

## Configuration

You can configure the colorscheme by passing options to the setup function:

```lua
require('ansi').setup({
  -- All options default to true
  telescope = true,          -- Telescope plugin
  telescope_borders = false, -- Telescope borders
  indentblankline = true,    -- Indent-blankline plugin
  notify = true,             -- Nvim-notify plugin
  ts_rainbow = true,         -- Rainbow parentheses
  cmp = true,                -- Nvim-cmp plugin
  illuminate = true,         -- vim-illuminate plugin
  lsp_semantic = true,       -- LSP semantic tokens
  mini_completion = true,    -- mini.completion plugin
  dapui = true,              -- nvim-dap-ui plugin
})
```

## Credits

The base for this plugin is pulled from [base16-nvim](https://github.com/RRethy/base16-nvim)
