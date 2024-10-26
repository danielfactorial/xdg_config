local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out,                            "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = ","
vim.opt.whichwrap = 'b,s,<,>,[,],h,l,~'
vim.opt.encoding = 'utf-8'
vim.opt.clipboard = 'unnamedplus'
vim.opt.autoread = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.wrap = true
vim.opt.backspace = '2'
vim.opt.linebreak = true
vim.opt.textwidth = 0

vim.opt.hidden = true
vim.opt.pumheight = 10
vim.opt.ruler = true
vim.opt.showmode = true
vim.opt.showcmd = true
vim.opt.fileencoding = 'utf-8'
vim.opt.cmdheight = 1
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.termguicolors = true
vim.opt.conceallevel = 0
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.updatetime = 250
vim.opt.timeoutlen = 500
vim.opt.numberwidth = 1
vim.opt.scrolloff = 3
vim.opt.mouse = 'a'

vim.opt.number = true
vim.opt.cursorline = true
vim.opt.signcolumn = 'no'
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

vim.opt.cinkeys = ''
vim.opt.shiftround = true
vim.opt.expandtab = true
vim.opt.showmatch = true
vim.opt.history = 10000
vim.opt.undolevels = 10000
vim.opt.errorbells = false
vim.opt.hlsearch = true


vim.cmd [[
autocmd VimResized * wincmd =
]]

vim.cmd [[
set sessionoptions+=localoptions
set noswapfile
]]

require("lazy").setup({
    'nvim-lua/plenary.nvim',
    'Mofiqul/dracula.nvim',
    'nvim-tree/nvim-web-devicons',

    {
        'nvim-telescope/telescope-fzf-native.nvim',
        build =
        'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'
    },
    {
        'nvim-telescope/telescope.nvim',
        branch = '0.1.x',
        config = function()
            require('telescope').setup({
                defaults = {
                    vimgrep_arguments = {
                        "rg",
                        "-L",
                        "--color=never",
                        "--no-heading",
                        "--with-filename",
                        "--line-number",
                        "--column",
                        "--smart-case",
                    },
                    prompt_prefix = "   ",
                    selection_caret = "  ",
                    entry_prefix = "  ",
                    initial_mode = "insert",
                    selection_strategy = "reset",
                    sorting_strategy = "ascending",
                    layout_strategy = "horizontal",
                    layout_config = {
                        horizontal = {
                            prompt_position = "top",
                            preview_width = 0.55,
                            results_width = 0.8,
                        },
                        vertical = {
                            mirror = false,
                        },
                        width = 0.87,
                        height = 0.80,
                        preview_cutoff = 120,
                    },
                    file_sorter = require("telescope.sorters").get_fuzzy_file,
                    file_ignore_patterns = { "node_modules" },
                    generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
                    path_display = { "truncate" },
                    winblend = 0,
                    border = {},
                    borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
                    color_devicons = true,
                    set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
                    file_previewer = require("telescope.previewers").vim_buffer_cat.new,
                    grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
                    qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
                    -- Developer configurations: Not meant for general override
                    buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
                    mappings = {
                        n = { ["q"] = require("telescope.actions").close },
                    },
                },
                extensions = {
                    fzf = {
                        fuzzy = true,
                        override_generic_sorter = true,
                        override_file_sorter = true,
                        case_mode = "smart_case",
                    },
                },
            })
        end,
    },

    {
        "nvim-treesitter/nvim-treesitter",
        event = { "BufReadPost", "BufNewFile" },
        cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
        build = ":TSUpdate",
        config = function()
            require('nvim-treesitter.configs').setup({
                ensure_installed = {
                    "lua", "luadoc", "printf",
                    "vim", "vimdoc",
                    "vue",
                    "python",
                    "javascript", "css", "html", "htmldjango",
                },

                highlight = {
                    enable = true,
                    use_languagetree = true,
                },

                indent = { enable = false },
            })
        end,
    },

    {
        "nvim-tree/nvim-tree.lua",
        opts = {
            view = {
                width = 40,
            },
            on_attach = function(bufnr)
                local api = require('nvim-tree.api')

                local function opts(desc)
                    return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
                end

                -- Default mappings.
                --
                -- BEGIN_DEFAULT_ON_ATTACH
                vim.keymap.set('n', '<C-n>', api.tree.change_root_to_node, opts('CD'))
                vim.keymap.set('n', '<C-e>', api.node.open.replace_tree_buffer, opts('Open: In Place'))
                vim.keymap.set('n', '<C-k>', api.node.show_info_popup, opts('Info'))
                vim.keymap.set('n', '<C-r>', api.fs.rename_sub, opts('Rename: Omit Filename'))
                vim.keymap.set('n', '<C-t>', api.node.open.tab, opts('Open: New Tab'))
                vim.keymap.set('n', '<C-v>', api.node.open.vertical, opts('Open: Vertical Split'))
                vim.keymap.set('n', '<C-x>', api.node.open.horizontal, opts('Open: Horizontal Split'))
                vim.keymap.set('n', '<BS>', api.node.navigate.parent_close, opts('Close Directory'))
                vim.keymap.set('n', '<CR>', api.node.open.edit, opts('Open'))
                --vim.keymap.set('n', '<Tab>', api.node.open.preview,                 opts('Open Preview'))
                vim.keymap.set('n', '>', api.node.navigate.sibling.next, opts('Next Sibling'))
                vim.keymap.set('n', '<', api.node.navigate.sibling.prev, opts('Previous Sibling'))
                vim.keymap.set('n', '.', api.node.run.cmd, opts('Run Command'))
                vim.keymap.set('n', '-', api.tree.change_root_to_parent, opts('Up'))
                vim.keymap.set('n', 'a', api.fs.create, opts('Create'))
                vim.keymap.set('n', 'bmv', api.marks.bulk.move, opts('Move Bookmarked'))
                vim.keymap.set('n', 'B', api.tree.toggle_no_buffer_filter, opts('Toggle No Buffer'))
                vim.keymap.set('n', 'c', api.fs.copy.node, opts('Copy'))
                vim.keymap.set('n', 'C', api.tree.toggle_git_clean_filter, opts('Toggle Git Clean'))
                vim.keymap.set('n', '[c', api.node.navigate.git.prev, opts('Prev Git'))
                vim.keymap.set('n', ']c', api.node.navigate.git.next, opts('Next Git'))
                vim.keymap.set('n', 'd', api.fs.remove, opts('Delete'))
                vim.keymap.set('n', 'D', api.fs.trash, opts('Trash'))
                vim.keymap.set('n', 'E', api.tree.expand_all, opts('Expand All'))
                vim.keymap.set('n', 'e', api.fs.rename_basename, opts('Rename: Basename'))
                vim.keymap.set('n', ']e', api.node.navigate.diagnostics.next, opts('Next Diagnostic'))
                vim.keymap.set('n', '[e', api.node.navigate.diagnostics.prev, opts('Prev Diagnostic'))
                vim.keymap.set('n', 'F', api.live_filter.clear, opts('Clean Filter'))
                vim.keymap.set('n', 'f', api.live_filter.start, opts('Filter'))
                vim.keymap.set('n', 'g?', api.tree.toggle_help, opts('Help'))
                vim.keymap.set('n', 'gy', api.fs.copy.absolute_path, opts('Copy Absolute Path'))
                vim.keymap.set('n', 'H', api.tree.toggle_hidden_filter, opts('Toggle Dotfiles'))
                vim.keymap.set('n', 'I', api.tree.toggle_gitignore_filter, opts('Toggle Git Ignore'))
                vim.keymap.set('n', 'J', api.node.navigate.sibling.last, opts('Last Sibling'))
                vim.keymap.set('n', 'K', api.node.navigate.sibling.first, opts('First Sibling'))
                vim.keymap.set('n', 'm', api.marks.toggle, opts('Toggle Bookmark'))
                vim.keymap.set('n', 'o', api.node.open.edit, opts('Open'))
                vim.keymap.set('n', 'O', api.node.open.no_window_picker, opts('Open: No Window Picker'))
                vim.keymap.set('n', 'p', api.fs.paste, opts('Paste'))
                vim.keymap.set('n', 'P', api.node.navigate.parent, opts('Parent Directory'))
                vim.keymap.set('n', 'q', api.tree.close, opts('Close'))
                vim.keymap.set('n', 'r', api.fs.rename, opts('Rename'))
                vim.keymap.set('n', 'R', api.tree.reload, opts('Refresh'))
                vim.keymap.set('n', 's', api.node.run.system, opts('Run System'))
                vim.keymap.set('n', 'S', api.tree.search_node, opts('Search'))
                vim.keymap.set('n', 'U', api.tree.toggle_custom_filter, opts('Toggle Hidden'))
                vim.keymap.set('n', 'W', api.tree.collapse_all, opts('Collapse'))
                vim.keymap.set('n', 'x', api.fs.cut, opts('Cut'))
                vim.keymap.set('n', 'y', api.fs.copy.filename, opts('Copy Name'))
                vim.keymap.set('n', 'Y', api.fs.copy.relative_path, opts('Copy Relative Path'))
                vim.keymap.set('n', '<2-LeftMouse>', api.node.open.edit, opts('Open'))
                vim.keymap.set('n', '<2-RightMouse>', api.tree.change_root_to_node, opts('CD'))
                -- END_DEFAULT_ON_ATTACH


                -- Mappings removed via:
                --   remove_keymaps
                --   OR
                --   view.mappings.list..action = ""
                --
                -- The dummy set before del is done for safety, in case a default mapping does not exist.
                --
                -- You might tidy things by removing these along with their default mapping.
                vim.keymap.set('n', 's', '', { buffer = bufnr })
                vim.keymap.del('n', 's', { buffer = bufnr })
                vim.keymap.set('n', 'S', '', { buffer = bufnr })
                vim.keymap.del('n', 'S', { buffer = bufnr })
                vim.keymap.set('n', 'H', '', { buffer = bufnr })
                vim.keymap.del('n', 'H', { buffer = bufnr })
                vim.keymap.set('n', 'J', '', { buffer = bufnr })
                vim.keymap.del('n', 'J', { buffer = bufnr })
                vim.keymap.set('n', '<C-e>', '', { buffer = bufnr })
                vim.keymap.del('n', '<C-e>', { buffer = bufnr })


                -- Mappings migrated from view.mappings.list
                --
                -- You will need to insert "your code goes here" for any mappings with a custom action_cb
                vim.keymap.set('n', 'T', api.node.navigate.sibling.first, opts('First Sibling'))
                vim.keymap.set('n', 'N', api.node.navigate.sibling.last, opts('Last Sibling'))
                vim.keymap.set('n', 'dd', api.fs.cut, opts('Cut'))
                vim.keymap.set('n', 'D', api.fs.remove, opts('Delete'))
                vim.keymap.set('n', 'yy', api.fs.copy.node, opts('Copy'))
                vim.keymap.set('n', 'Y', api.fs.copy.filename, opts('Copy Name'))
                vim.keymap.set('n', 'gy', api.fs.copy.relative_path, opts('Copy Relative Path'))
                vim.keymap.set('n', 'gY', api.fs.copy.absolute_path, opts('Copy Absolute Path'))
                vim.keymap.set('n', 'm', api.fs.rename, opts('Rename'))
                vim.keymap.set('n', 'a', api.fs.create, opts('Create'))
                vim.keymap.set('n', '<C-p>', api.tree.change_root_to_parent, opts('Up'))
                vim.keymap.set('n', '<C-a>', api.tree.toggle_hidden_filter, opts('Toggle Dotfiles'))
            end
        }
    },
})


vim.keymap.set('n', '<space><space>', function()
    vim.cmd('wa')
end, { silent = true })


vim.keymap.set('i', '<c-c>', '<esc>')
vim.keymap.set('n', 'Y', 'y$')
vim.keymap.set('n', 't', 'gj')
vim.keymap.set('n', 'n', 'gk')
vim.keymap.set('n', 's', 'l')
-- keep search matches in the middle of the window
vim.keymap.set('n', 'l', 'nzzzv')
vim.keymap.set('n', 'j', 't')
vim.keymap.set('n', 'k', 's')

vim.keymap.set('n', 'T', '}')
vim.keymap.set('n', 'N', '{')
vim.keymap.set('n', 'L', 'Nzzzv')
vim.keymap.set('n', 'J', 'T')
--map('n', 'K', 'S')
vim.keymap.set('n', 'S', '$')
vim.keymap.set('n', 'H', '^')

vim.keymap.set('n', '<leader>h', '<cmd>nohl<cr><cmd>mode<cr>')
vim.keymap.set('n', '<leader><space>', '<cmd>wa<cr><cmd>w<cr>')
vim.keymap.set('n', '<C-s>', '<cmd>wa<cr><cmd>w<cr>')

vim.keymap.set('n', '-', 'J')

-- Make space the wincmd

vim.keymap.set('n', '<C-e>', '3<C-e>')
vim.keymap.set('n', '<C-y>', '3<C-y>')

-- Allow undoing more precisely when writing large amounts of text in insert mode by secretly leaving and reentering insert mode on all punctuation.
vim.keymap.set('i', ',', ',<c-g>u')
vim.keymap.set('i', '.', '.<c-g>u')
vim.keymap.set('i', '!', '!<c-g>u')
vim.keymap.set('i', '?', '?<c-g>u')

vim.keymap.set('v', 't', 'gj')
vim.keymap.set('v', 'n', 'gk')
vim.keymap.set('v', 's', 'l')
vim.keymap.set('v', 'l', 'n')
vim.keymap.set('v', 'j', 't')
vim.keymap.set('v', 'k', 's')

vim.keymap.set('v', 'T', '}')
vim.keymap.set('v', 'N', '{')
vim.keymap.set('v', 'L', 'N')
vim.keymap.set('v', 'J', 'T')
vim.keymap.set('v', 'K', 'S')
vim.keymap.set('v', 'S', '$')
vim.keymap.set('v', 'H', '^')
vim.keymap.set('v', '-', 'J')


vim.keymap.set('i', '<c-bs>', '<c-w>')
vim.keymap.set('n', '<tab>', '<cmd>tabnext<cr>')
vim.keymap.set('n', '<s-tab>', '<cmd>tabprevious<cr>')

vim.keymap.set('n', '<leader>gs', '<cmd>Telescope git_status<cr>')
vim.keymap.set('n', '<C-S-p>', '<cmd>Telescope git_status<cr>')

vim.keymap.set('n', '<leader>tn', '<cmd>TestNearest<cr>')
vim.keymap.set('n', '<leader>tf', '<cmd>TestFile<cr>')
vim.keymap.set('n', '<leader>tl', '<cmd>TestLast<cr>')
vim.keymap.set('n', '<leader>tg', '<cmd>TestVisit<cr>')

vim.keymap.set('n', '<leader>nf', '<cmd>NvimTreeFindFile<cr>')


vim.keymap.set('n', '<C-l>', '<C-l>zz:syntax sync fromstart<cr>')

vim.cmd [[
iabbrev pdb import ipdb; ipdb.set_trace()
]]


vim.keymap.set('n', '<leader>cl', ':set bg=light<cr>')
vim.keymap.set('n', '<leader>cd', ':set bg=dark<cr>')


vim.keymap.set('n', '<leader>cn', '<cmd>cnext<cr>')
vim.keymap.set('n', '<leader>cp', '<cmd>cprevious<cr>')

vim.keymap.set('n', '<C-p>', '<cmd>Telescope find_files<cr>')
vim.keymap.set('n', '<C-g>', '<cmd>Telescope live_grep<cr>')
vim.keymap.set('n', '<leader>nn', '<cmd>NvimTreeToggle<cr>')
vim.keymap.set('n', '<space>', '<c-w>')

vim.keymap.set('n', '<space>t', '<C-w>j')
vim.keymap.set('n', '<space>T', '<C-w>J')
vim.keymap.set('n', '<space>n', '<C-w>k')
vim.keymap.set('n', '<space>N', '<C-w>K')
vim.keymap.set('n', '<space>s', '<C-w>l')
vim.keymap.set('n', '<space>S', '<C-w>L')

vim.keymap.set('n', '<space>j', '<C-w>t')
vim.keymap.set('n', '<space>J', '<C-w>T')
vim.keymap.set('n', '<space>k', '<C-w>n')
vim.keymap.set('n', '<space>K', '<C-w>N')
vim.keymap.set('n', '<space>l', '<C-w>s')
vim.keymap.set('n', '<space>L', '<C-w>S')
vim.keymap.set('n', '<space>f', '<C-w>F')
vim.keymap.set('n', '<space>q', '<C-w>q')
vim.keymap.set('n', 'gf', 'gF')


vim.cmd('colorscheme dracula')
