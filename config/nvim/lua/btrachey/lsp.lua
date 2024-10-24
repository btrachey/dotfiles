local F = require("btrachey.functions")
local map = F.map
-- local shiftk = F.shiftk
local api = vim.api

-- add border to floating windows
local float_config = {
  border = 'rounded',
  -- border = 'double',
}

local setup = function()
  -- LSP logging to debug
  -- vim.lsp.set_log_level("debug")
  -- vim.lsp.set_log_level("trace")

  -- some diagnostic settings
  vim.diagnostic.config({
    severity_sort = true,
    update_in_insert = true,
    virtual_text = false,
    -- virtual_text = {
    --   virt_text_pos = "right_align"
    -- },
    float = float_config
  })

  local lsp_config = require("lspconfig")
  local telescope_builtin = require("telescope.builtin")
  local lsp_group = api.nvim_create_augroup("lsp", { clear = true })
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true
  }

  lsp_config.util.default_config = vim.tbl_extend("force", lsp_config.util.default_config, {
    capabilities = require("cmp_nvim_lsp").default_capabilities()
  }, capabilities)

  local attach_func = function(client, bufnr)
    -- LSP mappings
    map("n", "gd", telescope_builtin.lsp_definitions, { desc = "LSP go to definition of the symbol under the cursor." })
    -- map("n", "K", shiftk,
    --   {
    --     desc =
    --     "First press, perform lsp hover action if avaialble; second press enter the hover window; third press exit the hover window."
    --   })
    map("n", "gi", telescope_builtin.lsp_implementations,
      { desc = "LSP go to implementation of the symbol under the cursor." })
    map("n", "gr", telescope_builtin.lsp_references, { desc = "LSP go to references of the sumbol under the cursor." })
    map("n", "gds", telescope_builtin.lsp_document_symbols, { desc = "LSP list symbols in the current document." })
    map("n", "gws", telescope_builtin.lsp_dynamic_workspace_symbols,
      { desc = "LSP search for symbol in workspace by name." })
    map("n", "<leader>cl", vim.lsp.codelens.run, { desc = "LSP code lens." })
    map({ "n", "v" }, "<leader>ca", require("actions-preview").code_actions, { desc = "LSP code action." })
    -- map({ "n", "v" }, "<leader>ca", function() vim.lsp.buf.code_action() end, { desc = "LSP code action." })
    map("n", "<leader>sh", vim.lsp.buf.signature_help, { desc = "LSP function signature help." })
    map("i", "<C-h>", vim.lsp.buf.signature_help, { desc = "LSP function signature help." })
    map("n", "<leader>rn", vim.lsp.buf.rename, { desc = "LSP rename the symbol under the cursor." })
    map("n", "<leader>aa", telescope_builtin.diagnostics, { desc = "LSP all workspace diagnostics." })
    map("n", "<leader>ae", function() telescope_builtin.diagnostics({ severity = "Error" }) end,
      { desc = "LSP 'Error' diagnostics." })
    map("n", "<leader>aw", function() telescope_builtin.diagnostics({ severity = "Warning" }) end,
      { desc = "LSP 'Warning' diagnostics." })
    -- map("n", "<leader>d", vim.diagnostic.setloclist,
    --   { desc = "Open all LSP diagnostics for current buffer only in local list." }) -- buffer diagnostics only
    -- map("n", "<leader>ab", function() telescope_builtin.diagnostics({ bufnr = 0 }) end,
    --   { desc = "LSP diagnostics for current buffer." })
    map("n", "[d", function() vim.diagnostic.goto_prev({ float = float_config }) end,
      { desc = "Previous diagnostic" })
    map("n", "]d", function() vim.diagnostic.goto_next({ float = float_config }) end,
      { desc = "Next diagnostic" })

    -- Example mappings for usage with nvim-dap. If you don't use that, you can skip these
    map("n", "<leader>dc", require("dap").continue, { desc = "DAP continue execution." })
    map("n", "<leader>dr", require("dap").repl.toggle, { desc = "DAP toggle the repl." })
    -- map("n", "<leader>dr", require("dapui").toggle, { desc = "DAP toggle the repl." })
    map("n", "<leader>dK", require("dap.ui.widgets").hover, { desc = "DAP-specific hover function." })
    map("n", "<leader>dt", require("dap").toggle_breakpoint, { desc = "DAP toggle breakpoint." })
    map("n", "<leader>dso", require("dap").step_over, { desc = "DAP step over." })
    map("n", "<leader>dsi", require("dap").step_into, { desc = "DAP step into." })
    map("n", "<leader>dl", require("dap").run_last, { desc = "DAP re-run the previously executed command." })

    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, float_config)
    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, float_config)

    if client.server_capabilities.documentHighlightProvider then
      api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        buffer = bufnr,
        callback = vim.lsp.buf.document_highlight,
        group = lsp_group,
      })

      api.nvim_create_autocmd("CursorMoved", {
        buffer = bufnr,
        callback = vim.lsp.buf.clear_references,
        group = lsp_group,
      })
    end

    if client.server_capabilities.codeLensProvider then
      api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
        buffer = bufnr,
        callback = vim.lsp.codelens.refresh,
        group = lsp_group
      })
    end

    api.nvim_create_autocmd("FileType", {
      pattern = { "dap-repl" },
      callback = function()
        require("dap.ext.autocompl").attach()
      end,
      group = lsp_group,
    })

    if client.supports_method("textDocument/formatting") then
      api.nvim_create_autocmd("BufWritePre", {
        group = lsp_group,
        buffer = bufnr,
        callback = function()
          if vim.fn.exists(":MetalsOrganizeImports") > 0 then vim.cmd("MetalsOrganizeImports") end
          vim.lsp.buf.format()
        end,
      })
    end

    -- turn off semantic highlighting from lsp
    client.server_capabilities.semanticTokensProvider = nil
  end

  local metals_config = require("metals").bare_config()
  metals_config.init_options.statusBarProvider = "off"
  metals_config.settings = {
    showImplicitArguments = true,
    showImplicitConversionsAndClasses = true,
    showInferredType = true,
    defaultBspToBuildTool = true,
    autoImportBuild = "all",
  }
  metals_config.tvp["icons"] = { enabled = true }

  -- Debug settings if you're using nvim-dap
  local dap = require("dap")
  -- local dapui = require("dapui")

  dap.configurations.scala = {
    {
      type = "scala",
      request = "launch",
      name = "Run Or Test Current File",
      metals = {
        runType = "runOrTestFile",
      },
    },
    -- https://www.chris-kipp.io/blog/the-debug-adapter-protocol-and-scala
    {
      type = "scala",
      request = "launch",
      name = "Run Or Test Current File With Args",
      metals = {
        runType = "runOrTestFile",
        args = function()
          local args = {}
          local input = vim.fn.input("Arguments: ")
          for w in input:gmatch("%S+") do table.insert(args, w) end
          return args
        end
      },
    },
    {
      type = "scala",
      request = "launch",
      name = "Test Entire Build Target",
      metals = {
        runType = "testTarget",
      },
    },
  }
  -- DAP UI setup
  -- dapui.setup({
  --   layouts = {
  --     {
  --       elements = {
  --         "repl",
  --         -- "breakpoints",
  --       },
  --       size = 0.25,
  --       -- position = "bottom",
  --       position = "right",
  --     }
  --   },
  --   controls = { enabled = false },
  -- })

  -- auto open/close dapui with dap
  dap.listeners.after.event_initialized["nvim-metals"] = function() dap.repl.open() end
  -- dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
  -- dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
  -- dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end

  metals_config.on_attach = function(client, bufnr)
    attach_func(client, bufnr)

    -- mappings specific to Metals
    map("n", "<leader>t", require("metals.tvp").toggle_tree_view, { desc = "Open Metals tree view." })
    map("n", "<leader>tr", require("metals.tvp").reveal_in_tree,
      { desc = "Open Metals tree view at currently highlighted symbol." })
    map("n", "<leader>ws", require "metals".hover_worksheet, { desc = "Metals hover worksheet." })
    map("n", "<leader>mm", require("telescope").extensions.metals.commands,
      { desc = "Metals commands Telescope picker." })
    map("n", "<leader>mc", require("metals").compile_cascade, { desc = "Metals compile cascade" })
    map("n", "gt", function()
      local current_filepath = api.nvim_buf_get_name(0)
      local spec_filename = string.format("%sSpec%s", string.match(current_filepath, ".*/(.*)(.scala)$"))
      --[[ assume the workspace only has one folder and it's the one we want; a little naieve, but
      effective for now ]]
      local base_dir = vim.lsp.buf.list_workspace_folders()[1]
      local resolved_spec_file = vim.fs.find(spec_filename, { path = base_dir })
      if resolved_spec_file then
        vim.cmd('e ' .. resolved_spec_file[1])
      else
        require("telescope.builtin").find_files({
          default_text = spec_filename,
          on_complete = {
            function(picker)
              -- remove this on-complete callback
              picker:clear_completion_callbacks()
              -- if there is exactly one match, select it
              if picker.manager.linked_states.size == 1 then
                require("telescope.actions").select_default(picker.prompt_bufnr)
              end
            end
          }
        })
      end
    end, { desc = "Go to Scala test file." }
    )

    require("metals").setup_dap()
  end

  -- Autocmd that starts up Metals
  local nvim_metals_group = api.nvim_create_augroup("nvim-metals", { clear = true })
  api.nvim_create_autocmd("FileType", {
    pattern = { "scala", "sbt", "java" },
    callback = function()
      require("metals").initialize_or_attach(metals_config)
    end,
    group = nvim_metals_group,
  })

  -- LSP for Madlib
  local madlib_lsp_group = api.nvim_create_augroup("lsp-madlib", { clear = true })
  api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
    pattern = { "*.mad" },
    callback = function()
      vim.lsp.start({
        name = "madlib",
        cmd = { "madlib", "lsp" },
        root_dir = vim.fs.dirname(vim.fs.find({ "madlib.json" }, { upward = true })[1]),
        on_attach = attach_func
      })
    end,
    group = madlib_lsp_group
  })
  api.nvim_create_autocmd({ "BufWritePost" }, {
    pattern = { "*.mad" },
    callback = function()
      local view = vim.fn.winsaveview()
      vim.cmd([[silent %! madlib format -i %]])
      if vim.v.shell_error ~= 0 then
        vim.cmd.u()
      else
        vim.cmd.w()
      end
      vim.fn.winrestview(view)
    end,
    group = madlib_lsp_group
  })

  -- lua lsp runtime path adjustments
  local runtime_path = vim.split(package.path, ";")
  table.insert(runtime_path, "lua/?.lua")
  table.insert(runtime_path, "lua/?/init.lua")

  -- lua lsp
  lsp_config.lua_ls.setup({
    on_attach = attach_func,
    settings = {
      Lua = {
        format = {
          enable = true,
          -- https://github.com/CppCXY/EmmyLuaCodeStyle/blob/master/lua.template.editorconfig
          defaultConfig = {
            max_line_length = 120,
            table_separator_style = "comma",
            trailing_table_separator = "always"
          }
        },
        runtime = {
          version = "LuaJIT",
          path = runtime_path,
        },
        diagnostics = {
          globals = { "vim", "require" }
        },
        workspace = {
          library = api.nvim_get_runtime_file("", true),
          checkThirdParty = false,
        },
        completion = {
          callSnippet = "Replace"
        },
        telemetry = { enable = false },
      },
    },
  })

  -- python lsp
  lsp_config.ruff.setup({
    on_attach = attach_func
  })
  lsp_config.pyright.setup({
    on_attach = attach_func
  })

  -- typescript lsp
  lsp_config.ts_ls.setup({
    on_attach = attach_func
  })

  -- bash lsp
  lsp_config.bashls.setup({
    on_attach = attach_func,
    filetypes = { "bash", "sh", "zsh" }
  })

  -- html lsp
  lsp_config.superhtml.setup({
    on_attach = attach_func
  })
  -- lsp_config.html.setup({
  --   on_attach = attach_func,
  -- })

  -- css lsp
  lsp_config.cssls.setup({
    on_attach = attach_func,
  })

  -- rust-analyzer with rust-tools
  -- lsp_config.rust_analyzer.setup({
  --   on_attach = attach_func,
  -- })
  require("rust-tools").setup({
    server = {
      on_attach = attach_func,
    },
  })

  -- yaml lsp
  lsp_config.yamlls.setup({
    on_attach = attach_func,
    filetypes = { "yaml", "yaml.docker-compose", "yml" }
  })

  -- sql lsp
  lsp_config.sqlls.setup({
    on_attach = attach_func,
  })

  -- dockerfile lsp
  lsp_config.dockerls.setup({
    on_attach = attach_func,
  })

  -- toml lsp
  lsp_config.taplo.setup({
    on_attach = attach_func,
  })

  -- markdown lsp
  lsp_config.marksman.setup({
    on_attach = attach_func,
  })
end

return {
  setup = setup
}
