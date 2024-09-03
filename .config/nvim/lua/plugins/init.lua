return {
    {
        'dracula/vim',
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd([[colorscheme dracula]])
        end,
    },

    -- NERDTree
    {
        'preservim/nerdtree',
        lazy = false,
        config = function()
        -- Key mappings
        vim.api.nvim_set_keymap("n", "<C-n>", ":NERDTreeToggle<CR>", { noremap = true, silent = true })
        --vim.api.nvim_set_keymap("n", "<Leader>n", ":NERDTreeToggle<CR>", { noremap = true, silent = true })
        --vim.api.nvim_set_keymap("n", "<Leader>f", ":NERDTreeFind<CR>", { noremap = true, silent = true })

        -- NERDTree settings
        vim.g.NERDTreeShowHidden = 1
        vim.g.NERDTreeIgnore = { '\\.vim$', '\\~$', '\\.git$', '.DS_Store' }
        -- vim.g.NERDTreeDirArrowExpandable = ''
        -- vim.g.NERDTreeDirArrowCollapsible = ''

        -- Autocommands
        vim.api.nvim_create_autocmd("StdinReadPre", {
            pattern = "*",
            callback = function()
            vim.g.std_in = 1
            end,
        })

        vim.api.nvim_create_autocmd("VimEnter", {
            pattern = "*",
            callback = function()
            if vim.fn.argc() == 0 and not vim.g.std_in then
                vim.cmd("NERDTree")
            end
            end,
        })

        vim.api.nvim_create_autocmd("BufEnter", {
            pattern = "*",
            callback = function()
            if vim.fn.winnr("$") == 1 and vim.b.NERDTreeType == "primary" then
                vim.cmd("q")
            end
            end,
        })
        end,
    },

    {
        'neovim/nvim-lspconfig',
        lazy = false,
    },

    { 'hrsh7th/cmp-nvim-lsp' },
    { 'hrsh7th/cmp-buffer' },
    { 'hrsh7th/cmp-path' },
    { 'hrsh7th/cmp-cmdline' },
    { 'hrsh7th/nvim-cmp' },

    { 
        'L3MON4D3/LuaSnip',
        tag = 'v2.3.0',
        run = 'make install_jsregexp'
    },

    {'saadparwaiz1/cmp_luasnip'},

    -- vim-go
    {
        "fatih/vim-go",
        lazy = true,
        ft = {'go'},
    },

}
