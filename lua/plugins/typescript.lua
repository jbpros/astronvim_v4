return {
  "pmizio/typescript-tools.nvim",
  lazy = false,
  dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
  opts = {
    settings = {
      publish_diagnostic_on = "change"
    },
  },
}
