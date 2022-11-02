local wk = require('which-key')
-- https://github.com/folke/which-key.nvim
wk.register({
    ['<Leader>f'] = { 
        name = '+find',
        b = { '<Cmd>Telescope buffers<CR>', 'Find Buffer' },
        f = { '<Cmd>Telescope find_files<CR>', 'Find File' },
        g = { '<Cmd>Telescope live_grep<CR>', 'Live Grep' },
        h = { '<Cmd>Telescope help_tags<CR>', 'Find Help' },
        d = { '<Cmd>Telescope lsp_document_symbols<CR>', 'Find Document Symbol' },
        s = { '<Cmd>Telescope lsp_workspace_symbols<CR>', 'Find Workspace Symbol' },
        r = { '<Cmd>Telescope lsp_references<CR>', 'Find References' },
        w = { '<Cmd>lua require("telescope.builtin").grep_string({word_match="-w"})<CR>', 'Find Word' },
    },
    ['<Leader>g'] = {
        name = '+goto',
        d = { '<Cmd>Telescope lsp_definitions<CR>', 'Goto Definition' },
    },
})

