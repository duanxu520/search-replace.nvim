local M = {}

local util = require("search-replace.util")
local config = require("search-replace.config")

M.search_replace = function(pattern, wholeWord)
	local shift = 0

	if string.len(pattern) == 0 then
		shift = 2
	else
		shift = 1
	end
	local sCall = ':call feedkeys(":%s/'
	local s = "//"
	if wholeWord then
		sCall = ':call feedkeys(":%s/\\\\<'
		s = "\\\\>//"
	end
	
	local left_keypresses =
		string.rep("\\<Left>", string.len(config.options["default_replace_single_buffer_options"]) + shift)
	vim.cmd(
		sCall
			.. util.double_escape(pattern)
			.. s
			.. config.options["default_replace_single_buffer_options"]
			.. left_keypresses
			.. '")'
	)
end

M.visual_charwise_selection = function()
	local visual_selection = util.get_visual_selection()

	if visual_selection == nil then
		print("search-replace does not support visual-blockwise selections")
		return
	end

	local backspace_keypresses = string.rep("\\<backspace>", 5)
	local left_keypresses =
		string.rep("\\<Left>", string.len(config.options["default_replace_single_buffer_options"]) + 1)

	vim.cmd(
		':call feedkeys(":'
			.. backspace_keypresses
			.. "%s/"
			.. util.double_escape(visual_selection)
			.. "//"
			.. config.options["default_replace_single_buffer_options"]
			.. left_keypresses
			.. '")'
	)
end

M.open = function()
	M.search_replace("")
end

M.wword = function()
	M.search_replace(vim.fn.expand("<cword>"), true)
end

M.cword = function()
	M.search_replace(vim.fn.expand("<cword>"))
end

M.cWORD = function()
	M.search_replace(vim.fn.expand("<cWORD>"))
end

M.cexpr = function()
	M.search_replace(vim.fn.expand("<cexpr>"))
end

M.cfile = function()
	M.search_replace(vim.fn.expand("<cfile>"))
end

return M
