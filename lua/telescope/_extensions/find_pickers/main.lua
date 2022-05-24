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
local sub_pickers = {}

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
				local current_picker = actions_state.get_current_picker(prompt_bufnr)

				if vim.tbl_isempty(sub_pickers) == false then
					actions.close(prompt_bufnr)
					sub_pickers[value](opts_pickers)
					sub_pickers = {}
					return
				end

				if builtin_pickers[value] ~= nil then
					actions.close(prompt_bufnr)
					builtin_pickers[value](opts_pickers)
					return
				end
				if extensions_pickers.manager[value] ~= nil then
					-- check table or function
					if type(extensions_pickers.manager[value]) == "function" then
						actions.close(prompt_bufnr)
						extensions_pickers.manager[value](opts_pickers)
					else
						local results_table = vim.tbl_keys(extensions_pickers.manager[value])
						local final_results = {}
						for i, item in ipairs(results_table) do
							-- vim.notify(vim.inspect(item == "_picker"))
							if item ~= "_picker" then
								if item ~= "finder" then
									if item ~= "actions" then
										-- vim.notify("insert")
										table.insert(final_results, item)
									end
								end
							end
						end
						if vim.tbl_count(final_results) == 1 then
							actions.close(prompt_bufnr)
							extensions_pickers.manager[final_results[1]][final_results[1]](opts_pickers)
							return
						end

						local finder = finders.new_table({
							results = final_results,
						})
						sub_pickers = extensions_pickers.manager[value]
						current_picker:refresh(finder, { reset_prompt = true })
					end
				end
			end)
			return true
		end,
		sorter = conf.file_sorter(opts_find_pickers),
	}):find()
end

return M
