return {
  -- fuzzy finder
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      { "nvim-telescope/telescope-file-browser.nvim" },
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      { "nvim-telescope/telescope-github.nvim" },
      { "pschmitt/telescope-yadm.nvim" },
    },
    cmd = "Telescope",
    keys = {
      {
        "<leader>ff",
        function()
          require("telescope.builtin").find_files()
        end,
        desc = "Find Files",
      },
      {
        "<leader>fg",
        function()
          require("telescope.builtin").live_grep()
        end,
        desc = "Grep files",
      },
      {
        "<leader>bn",
        function()
          require("telescope.builtin").buffers()
        end,
        desc = "List buffers",
      },
      {
        "<leader>help",
        function()
          require("telescope.builtin").help_tags()
        end,
        desc = "List help tags",
      },
      {
        "<leader>gitf",
        function()
          require("telescope.builtin").git_files()
        end,
        desc = "List files under Git control",
      },
      {
        "<leader>ci",
        function()
          require("telescope.builtin").git_commits()
        end,
        desc = "List/Search Git commits",
      },
      {
        "<leader>fb",
        function()
          require("telescope").extensions.file_browser.file_browser()
        end,
        desc = "Browse Files",
      },
    },
    config = function()
      require("telescope").setup({
        pickers = {
          find_files = {
            find_command = { fd, "--type", "f", "--hidden", "--exclude", ".git" },
          },
        },
        extensions = {
          file_browser = {
            -- disables netrw and use telescope-file-browser in its place
            hijack_netrw = true,
          },
        },
      })
      require("telescope").load_extension("fzf")
      require("telescope").load_extension("file_browser")
      require("telescope").load_extension("yadm_files")
      require("telescope").load_extension("gh")
    end,
    version = false, -- telescope did only one release, so use HEAD for now
  },
}
