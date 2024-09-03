require('config.lazy')
require('config.lsp')
require('config.vim-go')
require('config.cmp')

-- set options
vim.opt.exrc = true
vim.opt.cursorline = true
vim.opt.path:append("**")
vim.opt.syntax = 'on'
vim.opt.errorbells = false
vim.opt.errorformat:append([[%*["]%f%*["]\,\ line\ %l:\ %m]])
vim.opt.number = true
vim.opt.backspace = { "indent", "eol", "start" }
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.encoding = 'utf-8'
vim.opt.autowrite = true
vim.opt.autoread = true
vim.opt.laststatus = 2
vim.opt.hidden = true
vim.opt.ruler = true
vim.opt.fileformats = { "unix" }
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.lazyredraw = true
vim.opt.wrap = false
vim.opt.formatoptions:append('qrn1')
vim.opt.autoindent = true
vim.opt.complete:remove('i')
vim.opt.showmatch = true
vim.opt.matchtime = 3
vim.opt.smarttab = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.nrformats:remove('octal')
vim.opt.shiftround = true
vim.opt.colorcolumn = '81'

vim.cmd('silent! helptags ALL')


-- save all open buffers when neovim loses focus.
vim.api.nvim_create_autocmd("FocusLost", {
    pattern = "*",
    command = "wa",
})

-- open help vertically
vim.api.nvim_create_user_command(
    'Help',
    function(args)
        vim.cmd('vertical belowright help ' .. args.args)
    end,
    { nargs = '*', complete = 'help' }
)

-- move help window to the far right of the screen, even if it was already on
-- the right side.
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'help',
    command = 'wincmd L',
})

-- set runtime paths
local runtime_paths = {}
for _, path in ipairs(runtime_paths) do
    vim.opt.runtimepath:prepend(path)
end

-- Better splitting
vim.keymap.set('n', '<A-v>', ':vsplit<CR>', { silent = true })
vim.keymap.set('n', '<A-s>', ':split<CR>', { silent = true })

-- Better split switching
vim.keymap.set('t', '<A-h>', [[<C-\><C-N><C-w>h]], { silent = true })
vim.keymap.set('t', '<A-j>', [[<C-\><C-N><C-w>j]], { silent = true })
vim.keymap.set('t', '<A-k>', [[<C-\><C-N><C-w>k]], { silent = true })
vim.keymap.set('t', '<A-l>', [[<C-\><C-N><C-w>l]], { silent = true })

vim.keymap.set('i', '<A-h>', [[<C-\><C-N><C-w>h]], { silent = true })
vim.keymap.set('i', '<A-j>', [[<C-\><C-N><C-w>j]], { silent = true })
vim.keymap.set('i', '<A-k>', [[<C-\><C-N><C-w>k]], { silent = true })
vim.keymap.set('i', '<A-l>', [[<C-\><C-N><C-w>l]], { silent = true })

vim.keymap.set('n', '<A-h>', '<C-w>h', { silent = true })
vim.keymap.set('n', '<A-j>', '<C-w>j', { silent = true })
vim.keymap.set('n', '<A-k>', '<C-w>k', { silent = true })
vim.keymap.set('n', '<A-l>', '<C-w>l', { silent = true })

-- Better window resizing
vim.keymap.set('n', '<A-H>', '10<C-W><', { silent = true })
vim.keymap.set('n', '<A-L>', '10<C-W>>', { silent = true })
vim.keymap.set('n', '<A-K>', '10<C-W>+', { silent = true })
vim.keymap.set('n', '<A-J>', '10<C-W>-', { silent = true })

-- Remap escape key to exit Terminal mode
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { silent = true })

-- Better buffer cycling
vim.keymap.set('n', '<A-n>', ':bnext<CR>', { silent = true })
vim.keymap.set('n', '<A-N>', ':bprev<CR>', { silent = true })

-- Map space key in Normal mode to center the current line to the middle of the
-- screen.
vim.keymap.set('n', '<space>', 'zz', { noremap = true, silent = true })

-- Move up and down on splitted lines.
vim.keymap.set('n', '<Up>', 'gk', { silent = true })
vim.keymap.set('n', '<Down>', 'gj', { silent = true })

-- Dont show that stupid q: window
vim.keymap.set('n', 'q:', ':q<CR>', { silent = true })

-- " Allow saving of files as sudo when I forgot to start vim using sudo.
vim.api.nvim_set_keymap('c', 'w!!', 'w !sudo tee > /dev/null %<CR>', {
    noremap = true, silent = true
})




-- python config
if vim.bo.filetype == 'python' then
    vim.opt_local.textwidth = 80
end

-- Helper function to set buffer-local options
local function set_options(opts)
    for k, v in pairs(opts) do
        vim.opt_local[k] = v
    end
end

-- Settings for .vim files
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    pattern = "*.vim",
    callback = function()
        set_options({
            expandtab = false, tabstop = 4, shiftwidth = 4, softtabstop = 4
        })
    end,
})

-- Go settings
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    pattern = "*.go",
    callback = function()
        set_options({ expandtab = false, tabstop = 4, shiftwidth = 4, softtabstop = 4 })
    end,
})

-- Systemd settings
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    pattern = { "*.network", "*.netdev", "*.mount", "*.automount", "*.service" },
    callback = function()
        vim.bo.filetype = 'systemd'
    end,
})

-- HCL (Terraform) settings
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    pattern = "*.hcl",
    callback = function()
        vim.bo.filetype = "terraform"
    end,
})

-- INI (NetworkManager connection) settings
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    pattern = "*.nmconnection",
    callback = function()
        vim.bo.filetype = "dosini"
    end,
})

-- Python indent settings
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    pattern = "*.py",
    callback = function()
        set_options({
            tabstop = 4,
            softtabstop = 4,
            shiftwidth = 4,
            textwidth = 80,
            smarttab = true,
            expandtab = true,
        })
    end,
})

-- TOML settings
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = "MAINTAINERS",
    callback = function()
        vim.bo.filetype = "toml"
    end,
})

-- Calcurse settings
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    pattern = { "/tmp/calcurse*", "~/.calcurse/notes/*" },
    callback = function()
        vim.bo.filetype = "markdown"
    end,
})



-- Settings for .txt files
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    pattern = "*.txt",
    callback = function()
        set_options({ expandtab = false, tabstop = 4, shiftwidth = 4 })
    end,
})

-- Settings for .md and .tex files
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    pattern = { "*.md", "*.tex" },
    callback = function()
        set_options({ spell = true, expandtab = false, tabstop = 4, shiftwidth = 4 })
    end,
})

-- Settings for email files
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    pattern = { "/tmp/mutt*", "/tmp/neomutt*", "*.email" },
    callback = function()
        set_options({
            spell = true,
            expandtab = false,
            textwidth = 60,
            tabstop = 4,
            shiftwidth = 4
        })
    end,
})

-- Settings for .json files
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    pattern = "*.json",
    callback = function()
        set_options({ expandtab = true, tabstop = 2, shiftwidth = 2 })
    end,
})

-- Define a table of wildignore patterns with comments for each category
local wildignore_patterns = {
    -- Version control
    '.hg', '.git', '.svn',

    -- LaTeX intermediate files
    '*.aux', '*.out', '*.toc',

    -- Binary images
    '*.jpg', '*.bmp', '*.gif', '*.png', '*.jpeg',

    -- Compiled object files
    '*.o', '*.obj', '*.exe', '*.dll', '*.manifest',

    -- Compiled spelling word lists
    '*.spl',

    -- Vim swap files
    '*.sw?',

    -- Go static files and binaries
    'go/pkg', 'go/bin',

    -- Python byte code
    '*.pyc',

    -- Terraform cache directory
    '.terraform'
}

-- Append all the patterns to the wildignore option
vim.opt.wildignore:append(wildignore_patterns)
