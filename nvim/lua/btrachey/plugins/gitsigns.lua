local F = require("btrachey.functions")

local setup = function()
  require('gitsigns').setup {
    current_line_blame_opts = {
      virt_text_pos = 'right_align',
    },
    on_attach = function(_, bufnr)
      local gs = package.loaded.gitsigns

      -- Navigation
      F.map('n', ']g', function()
        if vim.wo.diff then return ']g' end
        vim.schedule(function() gs.next_hunk() end)
        return '<Ignore>'
      end, { expr = true, buffer = bufnr, desc = "Next git hunk" })

      F.map('n', '[g', function()
        if vim.wo.diff then return '[g' end
        vim.schedule(function() gs.prev_hunk() end)
        return '<Ignore>'
      end, { expr = true, buffer = bufnr, desc = "Previous git hunk" })

      -- Actions
      F.map({ 'n', 'v' }, '<leader>hs', ':Gitsigns stage_hunk<CR>', { buffer = bufnr, desc = "Git stage hunk" })
      F.map({ 'n', 'v' }, '<leader>hr', ':Gitsigns reset_hunk<CR>', { buffer = bufnr, desc = "Git reset hunk" })
      F.map('n', '<leader>hS', gs.stage_buffer, { buffer = bufnr, desc = "Git stage buffer" })
      F.map('n', '<leader>hu', gs.undo_stage_hunk, { buffer = bufnr, desc = "Git undo stage hunk" })
      F.map('n', '<leader>hR', gs.reset_buffer, { buffer = bufnr, desc = "Git reset buffer" })
      F.map('n', '<leader>hp', gs.preview_hunk, { buffer = bufnr, desc = "Git preview hunk" })
      F.map('n', '<leader>hb', function() gs.blame_line({ full = true }) end, { buffer = bufnr, desc = "Git blame line" })
      F.map('n', '<leader>tb', gs.toggle_current_line_blame, { buffer = bufnr, desc = "Git toggle line blame" })
      F.map('n', '<leader>hd', gs.diffthis, { buffer = bufnr, desc = "Git open diff view" })
      F.map('n', '<leader>hD', function() gs.diffthis('~') end, { buffer = bufnr })
      F.map('n', '<leader>td', gs.toggle_deleted, { buffer = bufnr, desc = "Git toggle deleted" })

      -- Text object
      F.map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { buffer = bufnr, desc = "inside git hunk" })
    end
  }
end

return {
  setup = setup,
}
