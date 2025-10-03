local builtin = require('telescope.builtin')
    vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
    vim.keymap.set('n', '<leader>pg', builtin.git_files, {})
    vim.keymap.set('n', '<leader>pb', builtin.buffers, {})
    
    vim.keymap.set('n', '<leader>ph', function()
        builtin.find_files({ cwd = vim.fn.expand("~") })
    end, {})
