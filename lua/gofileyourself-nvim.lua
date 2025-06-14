local SELECTED_FILEPATH = vim.fn.stdpath("cache") .. "/gofileyourself_selected_files"

local M = {}

---@class UI
---@field border string (see ':h nvim_open_win')
---@field height number from 0 to 1 (0 = 0% of screen and 1 = 100% of screen)
---@field width number from 0 to 1 (0 = 0% of screen and 1 = 100% of screen)
---@field x number from 0 to 1 (0 = left most of screen and 1 = right most of
---screen)
---@field y number from 0 to 1 (0 = top most of screen and 1 = bottom most of
---screen)
local opts = {
	ui = {
		border = "none",
		height = 0.6,
		width = 1,
		x = 0.5,
		y = 0.5,
	},
}

---@param filepath string
---@param open function
local function open_files(filepath, open)
	local selected_files = vim.fn.readfile(filepath)
	for _, file in ipairs(selected_files) do
		open(file)
	end
end

local function build_gofileyourself_cmd()
	local selected_file = ""
	if vim.fn.expand("%") then
		selected_file = "'" .. vim.fn.expand("%") .. "'"
	end
	return string.format("gofileyourself --choosefiles=%s --selectfile=%s", SELECTED_FILEPATH, selected_file)
end

local function open_win()
	local buf = vim.api.nvim_create_buf(false, true)
	local win_height = math.ceil(vim.o.lines * opts.ui.height)
	local win_width = math.ceil(vim.o.columns * opts.ui.width)
	local row = math.ceil((vim.o.lines - win_height) * opts.ui.y - 1)
	local col = math.ceil((vim.o.columns - win_width) * opts.ui.x)
	local win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = win_width,
		height = win_height,
		border = opts.ui.border,
		row = row,
		col = col,
		style = "minimal",
	})
	vim.api.nvim_win_set_option(win, "winhl", "NormalFloat:Normal")
	vim.api.nvim_buf_set_option(buf, "filetype", "gofileyourself")
end

---Clean up temporary files used to communicate between ranger and the plugin.
local function clean_up()
	vim.fn.delete(SELECTED_FILEPATH)
end

---@return function
local function get_open_func()
	local open = {
		current_win = function(filepath)
			vim.cmd.edit(filepath)
		end,
	}
	return open.current_win
end

function M.open()
	clean_up()

	local cmd = build_gofileyourself_cmd()
	local last_win = vim.api.nvim_get_current_win()
	open_win()
	vim.fn.termopen(cmd, {
		on_exit = function()
			vim.api.nvim_win_close(0, true)
			vim.api.nvim_set_current_win(last_win)
			if vim.fn.filereadable(SELECTED_FILEPATH) == 1 then
				open_files(SELECTED_FILEPATH, get_open_func())
			end
			clean_up()
		end,
	})
	vim.cmd.startinsert()
end

function M.setup() end

return M
