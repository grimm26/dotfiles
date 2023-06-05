return {
  { "rafamadriz/friendly-snippets", lazy = true },
  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      "rafamadriz/friendly-snippets",
      config = function()
        require("luasnip.loaders.from_vscode").lazy_load()
      end,
    },
    opts = {
      history = true,
      delete_check_events = "TextChanged",
    },
    config = function()
      local ls = require("luasnip")
      -- some shorthands...
      local s = ls.snippet
      local sn = ls.snippet_node
      local t = ls.text_node
      local i = ls.insert_node
      local f = ls.function_node
      local c = ls.choice_node
      local d = ls.dynamic_node
      local r = ls.restore_node
      local l = require("luasnip.extras").lambda
      local rep = require("luasnip.extras").rep
      local p = require("luasnip.extras").partial
      local m = require("luasnip.extras").match
      local n = require("luasnip.extras").nonempty
      local dl = require("luasnip.extras").dynamic_lambda
      local fmt = require("luasnip.extras.fmt").fmt
      local fmta = require("luasnip.extras.fmt").fmta
      local types = require("luasnip.util.types")
      local conds = require("luasnip.extras.expand_conditions")

      -- Every unspecified option will be set to the default.
      ls.config.set_config({
        history = true,
        -- Update more often, :h events for more info.
        updateevents = "TextChanged,TextChangedI",
        ext_opts = {
          [types.choiceNode] = {
            active = {
              virt_text = { { "choiceNode", "Comment" } },
            },
          },
        },
        -- treesitter-hl has 100, use something higher (default is 200).
        ext_base_prio = 300,
        -- minimal increase in priority.
        ext_prio_increase = 1,
        enable_autosnippets = true,
      })

      ls.add_snippets("terraform", {
        s("tags", { t("tags = local.common_tags") }),
      })
      ls.add_snippets("terraform", {
        s("source", { t('source = "git::https://git.enova.com/tf-modules/"') }),
      })
      ls.add_snippets("gitcommit", {
        s("tfup", { t("update terraform and module versions") }),
      })
      -- Bring in some html snippets to markdown
      ls.add_snippets("markdown", {
        s("br", { t("<br/>") }),
      })

      require("luasnip.loaders.from_vscode").lazy_load()

      vim.api.nvim_create_user_command("LuaSnipEdit", function()
        require("luasnip.loaders").edit_snippet_files()
      end, { desc = "Edit Snippet files" })
    end,
  },
}
