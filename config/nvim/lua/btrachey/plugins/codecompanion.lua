return {
  "olimorris/codecompanion.nvim",
  -- config = true,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  tag = "v17.33.0",
  -- opts = {
  --   opts = { log_level = "DEBUG" },
  -- },
  opts = {
    adapters = {
      http = {
        ["llama.cpp"] = function()
          return require("codecompanion.adapters").extend("openai_compatible", {
            env = {
              url = "http://127.0.0.1:1234", -- replace with your llama.cpp instance
              api_key = "TERM",
              chat_url = "/v1/chat/completions",
            },
            handlers = {
              parse_message_meta = function(self, data)
                local extra = data.extra
                if extra and extra.reasoning_content then
                  data.output.reasoning = { content = extra.reasoning_content }
                  if data.output.content == "" then
                    data.output.content = nil
                  end
                end
                return data
              end,
            },
          })
        end,
      },
    },
    -- display = {
    --   action_palette = {
    --     provider = "telescope",
    --   },
    -- },
    -- interactions = {
    strategies = {
      chat = {
        -- adapter = "gemini_cli",
        adapter = "llama.cpp",
      },
      inline = {
        -- adapter = "gemini_cli",
        adapter = "llama.cpp",
      },
      cmd = {
        -- adapter = "gemini_cli",
        adapter = "llama.cpp",
      },
      background = {
        -- adapter = "gemini_cli",
        adapter = "llama.cpp",
      },
    },
  },
  keys = {
    {
      "<leader>ll",
      "<cmd>CodeCompanionActions<cr>",
      desc = "CodeCompanion palette",
    },
  },
}
