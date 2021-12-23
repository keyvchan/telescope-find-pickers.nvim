-- telescope modules
local pickers = require("telescope.pickers")
local conf = require("telescope.config").values
local finders = require("telescope.finders")
local actions_state = require("telescope.actions.state")
local actions = require("telescope.actions")
-- telescope-project modules

local M = {}

-- Variables that setup can change
local result_table = {}
local items = vim.fn.getcompletion("Telescope ", "cmdline")
for i, item in ipairs(items) do
	table.insert(result_table, i, item)
end

M.setup = function(setup_config) end

-- This creates a picker with a list of all of the pickers
M.find_pickers = function(opts)
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

				-- TODO: Initial mode doesn't do anything, don't know why either
				vim.api.nvim_command(":Telescope " .. value .. " " .. "initial_mode=insert")
			end)
			return true
		end,
		sorter = conf.file_sorter(opts),
	}):find()
end

return M
