return {
    'quarto-dev/quarto-nvim',
    dependencies = {
        'jmbuhr/otter.nvim', -- Vital para que funcione el LSP
        'nvim-treesitter/nvim-treesitter',
    },
    -- 1. IMPORTANTE: Decirle a Lazy que cargue este plugin en archivos markdown también
    ft = { 'quarto', 'markdown' },

    config = function()
        local quarto = require 'quarto'

        quarto.setup {
            lspFeatures = {
                languages = { 'python', 'rust', 'lua' },
                chunks = 'all', -- Detecta bloques de código en todo el archivo
                diagnostics = {
                    enabled = true,
                    triggers = { 'BufWritePost' },
                },
                completion = {
                    enabled = true,
                },
            },
            keymap = {
                hover = 'H',
                definition = 'gd',
                rename = '<leader>rn',
                references = 'gr',
                format = '<leader>gf',
            },
            codeRunner = {
                enabled = true,
                default_method = 'molten', -- Conectamos con Molten
            },
        }

        -- 2. LA CLAVE DE TU PROBLEMA: Activar Quarto en archivos Markdown
        -- Esto hace que tus .ipynb (vistos como markdown) tengan superpoderes
        -- Creamos un autocomando para que se active solo al abrir markdown
        vim.api.nvim_create_autocmd('FileType', {
            pattern = 'markdown',
            callback = function()
                quarto.activate()
            end,
        })

        -- 3. Mapeos para ejecutar celdas (usando el runner de Quarto)
        local runner = require 'quarto.runner'
        vim.keymap.set('n', '<localleader>rc', runner.run_cell, { desc = 'Run cell', silent = true })
        vim.keymap.set('n', '<localleader>ra', runner.run_above, { desc = 'Run cell and above', silent = true })
        vim.keymap.set('n', '<localleader>rA', runner.run_all, { desc = 'Run all cells', silent = true })
        vim.keymap.set('n', '<localleader>rl', runner.run_line, { desc = 'Run line', silent = true })
        vim.keymap.set('v', '<localleader>r', runner.run_range, { desc = 'Run visual range', silent = true })
    end,
}
