return {
  "scalameta/nvim-metals",
  -- dir = "/Users/brian.tracey/Repos/nvim-metals/",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "mfussenegger/nvim-dap",
    "nvim-tree/nvim-web-devicons",
  },
  init = function()
    local map = require("btrachey.functions").map
    local metals_attach_func = function(client, bufnr)
      require("btrachey.lsp").attach_func(client, bufnr)

      -- mappings specific to Metals
      map(
        "n",
        "<leader>t",
        require("metals.tvp").toggle_tree_view,
        { desc = "Open Metals tree view." }
      )
      map(
        "n",
        "<leader>tr",
        require("metals.tvp").reveal_in_tree,
        { desc = "Open Metals tree view at currently highlighted symbol." }
      )
      map(
        "n",
        "<leader>ws",
        require("metals").hover_worksheet,
        { desc = "Metals hover worksheet." }
      )
      map(
        "n",
        "<leader>mm",
        require("telescope").extensions.metals.commands,
        { desc = "Metals commands Telescope picker." }
      )
      map(
        "n",
        "<leader>mc",
        require("metals").compile_cascade,
        { desc = "Metals compile cascade" }
      )
      map("n", "gt", function()
        local current_filepath = vim.api.nvim_buf_get_name(0)
        local spec_filename = string.format(
          "%sSpec%s",
          string.match(current_filepath, ".*/(.*)(.scala)$")
        )
        --[[ assume the workspace only has one folder and it's the one we want; a little naieve, but
      effective for now ]]
        local base_dir = vim.lsp.buf.list_workspace_folders()[1]
        local resolved_spec_file =
          vim.fs.find(spec_filename, { path = base_dir })
        if resolved_spec_file then
          vim.cmd("e " .. resolved_spec_file[1])
        else
          require("telescope.builtin").find_files({
            default_text = spec_filename,
            on_complete = {
              function(picker)
                -- remove this on-complete callback
                picker:clear_completion_callbacks()
                -- if there is exactly one match, select it
                if picker.manager.linked_states.size == 1 then
                  require("telescope.actions").select_default(
                    picker.prompt_bufnr
                  )
                end
              end,
            },
          })
        end
      end, { desc = "Go to Scala test file." })

      require("metals").setup_dap()
    end
    local default_metals_config = require("metals").bare_config()
    local config_table = {
      init_options = {
        statusBarProvider = "off",
      },
      settings = {
        -- serverVersion = "1.5.1",
        -- serverVersion = "1.5.2-SNAPSHOT",
        showImplicitArguments = true,
        showImplicitConversionsAndClasses = true,
        showInferredType = true,
        defaultBspToBuildTool = true,
        autoImportBuild = "all",
      },
      tvp = {
        collapsed_sign = "",
        expanded_sign = "",
        icons = { enabled = true },
      },
      capabilities = require("blink.cmp").get_lsp_capabilities(),
      on_attach = metals_attach_func,
    }
    local metals_config =
      vim.tbl_deep_extend("error", default_metals_config, config_table)

    local nvim_metals_group =
      vim.api.nvim_create_augroup("nvim-metals", { clear = true })
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "scala", "sbt", "java" },
      callback = function()
        require("metals").initialize_or_attach(metals_config)
      end,
      group = nvim_metals_group,
    })
    vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead", "BufEnter" }, {
      pattern = { "*.worksheet.sc" },
      callback = function()
        vim.lsp.inlay_hint.enable(true)
      end,
      group = nvim_metals_group,
    })
  end,
}
