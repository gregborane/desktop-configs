-- 1. Load the plugin
vim.pack.add({
  "nvim-treesitter/nvim-treesitter-textobjects",
})

-- 2. Define options
local opts = {
  move = {
    enable = true,
    set_jumps = true, -- whether to set jumps in the jumplist
    -- Custom extension to create buffer-local keymaps
    keys = {
      goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer", ["]a"] = "@parameter.inner" },
      goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer", ["]A"] = "@parameter.inner" },
      goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer", ["[a"] = "@parameter.inner" },
      goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer", ["[A"] = "@parameter.inner" },
    },
  },
}

-- 3. Execute setup
-- Using a VimEnter autocommand with vim.schedule precisely mimics lazy.nvim's `event = "VeryLazy"`
vim.api.nvim_create_autocmd("VimEnter", {
  once = true,
  callback = function()
    vim.schedule(function()
      local TS = require("nvim-treesitter-textobjects")
      if not TS.setup then
        vim.notify("Please update `nvim-treesitter-textobjects` to the main branch.", vim.log.levels.ERROR)
        return
      end

      TS.setup(opts)

      local function attach(buf)
        local ft = vim.bo[buf].filetype
        if not vim.tbl_get(opts, "move", "enable") then
          return
        end

        -- Native replacement for LazyVim.treesitter.have(ft, "textobjects")
        local lang = vim.treesitter.language.get_lang(ft) or ft
        local has_parser = pcall(vim.treesitter.get_parser, buf, lang)

        -- Check if the textobjects query actually exists for this language
        local has_query = has_parser and pcall(vim.treesitter.query.get, lang, "textobjects")
        if not has_query then
          return
        end

        ---@type table<string, table<string, string>>
        local moves = vim.tbl_get(opts, "move", "keys") or {}

        for method, keymaps in pairs(moves) do
          for key, query in pairs(keymaps) do
            local queries = type(query) == "table" and query or { query }
            local parts = {}
            for _, q in ipairs(queries) do
              local part = q:gsub("@", ""):gsub("%..*", "")
              part = part:sub(1, 1):upper() .. part:sub(2)
              table.insert(parts, part)
            end
            local desc = table.concat(parts, " or ")
            desc = (key:sub(1, 1) == "[" and "Prev " or "Next ") .. desc
            desc = desc .. (key:sub(2, 2) == key:sub(2, 2):upper() and " End" or " Start")

            vim.keymap.set({ "n", "x", "o" }, key, function()
              -- Fallback for diff mode
              if vim.wo.diff and key:find("[cC]") then
                return vim.cmd("normal! " .. key)
              end
              require("nvim-treesitter-textobjects.move")[method](query, "textobjects")
            end, {
              buffer = buf,
              desc = desc,
              silent = true,
            })
          end
        end
      end

      -- Attach to new buffers via FileType event
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("treesitter_textobjects_custom", { clear = true }),
        callback = function(ev)
          attach(ev.buf)
        end,
      })

      -- Attach to already opened buffers
      vim.tbl_map(attach, vim.api.nvim_list_bufs())
    end)
  end,
})
