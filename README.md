# telescope-find-pickers.nvim

Find all pickers available (includes `builtins` and `extensions`)

https://user-images.githubusercontent.com/28680236/147249475-d0729f2d-01cc-45d0-9ab8-b4ac511ecc24.mov

## Installation

### Use Packer.nvim

Install it along with `telescope.nvim`

```lua
-- without lazy-load
use({
  "keyvchan/telescope-find-pickers.nvim"
})

-- load it in your config
require('telescope').load_extension('find_pickers')
```

## Config

### Keymap

My personal preference is using double `<leader>` to activate it. Here just an example. You should probably define your own keymap.

```lua
-- neovim < 0.7
vim.api.nvim_set_keymap(
  "n",
  "<leader><leader>",
  "<CMD>lua require 'telescope'.extensions.find_pickers.find_pickers()<CR>",
  {
    noremap = true,
    silent = true,
  }
)

-- neovim >= 0.7
vim.keymap.set(
  "n",
  "<leader><leader>",
  require('telescope').extensions.find_pickers.find_pickers
)
```
