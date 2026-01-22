return {
    {
        'benlubas/molten-nvim',
        version = '^1.0.0', -- use version <2.0.0 to avoid breaking changes
        dependencies = { '3rd/image.nvim' },
        build = ':UpdateRemotePlugins',
        init = function()
            -- these are examples, not defaults. Please see the readme
            vim.g.molten_image_provider = 'image.nvim'
            vim.g.molten_output_win_max_height = 20
            -- I find auto open annoying, keep in mind setting this option will require setting
            -- a keybind for `:noautocmd MoltenEnterOutput` to open the output again
            vim.g.molten_auto_open_output = false

            -- this guide will be using image.nvim
            -- Don't forget to setup and install the plugin if you want to view image outputs
            vim.g.molten_image_provider = 'image.nvim'

            -- optional, I like wrapping. works for virt text and the output window
            vim.g.molten_wrap_output = true

            -- Output as virtual text. Allows outputs to always be shown, works with images, but can
            -- be buggy with longer images
            vim.g.molten_virt_text_output = true

            -- this will make it so the output shows up below the \`\`\` cell delimiter
            vim.g.molten_virt_lines_off_by_1 = true

            vim.keymap.set('n', '<localleader>mi', ':MoltenInit<CR>', { silent = true, desc = 'Initialize the plugin' })
            vim.keymap.set('n', '<localleader>me', ':MoltenEvaluateOperator<CR>', { silent = true, desc = 'run operator selection' })
            vim.keymap.set('n', '<localleader>rl', ':MoltenEvaluateLine<CR>', { silent = true, desc = 'evaluate line' })
            vim.keymap.set('n', '<localleader>rr', ':MoltenReevaluateCell<CR>', { silent = true, desc = 're-evaluate cell' })
            vim.keymap.set('v', '<localleader>r', ':<C-u>MoltenEvaluateVisual<CR>gv', { silent = true, desc = 'evaluate visual selection' })
            vim.keymap.set('n', '<localleader>rd', ':MoltenDelete<CR>', { silent = true, desc = 'molten delete cell' })
            vim.keymap.set('n', '<localleader>oh', ':MoltenHideOutput<CR>', { silent = true, desc = 'hide output' })
            vim.keymap.set('n', '<localleader>os', ':noautocmd MoltenEnterOutput<CR>', { silent = true, desc = 'show/enter output' })

            local imb = function(e) -- init molten buffer
                vim.schedule(function()
                    local kernels = vim.fn.MoltenAvailableKernels()
                    local try_kernel_name = function()
                        local metadata = vim.json.decode(io.open(e.file, 'r'):read 'a')['metadata']
                        return metadata.kernelspec.name
                    end
                    local ok, kernel_name = pcall(try_kernel_name)
                    if not ok or not vim.tbl_contains(kernels, kernel_name) then
                        kernel_name = nil
                        local venv = os.getenv 'VIRTUAL_ENV' or os.getenv 'CONDA_PREFIX'
                        if venv ~= nil then
                            kernel_name = string.match(venv, '/.+/(.+)')
                        end
                    end
                    if kernel_name ~= nil and vim.tbl_contains(kernels, kernel_name) then
                        vim.cmd(('MoltenInit %s'):format(kernel_name))
                    end
                    vim.cmd 'MoltenImportOutput'
                end)
            end

            -- Autocomando para importar al abrir
            vim.api.nvim_create_autocmd('BufAdd', {
                pattern = { '*.ipynb' },
                callback = imb,
            })
            vim.api.nvim_create_autocmd('BufEnter', {
                pattern = { '*.ipynb' },
                callback = function(e)
                    if vim.api.nvim_get_vvar 'vim_did_enter' ~= 1 then
                        imb(e)
                    end
                end,
            })

            -- Autocomando para exportar al guardar
            vim.api.nvim_create_autocmd('BufWritePost', {
                pattern = { '*.ipynb' },
                callback = function()
                    if require('molten.status').initialized() == 'Molten' then
                        vim.cmd 'MoltenExportOutput!'
                    end
                end,
            })
        end,
    },
}
