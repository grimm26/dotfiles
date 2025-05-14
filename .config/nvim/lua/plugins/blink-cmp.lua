return {
  {
    "saghen/blink.cmp",
    dependencies = {
      "rafamadriz/friendly-snippets",
      "Kaiser-Yang/blink-cmp-dictionary",
      "fang2hou/blink-copilot",
      "L3MON4D3/LuaSnip",
    },
    version = "1.*",
    opts = {
      keymap = { preset = "super-tab" },
      completion = {
        ghost_text = {
          enabled = true,
          show_with_menu = false,
        },
        list = { selection = { auto_insert = false } },
        documentation = { auto_show = true, window = { border = "rounded" } },
        menu = {
          auto_show = true,
          draw = {
            padding = 0,
            columns = { { "kind_icon", gap = 1 }, { gap = 1, "label" }, { "kind", gap = 2 } },
            components = {
              kind_icon = {
                ellipsis = false,
                text = function(ctx)
                  local lspkind = require("lspkind")
                  local icon = ctx.kind_icon
                  if vim.tbl_contains({ "Path" }, ctx.source_name) then
                    local dev_icon, _ = require("nvim-web-devicons").get_icon(ctx.label)
                    if dev_icon then
                      icon = dev_icon
                    end
                  else
                    icon = require("lspkind").symbolic(ctx.kind, {
                      mode = "symbol",
                    })
                  end

                  return icon .. ctx.icon_gap
                end,

                -- Optionally, use the highlight groups from nvim-web-devicons
                -- You can also add the same function for `kind.highlight` if you want to
                -- keep the highlight groups in sync with the icons.
                highlight = function(ctx)
                  local hl = ctx.kind_hl
                  if vim.tbl_contains({ "Path" }, ctx.source_name) then
                    local dev_icon, dev_hl = require("nvim-web-devicons").get_icon(ctx.label)
                    if dev_icon then
                      hl = dev_hl
                    end
                  end
                  return hl
                end,
              },
              kind = {
                text = function(ctx)
                  return " " .. ctx.kind .. " "
                end,
              },
            },
          },
        },
      },
      snippets = { preset = "luasnip" },
      sources = {
        default = { "snippets", "copilot", "lsp", "path", "buffer", "dictionary" },
        providers = {
          copilot = {
            name = "copilot",
            module = "blink-copilot",
            score_offset = 100,
            async = true,
          },
          dictionary = {
            module = "blink-cmp-dictionary",
            min_keyword_length = 3,
            name = "dict",
            opts = {
              dictionary_files = { vim.fn.expand("~/.config/nvim/spell/en.utf-8.add") },
            },
          },
        },
      },
      fuzzy = { implementation = "prefer_rust_with_warning" },
    },
    opts_extend = { "sources.default" },
  },
}
