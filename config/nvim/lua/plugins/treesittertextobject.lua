vim.pack.add({
  {
    src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
    version = "main",
  },
})

local textobjects = require("nvim-treesitter-textobjects")
local move = require("nvim-treesitter-textobjects.move")

textobjects.setup({
  move = {
    set_jumps = true,
  },
})

local moves = {
  goto_next_start = {
    ["]f"] = "@function.outer",
    ["]c"] = "@class.outer",
    ["]a"] = "@parameter.inner",
  },

  goto_next_end = {
    ["]F"] = "@function.outer",
    ["]C"] = "@class.outer",
    ["]A"] = "@parameter.inner",
  },

  goto_previous_start = {
    ["[f"] = "@function.outer",
    ["[c"] = "@class.outer",
    ["[a"] = "@parameter.inner",
  },

  goto_previous_end = {
    ["[F"] = "@function.outer",
    ["[C"] = "@class.outer",
    ["[A"] = "@parameter.inner",
  },
}

local function has_textobjects_query(buf)
  local ft = vim.bo[buf].filetype

  if ft == "" then
    return false
  end

  local lang = vim.treesitter.language.get_lang(ft) or ft

  local parser_ok = pcall(vim.treesitter.get_parser, buf, lang)
  if not parser_ok then
    return false
  end

  local query_ok, query = pcall(vim.treesitter.query.get, lang, "textobjects")

  return query_ok and query ~= nil
end

local function attach(buf)
  if not vim.api.nvim_buf_is_valid(buf) then
    return
  end

  if not has_textobjects_query(buf) then
    return
  end

  for method, keymaps in pairs(moves) do
    for key, query in pairs(keymaps) do
      local parts = {}

      local queries = type(query) == "table" and query or { query }

      for _, q in ipairs(queries) do
        local part = q:gsub("@", ""):gsub("%..*", "")

        part = part:sub(1, 1):upper() .. part:sub(2)

        table.insert(parts, part)
      end

      local desc = (key:sub(1, 1) == "[" and "Prev " or "Next ") .. table.concat(parts, " or ")

      local second = key:sub(2, 2)

      if second ~= "" and second == second:upper() then
        desc = desc .. " End"
      else
        desc = desc .. " Start"
      end

      vim.keymap.set({ "n", "x", "o" }, key, function()
        -- Preserve native diff-mode ]c / [c behavior.
        if vim.wo.diff and key:find("[cC]") then
          return vim.cmd("normal! " .. key)
        end

        move[method](query, "textobjects")
      end, {
        buffer = buf,
        desc = desc,
        silent = true,
      })
    end
  end
end

local group = vim.api.nvim_create_augroup("treesitter_textobjects_custom", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  group = group,
  callback = function(ev)
    attach(ev.buf)
  end,
})

for _, buf in ipairs(vim.api.nvim_list_bufs()) do
  attach(buf)
end
