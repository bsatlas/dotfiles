local lspconfig = require('lspconfig')
local cmp_nvim_lsp = require('cmp_nvim_lsp')

local on_attach = function(client, bufnr)
    -- Mappings for LSP actions
    local bufopts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
    vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format({ async = false }) end)

    -- enable auto-format on save
    if client.server_capabilities.documentFormattingProvider then
        local group = vim.api.nvim_create_augroup("LspFormatOnSave", { clear = true })
        vim.api.nvim_create_autocmd("BufWritePre", {
            group = group,
            buffer = bufnr,
            callback = function()
                vim.lsp.buf.format({ async = false })
            end,
        })
    end
end

local capabilities = cmp_nvim_lsp.default_capabilities()

-- Go Language Server
lspconfig.gopls.setup({
    cmd = { 'gopls' },
    filetypes = { 'go', 'gomod' },
    root_dir = lspconfig.util.root_pattern('go.mod', '.git'),
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        gopls = {
            analyses = {
                unusedparams = true,
                nilness = true,
                unusedwrite = true,
            },
            staticcheck = true,
        }
    },
})

-- Lua Language Server
lspconfig.lua_ls.setup {
    cmd = { 'lua-language-server' },
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        Lua = {
            runtime = {
                version = 'LuaJIT',
                path = vim.split(package.path, ';'),
            },
            diagnostics = {
                globals = { 'vim' },
            },
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
            },
            telemetry = {
                enable = false,
            },
            format = {
                enable = true,
            },
        },
    },
}

-- Python Language Server

local function get_python_path()
    local poetry_venv = vim.fn.trim(vim.fn.system('poetry env info --path'))
    if vim.fn.empty(poetry_venv) == 0 and vim.fn.isdirectory(poetry_venv) == 1 then
        return poetry_venv .. '/bin/python', poetry_venv
    else
        return vim.fn.exepath('python3'), nil
    end
end

local python_path, poetry_venv = get_python_path()

lspconfig.pylsp.setup {
    cmd = { 'pylsp' },
    on_attach = on_attach,
    capabilities = capabilities,
    settings = { pylsp = {
        configurationSources = { "flake8" }, -- Optional, for linting
        plugins = {
            black = { enabled = true, },
            pycodestyle = {
                enabled = false, -- Disable pycodestyle to avoid conflicts with black
            },
        },
    }, },
}

lspconfig.texlab.setup {
    cmd = { 'texlab' },
    on_attach = on_attach,
    capabilities = capabilities,
    settings = { texlab = {
        lint = { onChange = true, onSave = true },
        chktex = { onEdit = true, onOpenAndSave = true },
        latexFormatter = 'latexindent',
        latexindent = { modifyLineBreaks = false },
        formatterLineLength = 80,
    } },
}

--lspconfig.pyright.setup {
--    cmd = { 'pyright' },
--    on_attach = on_attach,
--    capabilities = capabilities,
--    settings = {
--        python = {
--            pythonPath = python_path,
--            venvPath = poetry_venv and vim.fn.fnamemodify(poetry_venv, ':h') or nil,
--            venv = poetry_venv and vim.fn.fnamemodify(poetry_venv, ':t') or nil,
--            analysis = {
--                autoSearchPaths = true,
--                useLibraryCodeForTypes = true,
--                diagnosticMode = 'workspace',
--            },
--        },
--    },
--}
