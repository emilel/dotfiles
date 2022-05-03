return require('packer').startup(function()
    use 'wbthomason/packer.nvim'

    -- requirement for telescope
    use 'nvim-lua/plenary.nvim'

    -- aww yiss
    use 'nvim-telescope/telescope.nvim'

    -- find files
    use 'sharkdp/fd'

    -- syntax highlight and stuff
    use 'nvim-treesitter/nvim-treesitter'

    -- text objects
    use 'nvim-treesitter/nvim-treesitter-textobjects'

    -- gruvbox of course
    use 'ellisonleao/gruvbox.nvim'

    -- lualine
    use 'nvim-lualine/lualine.nvim'

    -- format julia
    use 'kdheepak/JuliaFormatter.vim'

    -- lsp
    use 'neovim/nvim-lspconfig'

    -- comments
    use 'tpope/vim-commentary'

    -- fuzzy find
    use 'junegunn/fzf.vim'

    -- undo tree
    use 'mbbill/undotree'

    -- file explorer
    use 'mcchrish/nnn.vim'

    -- auto completion
    use 'hrsh7th/nvim-cmp'

    -- autocomplete from lsp
    use 'hrsh7th/cmp-nvim-lsp'

    -- surroundings
    use 'tpope/vim-surround'

    -- nice unix tools
    use 'tpope/vim-eunuch'

    -- f across lines
    -- use 'dahu/vim-fanfingtastic'

    -- repeat the above
    use 'tpope/vim-repeat'

    -- peekabo
    use 'junegunn/vim-peekaboo'

    -- text objects
    use 'wellle/targets.vim'

    -- indentation text objects
    use 'michaeljsmith/vim-indent-object'

    -- show indentation level
    use 'Yggdroot/indentLine'

    -- lightspeed
    use 'ggandor/lightspeed.nvim'
end)
