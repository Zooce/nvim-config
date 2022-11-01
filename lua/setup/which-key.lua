local wk = require('which-key')
-- https://github.com/folke/which-key.nvim
wk.register({
    ['<Leader>f'] = { 
        name = '+find',
        f = { '<Cmd>Telescope find_files<CR>', 'Find File' },
        g = { '<Cmd>Telescope live_grep<CR>', 'Live Grep' },
        s = { '<Cmd>Telescope grep_string<CR>', 'Find String' },
        w = { '<Cmd>lua require("telescope.builtin").grep_string({word_match="-w"})<CR>', 'Find Word' },
        b = { '<Cmd>Telescope buffers<CR>', 'Find Buffer' },
        h = { '<Cmd>Telescope help_tags<CR>', 'Find Help' },
    }
})

