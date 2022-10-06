----------------------------------------------------
-- Packages
----------------------------------------------------
require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'
    use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate',
        config = function()
            require('nvim-treesitter').setup() {
                auto_install = true,
            }
        end
    }
    use {
        'glepnir/galaxyline.nvim', -- Modeline plugin
        branch = 'main',
        config = function()
            require('eviline')
        end,
        requires = { 'kyazdani42/nvim-web-devicons' }
    }
    use { 'neovim/nvim-lspconfig', config = function()
        require('lsp_config')
    end }
    use { 'hrsh7th/nvim-cmp', -- Autocompletion plugin
        config = function()
            -- Add additional capabilities supported by nvim-cmp
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

            local lspconfig = require('lspconfig')

            -- Enable some language servers with the additional completion capabilities offered by nvim-cmp
            local servers = { 'clangd', 'rust_analyzer', 'pyright', 'tsserver' }
            for _, lsp in ipairs(servers) do
                lspconfig[lsp].setup {
                    -- on_attach = my_custom_on_attach,
                    capabilities = capabilities,
                }
            end

            -- luasnip setup
            local luasnip = require 'luasnip'

            -- nvim-cmp setup
            local cmp = require 'cmp'
            cmp.setup {
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-f>'] = cmp.mapping.scroll_docs(4),
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<CR>'] = cmp.mapping.confirm {
                        behavior = cmp.ConfirmBehavior.Replace,
                        select = true,
                    },
                    ['<Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                    ['<S-Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                }),
                sources = {
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' },
                },
            }
        end
    }
    use 'hrsh7th/cmp-nvim-lsp' -- LSP source for nvim-cmp
    use 'saadparwaiz1/cmp_luasnip' -- Snippets source for nvim-cmp
    use 'L3MON4D3/LuaSnip' -- Snippets plugin
    use 'lukas-reineke/lsp-format.nvim' -- Formatter
    use({
        'projekt0n/github-nvim-theme',
        config = function()
            require('github-theme').setup({
                theme_style = 'dark'
            })
        end
    })
end)

----------------------------------------------------
-- Misc. Configuration
----------------------------------------------------
vim.cmd('set termguicolors')
vim.cmd('set expandtab')
vim.cmd('set hls ic')
vim.cmd('set relativenumber')
vim.cmd('packadd packer.nvim')
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.cmd('autocmd BufReadPost,FileReadPost * normal zR')
vim.cmd([[
    set expandtab 
    set tabstop=4
    set shiftwidth=4
]])
