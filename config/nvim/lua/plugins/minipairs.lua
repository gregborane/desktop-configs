-- 1. Charger le plugin (Utiliser nvim-autopairs au lieu de mini.pairs)
vim.pack.add({
  "https://github.com/windwp/nvim-autopairs",
})

-- 2. Définir les options
local opts = {
  -- Exclure explicitement le backtick des paires automatiques
  ignored_next_char = [=[[%w%%%'%[%"%.%`%$]]=],
}

-- 3. Initialiser le plugin au passage en mode Insertion (InsertEnter)
vim.api.nvim_create_autocmd("InsertEnter", {
  once = true, -- Ne s'exécute qu'une seule fois
  callback = function()
    local npairs = require("nvim-autopairs")

    npairs.setup(opts)

    -- Retirer la paire du backtick ` pour libérer la touche morte (accents)
    npairs.remove_rule("`")
  end,
})
