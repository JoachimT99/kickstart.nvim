return {
  {
    'olimorris/codecompanion.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
      'ravitemer/codecompanion-history.nvim',
      {
        'Davidyz/VectorCode',
        version = '*', -- optional, depending on whether you're on nightly or release
        build = 'pipx upgrade vectorcode', -- optional but recommended. This keeps your CLI up-to-date.
      },
      {
        'ravitemer/mcphub.nvim',
        build = 'npm install -g mcp-hub@latest',
        config = function()
          require('mcphub').setup {
            extensions = {
              mcphub = {
                callback = 'mcphub.extensions.codecompanion',
                opts = {
                  show_result_in_chat = true, -- Show mcp tool results in chat
                  make_vars = true, -- Convert resources to #variables
                  make_slash_commands = true, -- Add prompts as /slash commands
                },
              },
            },
          }
        end,
      },
    },
    config = function()
      require('codecompanion').setup {
        extensions = {
          history = {
            enabled = true,
            opts = {
              -- Keymap to open history from chat buffer (default: gh)
              keymap = 'gh',
              -- Keymap to save the current chat manually (when auto_save is disabled)
              save_chat_keymap = 'sc',
              -- Save all chats by default (disable to save only manually using 'sc')
              auto_save = true,
              -- Number of days after which chats are automatically deleted (0 to disable)
              expiration_days = 0,
              -- Picker interface ("telescope" or "snacks" or "fzf-lua" or "default")
              picker = 'telescope',
              -- Customize picker keymaps (optional)
              picker_keymaps = {
                rename = { n = 'r', i = '<M-r>' },
                delete = { n = 'd', i = '<M-d>' },
                duplicate = { n = '<C-y>', i = '<C-y>' },
              },
              ---Automatically generate titles for new chats
              auto_generate_title = true,
              title_generation_opts = {
                ---Adapter for generating titles (defaults to active chat's adapter)
                adapter = nil, -- e.g "copilot"
                ---Model for generating titles (defaults to active chat's model)
                model = nil, -- e.g "gpt-4o"
                ---Number of user prompts after which to refresh the title (0 to disable)
                refresh_every_n_prompts = 0, -- e.g., 3 to refresh after every 3rd user prompt
                ---Maximum number of times to refresh the title (default: 3)
                max_refreshes = 3,
              },
              ---On exiting and entering neovim, loads the last chat on opening chat
              continue_last_chat = false,
              ---When chat is cleared with `gx` delete the chat from history
              delete_on_clearing_chat = false,
              ---Directory path to save the chats
              dir_to_save = vim.fn.stdpath 'data' .. '/codecompanion-history',
              ---Enable detailed logging for history extension
              enable_logging = false,
              ---Optional filter function to control which chats are shown when browsing
              chat_filter = nil, -- function(chat_data) return boolean end
            },
          },
          vectorcode = {
            opts = {
              add_tool = true,
            },
          },
        },
      }
      vim.keymap.set({ 'n', 'v' }, '<C-a>', '<cmd>CodeCompanionActions<cr>', { noremap = true, silent = true })
      vim.keymap.set({ 'n', 'v' }, '<LocalLeader>a', '<cmd>CodeCompanionChat Toggle<cr>', { noremap = true, silent = true })
      vim.keymap.set('v', 'ga', '<cmd>CodeCompanionChat Add<cr>', { noremap = true, silent = true })

      -- Expand 'cc' into 'CodeCompanion' in the command line
      vim.cmd [[cab cc CodeCompanion]]
    end,
  },
}
