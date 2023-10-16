local telescope = require("telescope")
local finders = require("telescope.finders")
local pickers = require("telescope.pickers")
local make_entry = require("telescope.make_entry")
local conf = require("telescope.config").values

local yadmfiles_list = function()
  local list = {}
  local p = io.popen("yadm list")
  for file in p:lines() do
    table.insert(list, file)
  end
  return list
end

local yadmfiles = function(opts)
  opts = opts or {}
  local results = yadmfiles_list()

  pickers
    .new(opts, {
      prompt_title = "find in yadm files",
      results_title = "YADM",
      finder = finders.new_table({
        results = results,
        entry_maker = make_entry.gen_from_file(opts),
      }),
      previewer = conf.file_previewer(opts),
      sorter = conf.file_sorter(opts),
    })
    :find()
end

return telescope.register_extension({ exports = { yadm = yadm } })
