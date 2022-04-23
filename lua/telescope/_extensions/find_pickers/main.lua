-- telescope modules
local pickers = require("telescope.pickers")
local conf = require("telescope.config").values
local finders = require("telescope.finders")
local actions_state = require("telescope.actions.state")
local actions = require("telescope.actions")
local themes = require("telescope.themes")
local builtin_pickers = require("telescope.builtin")
local extensions_pickers = require("telescope._extensions")

-- telescope-project modules

local M = {}

M.setup = function(setup_config) end

-- This creates a picker with a list of all of the pickers
M.find_pickers = function(opts)
	local opts_find_pickers = opts or themes.get_dropdown(opts)

	local opts_pickers = {
		bufnr = vim.api.nvim_get_current_buf(),
		winnr = vim.api.nvim_get_current_win(),
	}

	-- Variables that setup can change
	local result_table = {}
	local builtin_list = vim.tbl_keys(builtin_pickers)
	local extensions_list = vim.tbl_keys(extensions_pickers.manager)

	for i, item in ipairs(builtin_list) do
		table.insert(result_table, i, item)
	end
	for i, item in ipairs(extensions_list) do
		table.insert(result_table, i, item)
	end

	pickers.new(opts_find_pickers or {}, {
		prompt_title = "Find Pickers",
		results_title = "Picker",
		finder = finders.new_table({
			results = result_table,
		}),
		attach_mappings = function(prompt_bufnr, map)
			actions.select_default:replace(function()
				local selection = actions_state.get_selected_entry()
				local value = selection.value

				actions.close(prompt_bufnr)
				if builtin_pickers[value] ~= nil then
					builtin_pickers[value](opts_pickers)
				elseif extensions_pickers.manager[value] ~= nil then
					extensions_pickers.manager[value][value](opts_pickers)
				end
			end)
			return true
		end,
		sorter = conf.file_sorter(opts_find_pickers),
	}):find()
end

return M
