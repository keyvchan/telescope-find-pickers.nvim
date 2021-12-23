# telescope-find-pickers.nvim

Find all pickers available (includes `builtin` and `extension`)

https://user-images.githubusercontent.com/28680236/147249475-d0729f2d-01cc-45d0-9ab8-b4ac511ecc24.mov

## Installation

### Use Packer.nvim

Install it along with `telescope.nvim`

```lua
use({
  "keyvchan/telescope-find-pickers.nvim"
  requires = {
    "telescope/telescope.nvim"
  }
})
```
## Config

### Keymap
Use double `<leader>` to activate this picker.

```lua
vim.api.nvim_set_keymap(
	"n",
	"<leader><leader>",
	"<CMD>lua require 'telescope'.extensions.find_pickers.find_pickers()<CR>",
	{
		noremap = true,
		silent = true,
	}
)
```
