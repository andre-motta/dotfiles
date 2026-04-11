return {
	-- File tree
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
		},
		keys = {
			{ "<leader>e", ":Neotree toggle<CR>", desc = "Toggle file explorer" },
		},
		opts = {
			filesystem = {
				follow_current_file = { enabled = true },
				filtered_items = {
					visible = true,
					hide_dotfiles = false,
					hide_gitignored = false,
				},
			},
			window = { width = 30 },
		},
	},

	-- Fuzzy finder
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		},
		keys = {
			{ "<leader>ff", ":Telescope find_files<CR>", desc = "Find files" },
			{ "<leader>fg", ":Telescope live_grep<CR>", desc = "Grep text" },
			{ "<leader>fb", ":Telescope buffers<CR>", desc = "Find buffers" },
			{ "<leader>fh", ":Telescope help_tags<CR>", desc = "Help tags" },
			{ "<leader>fr", ":Telescope oldfiles<CR>", desc = "Recent files" },
			{ "<leader>fd", ":Telescope diagnostics<CR>", desc = "Diagnostics" },
		},
		config = function()
			local telescope = require("telescope")
			telescope.setup({
				defaults = {
					file_ignore_patterns = { "node_modules", "__pycache__", ".git/" },
				},
			})
			telescope.load_extension("fzf")
		end,
	},

	-- Treesitter (syntax highlighting)
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			local ensure = {
				"python", "lua", "vim", "vimdoc", "json", "yaml",
				"toml", "bash", "markdown", "markdown_inline",
				"dockerfile", "gitignore",
			}
			for _, lang in ipairs(ensure) do
				vim.treesitter.language.add(lang)
			end
			vim.api.nvim_create_autocmd("FileType", {
				callback = function(args)
					pcall(vim.treesitter.start, args.buf)
				end,
			})
		end,
	},

	-- Git signs in gutter
	{
		"lewis6991/gitsigns.nvim",
		opts = {
			signs = {
				add = { text = "│" },
				change = { text = "│" },
				delete = { text = "󰍵" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
		},
	},

	-- Auto pairs
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		opts = {},
	},

	-- Comment toggle
	{
		"numToStr/Comment.nvim",
		keys = {
			{ "gcc", mode = "n", desc = "Toggle comment" },
			{ "gc", mode = "v", desc = "Toggle comment" },
		},
		opts = {},
	},

	-- Surround
	{
		"kylechui/nvim-surround",
		version = "*",
		event = "VeryLazy",
		opts = {},
	},

	-- Todo comments
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {},
	},

	-- Lazygit inside neovim
	{
		"kdheepak/lazygit.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		keys = {
			{ "<leader>gg", ":LazyGit<CR>", desc = "Open LazyGit" },
		},
	},

	-- Render markdown in-terminal
	{
		"MeanderingProgrammer/render-markdown.nvim",
		ft = { "markdown" },
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
		opts = {},
	},
}
