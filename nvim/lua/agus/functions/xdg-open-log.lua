local M = {}

M.xdgOpenLog = (function(n)
		local n = n or 1

		local home = os.getenv('HOME')
		local output = vim.system(
			{ 'tail', '-n', n, home .. '/.xdg-open.log' },
			{ text = true }
		):wait()

		local stdout = output.stdout:match( "^%s*(.-)%s*$" )
		if stdout == '' then
			stdout = nil
		end

		local stderr = output.stderr:match( "^%s*(.-)%s*$" )
		print(stdout or stderr)
	end
)

vim.api.nvim_create_user_command(
	'XdgOpenLog',
	function(opts)	  
		local opts = opts or {}
		local args = opts['args'] or ''
		if args ~= '' and not args:match('^%d+$') then
			print('Invalid argument. Please provide a number.')
			return
		end

		M.xdgOpenLog(tonumber(args) or 1)
	end,
	{
		nargs = '?',
	}
)

return M
