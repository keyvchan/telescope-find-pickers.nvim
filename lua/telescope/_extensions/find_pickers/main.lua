-- telescope modules
local pickers = require("telescope.pickers")
local conf = require("telescope.config").values
local finders = require("telescope.finders")
local actions_state = require("telescope.actions.state")
local actions = require("telescope.actions")
local themes = require("telescope.themes")
-- telescope-project modules

local M = {}

-- Variables that setup can change
local result_table = {}
local builtin_list = vim.tbl_keys(require("telescope.builtin"))
local extensions_list = vim.tbl_keys(require("telescope._extensions").manager)

for i, item in ipairs(builtin_list) do
	table.insert(result_table, i, item)
end
for i, item in ipairs(extensions_list) do
	table.insert(result_table, i, item)
end

local bufnr = vim.fn.bufnr("%")
local winnr = vim.fn.winnr("#")

M.setup = function(setup_config) end

-- This creates a picker with a list of all of the pickers
M.find_pickers = function(opts)
	opts = opts or themes.get_dropdown()

	pickers.new(opts or {}, {
		prompt_title = "Find Pickers",
		results_title = "Picker",
		finder = finders.new_table({
			results = result_table,
		}),
		attach_mappings = function(prompt_bufnr, map)
			actions.select_default:replace(function()
				local selection = actions_state.get_selected_entry()
				local value = selection.value
				vim.notify(vim.inspect(bufnr))
				vim.notify(vim.inspect(winnr))

				-- TODO: Initial mode doesn't do anything, don't know why either
				require("telescope.builtin")[value]({
					bufnr = bufnr,
					winnr = winnr,
				})
				-- vim.api.nvim_command("Telescope " .. value .. " " .. "initial_mode=insert")
			end)
			return true
		end,
		sorter = conf.file_sorter(opts),
	}):find()
end

return M
