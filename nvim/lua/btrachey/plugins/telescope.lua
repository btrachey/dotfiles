local F = require("btrachey.functions")
local telescope_actions = require("telescope.actions")
local telescope_builtin = require("telescope.builtin")
local setup = function()
  require("telescope").setup({
    defaults = {
      mappings = {
        i = {
          ["<esc>"] = telescope_actions.close,
        }
      }
    }
  })
  F.map("n", "<leader>f", telescope_builtin.find_files, { desc = "Telescope find files" })
  F.map("n", "<leader>g", telescope_builtin.live_grep, {desc = "Telescope live grep"})
  F.map("n", "<leader>b", telescope_builtin.buffers, { desc = "Telescope list buffers" })
  F.map("n", "<leader>h", telescope_builtin.help_tags, { desc = "Telescope list help tags" })
end

return {
  setup = setup,
}
