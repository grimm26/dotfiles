local cmd = vim.cmd -- to execute Vim commands e.g. cmd('pwd')
local g = vim.g -- a table to access global variables (let g:something = foo)
local set = vim.opt -- to set options

require("mini.comment").setup({})
require("mini.completion").setup({})
require("mini.indentscope").setup({})
require("mini.surround").setup({})
require("mini.trailspace").setup({})
require("mini.pairs").setup({})
require("gitsigns").setup()
require("telescope").load_extension("fzf")
require("nvim-tree").setup()
-- Most of the lualine config is default, just had it here to show what can be tweaked.
local function diff_source()
  local gitsigns = vim.b.gitsigns_status_dict
  if gitsigns then
    return {
      added = gitsigns.added,
      modified = gitsigns.changed,
      removed = gitsigns.removed
    }
  end
end
require("lualine").setup({
	options = {
		icons_enabled = true,
		theme = "powerline_dark",
		component_separators = { left = "", right = "" },
		section_separators = { left = "", right = "" },
		disabled_filetypes = {},
		always_divide_middle = true,
		globalstatus = false,
	},
	sections = {
		lualine_a = { "mode", },
    lualine_b = { {"b:gitsigns_head", icon = ''}, {"diff", source = diff_source}, "diagnostics" },
		lualine_c = { "filename" },
		lualine_x = { "encoding", "fileformat", "filetype" },
		lualine_y = { "progress" },
		lualine_z = { "location" },
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { "filename" },
		lualine_x = { "location" },
		lualine_y = {},
		lualine_z = {},
	},
	tabline = {},
	extensions = {"nvim-tree"},
})

-- trim EOL whitespace
vim.keymap.set("n", "<leader>ts", MiniTrailspace.trim)

local ts = require("nvim-treesitter.configs")
ts.setup({
	ensure_installed = {
		"bash",
		"c",
		"comment",
		"dockerfile",
		"go",
		"gomod",
		"hcl",
		"html",
		"java",
		"javascript",
		"json",
		"json5",
		"lua",
		"make",
		"nix",
		"perl",
		"php",
		"regex",
		"python",
		"ruby",
		"rust",
		"toml",
		"typescript",
		"vim",
		"vue",
		"yaml",
	},
	highlight = { enable = true },
})

-- maps for telescope
vim.keymap.set("n", "<leader>ff", require('telescope.builtin').find_files)
vim.keymap.set("n", "<leader>fg", require('telescope.builtin').live_grep)
vim.keymap.set("n", "<leader>fb", require('telescope.builtin').buffers)
vim.keymap.set("n", "<leader>fh", require('telescope.builtin').help_tags)
vim.keymap.set("n", "<leader>fgf", require('telescope.builtin').git_files)
vim.keymap.set("n", "<leader>fgc", require('telescope.builtin').git_commits)
vim.keymap.set("", "<C-n>", ":NvimTreeToggle<cr>")
-- shfmt options
g.shfmt_extra_args = "-i 2 -bn -ci"
g.shfmt_fmt_on_save = 1
-- spelling
-- turn off vim builtin spelling, cuz we using spelunker
set.spell = false
-- Enable spelunker.vim. (default: 1)
-- 1: enable
-- 0: disable
g.enable_spelunker_vim = 0

-- Enable spelunker.vim on readonly files or buffer. (default: 0)
-- 1: enable
-- 0: disable
g.enable_spelunker_vim_on_readonly = 0

-- Check spelling for words longer than set characters. (default: 4)
g.spelunker_target_min_char_len = 4

-- Max amount of word suggestions. (default: 15)
g.spelunker_max_suggest_words = 15

-- Max amount of highlighted words in buffer. (default: 100)
g.spelunker_max_hi_words_each_buf = 100

-- Spellcheck type: (default: 1)
-- 1: File is checked for spelling mistakes when opening and saving. This
-- may take a bit of time on large files.
-- 2: Spellcheck displayed words in buffer. Fast and dynamic. The waiting time
-- depends on the setting of CursorHold `set updatetime=1000`.
g.spelunker_check_type = 2

-- Option to disable word checking.
-- Disable URI checking. (default: 0)
g.spelunker_disable_uri_checking = 1

-- Disable email-like words checking. (default: 0)
g.spelunker_disable_email_checking = 1

-- Disable account name checking, e.g. @foobar, foobar@. (default: 0)
-- NOTE: Spell checking is also disabled for JAVA annotations.
g.spelunker_disable_account_name_checking = 1

-- Disable acronym checking. (default: 0)
g.spelunker_disable_acronym_checking = 1

-- Disable checking words in backtick/backquote. (default: 0)
g.spelunker_disable_backquoted_checking = 1

-- Disable default autogroup. (default: 0)
g.spelunker_disable_auto_group = 0
-- Override highlight setting.
-- highlight SpelunkerSpellBad cterm=underline ctermfg=247 gui=underline guifg=#9e9e9e
-- highlight SpelunkerComplexOrCompoundWord cterm=underline ctermfg=NONE gui=underline guifg=NONE
g.spelunker_white_list_for_user = { "kamykn", "vimrc", "keisler", "syntastic", "solarized", "powerline", "shfmt" }

-- LSP settings
local lspconfig = require("lspconfig")
local on_attach = function(_, bufnr)
	local opts = { noremap = true, silent = true }
	vim.api.nvim_buf_set_keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
	vim.api.nvim_buf_set_keymap(
		bufnr,
		"n",
		"<leader>wl",
		"<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>",
		opts
	)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
	vim.api.nvim_buf_set_keymap(
		bufnr,
		"n",
		"<leader>so",
		[[<cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>]],
		opts
	)
  vim.api.nvim_create_user_command("Format", vim.lsp.buf.formatting, {})
end

-- nvim-cmp supports additional completion capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

-- Enable the following language servers
local servers = {
	"terraformls",
	-- 'tflint', Leaves server laying around
	"pyright",
}
for _, lsp in ipairs(servers) do
	lspconfig[lsp].setup({
		on_attach = on_attach,
		capabilities = capabilities,
	})
end
-- disable formatting for terraformls, null-ls + terraform_fmt will do it
require("lspconfig").terraformls.setup({
	on_attach = function(client)
		client.resolved_capabilities.document_formatting = false
		client.resolved_capabilities.document_range_formatting = false
	end,
})
vim.api.nvim_create_autocmd("BufWritePre", { callback = vim.lsp.buf.formatting_sync, pattern = {"*.tf", "*.tfvars"} })

-- commenting out snip and cmp setup for now cuz I don't know how to make it work :)
-- It was just copied from https://github.com/nvim-lua/kickstart.nvim/blob/master/init.lua
-- luasnip setup
-- local luasnip = require("luasnip")
--
-- -- nvim-cmp setup
-- local cmp = require("cmp")
-- cmp.setup({
-- 	snippet = {
-- 		expand = function(args)
-- 			require("luasnip").lsp_expand(args.body)
-- 		end,
-- 	},
-- 	mapping = {
-- 		["<C-p>"] = cmp.mapping.select_prev_item(),
-- 		["<C-n>"] = cmp.mapping.select_next_item(),
-- 		["<C-d>"] = cmp.mapping.scroll_docs(-4),
-- 		["<C-f>"] = cmp.mapping.scroll_docs(4),
-- 		["<C-Space>"] = cmp.mapping.complete(),
-- 		["<C-e>"] = cmp.mapping.close(),
-- 		["<CR>"] = cmp.mapping.confirm({
-- 			behavior = cmp.ConfirmBehavior.Replace,
-- 			select = true,
-- 		}),
-- 		["<Tab>"] = function(fallback)
-- 			if cmp.visible() then
-- 				cmp.select_next_item()
-- 			elseif luasnip.expand_or_jumpable() then
-- 				luasnip.expand_or_jump()
-- 			else
-- 				fallback()
-- 			end
-- 		end,
-- 		["<S-Tab>"] = function(fallback)
-- 			if cmp.visible() then
-- 				cmp.select_prev_item()
-- 			elseif luasnip.jumpable(-1) then
-- 				luasnip.jump(-1)
-- 			else
-- 				fallback()
-- 			end
-- 		end,
-- 	},
-- 	sources = {
-- 		{ name = "nvim_lsp" },
-- 		{ name = "luasnip" },
-- 	},
-- })

require("null-ls").setup({
	sources = {
		require("null-ls").builtins.formatting.terrafmt,
		require("null-ls").builtins.formatting.terraform_fmt,
		require("null-ls").builtins.formatting.isort,
		require("null-ls").builtins.diagnostics.flake8,
		require("null-ls").builtins.diagnostics.selene,
	},
	on_attach = function(client)
		if client.resolved_capabilities.document_formatting then
			cmd([[
		    augroup LspFormatting
		      autocmd! * <buffer>
		      autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()
		    augroup END
		  ]])
	 	end
	end,
})

-- vim: ts=2 sts=2 sw=2 et
