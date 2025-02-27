return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      diff_opts = {
        internal = true,
      },
      current_line_blame = false,
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
        delay = 1000,
        ignore_whitespace = false,
      },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map("n", "]c", function()
          if vim.wo.diff then
            return "]c"
          end
          vim.schedule(function()
            gs.next_hunk()
          end)
          return "<Ignore>"
        end, { expr = true })

        map("n", "[c", function()
          if vim.wo.diff then
            return "[c"
          end
          vim.schedule(function()
            gs.prev_hunk()
          end)
          return "<Ignore>"
        end, { expr = true })

        -- Actions
        map({ "n", "v" }, "<leader>hs", ":Gitsigns stage_hunk<CR>")
        map({ "n", "v" }, "<leader>hr", ":Gitsigns reset_hunk<CR>")
        map("n", "<leader>hS", gs.stage_buffer)
        map("n", "<leader>hu", gs.undo_stage_hunk)
        map("n", "<leader>hR", gs.reset_buffer)
        map("n", "<leader>hp", gs.preview_hunk)
        map("n", "<leader>hb", function()
          gs.blame_line({ full = true })
        end)
        -- map("n", "<leader>gbl", gs.blame_line)
        -- map("n", "<leader>tb", gs.toggle_current_line_blame)
        map("n", "<leader>hd", gs.diffthis)
        map("n", "<leader>hD", function()
          gs.diffthis("~")
        end)
        map("n", "<leader>td", gs.toggle_deleted)

        -- Text object
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
      end,
    },
  },
  {
    "pwntester/octo.nvim",
    enabled = false,
    cmd = "Octo",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
    opts = {
      github_hostname = vim.env.GH_HOST, -- GitHub Enterprise host (if set)
    },
  },
  {
    "tpope/vim-fugitive",
    enabled = false,
    cmd = "Git",
  },
  {
    "NeogitOrg/neogit",
    cmd = "Neogit",
    dependencies = {
      "nvim-lua/plenary.nvim", -- required
      "sindrets/diffview.nvim", -- optional - Diff integration
      "nvim-telescope/telescope.nvim", -- optional
    },
    keys = {
      {
        "<leader>gg",
        "<cmd>Neogit<cr>",
        desc = "Open Neogit",
      },
    },
    lazy = true,
    opts = {
      graph_style = "kitty",
      git_services = {
        ["github.com"] = "https://github.com/${owner}/${repository}/compare/${branch_name}?expand=1",
        ["git.enova.com"] = "https://git.enova.com/${owner}/${repository}/compare/${branch_name}?expand=1",
      },
      kind = "split_below_all",
      commit_editor = {
        kind = "floating",
      },
      commit_select_view = {
        kind = "floating",
      },
      commit_view = {
        kind = "floating",
      },
      log_view = {
        kind = "split_below_all",
      },
    },
  },
  {
    "sindrets/diffview.nvim",
    keys = {
      {
        "<leader>gdo",
        "<cmd>DiffviewOpen<cr>",
        desc = "Open Diff view",
      },
      {
        "<leader>gdh",
        "<cmd>DiffviewFileHistory<cr>",
        desc = "Repo history",
      },
      {
        "<leader>gdf",
        "<cmd>DiffviewFileHistory --follow %<cr>",
        desc = "File history",
      },
      {
        "<leader>gdl",
        "<cmd>.DiffviewFileHistory --follow<cr>",
        desc = "Line history",
      },
    },
    opts = {},
  },
}
