local progress = require("fidget.progress")

local Spinner = {}

function Spinner:init()
  local group = vim.api.nvim_create_augroup("CodeCompanionFidgetHooks", {})

  vim.api.nvim_create_autocmd({ "User" }, {
    pattern = "CodeCompanionRequestStarted",
    group = group,
    callback = function(request)
      local handle = Spinner:create_progress_handle(request)
      Spinner:store_progress_handle(request.data.id, handle)
    end,
  })

  vim.api.nvim_create_autocmd({ "User" }, {
    pattern = "CodeCompanionRequestFinished",
    group = group,
    callback = function(request)
      local handle = Spinner:pop_progress_handle(request.data.id)
      if handle then
        Spinner:report_exit_status(handle, request)
        handle:finish()
      end
    end,
  })
end

Spinner.handles = {}

function Spinner:store_progress_handle(id, handle)
  Spinner.handles[id] = handle
end

function Spinner:pop_progress_handle(id)
  local handle = Spinner.handles[id]
  Spinner.handles[id] = nil
  return handle
end

function Spinner:create_progress_handle(request)
  return progress.handle.create({
    title = " Requesting assistance (" .. request.data.strategy .. ")",
    message = "In progress...",
    lsp_client = {
      name = Spinner:llm_role_title(request.data.adapter),
    },
  })
end

function Spinner:llm_role_title(adapter)
  local parts = {}
  table.insert(parts, adapter.formatted_name)
  if adapter.model and adapter.model ~= "" then
    table.insert(parts, "(" .. adapter.model .. ")")
  end
  return table.concat(parts, " ")
end

function Spinner:report_exit_status(handle, request)
  if request.data.status == "success" then
    handle.message = "Completed"
  elseif request.data.status == "error" then
    handle.message = " Error"
  else
    handle.message = "󰜺 Cancelled"
  end
end

return {
  "olimorris/codecompanion.nvim",
  config = true,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "j-hui/fidget.nvim",
  },
  opts = {
    display = {
      action_palette = {
        provider = "telescope",
      },
    },
    strategies = {
      chat = {
        adapter = "machine",
      },
      inline = {
        adapter = "machine",
      },
    },
    adapters = {
      machine = function()
        return require("codecompanion.adapters").extend("openai_compatible", {
          name = "machine",
          env = {
            url = "http://127.0.0.1:1234",
          },
          schema = {
            model = {
              default = "qwen2.5-coder-1.5b-instruct",
            },
          },
        })
      end,
    },
  },
  init = function()
    Spinner:init()
  end,
  keys = {
    {
      "<leader>ll",
      "<cmd>CodeCompanionActions<cr>",
      desc = "CodeCompanion palette",
      -- mode = { "n" },
    },
  },
}
