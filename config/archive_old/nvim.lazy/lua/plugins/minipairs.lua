return {
  -- 1. Désactiver mini.pairs de LazyVim
  {
    "nvim-mini/mini.pairs",
    enabled = false,
  },

  -- 2. Utiliser nvim-autopairs qui respecte les dead keys (accents)
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      -- Exclure explicitement le backtick des paires automatiques
      ignored_next_char = [=[[%w%%%'%[%"%.%`%$]]=],
    },
    config = function(_, opts)
      local npairs = require("nvim-autopairs")
      npairs.setup(opts)

      -- Retirer la paire du backtick ` pour libérer la touche morte
      npairs.remove_rule("`")
    end,
  },
}
