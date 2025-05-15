-- Customize None-ls sources

---@type LazySpec
return {
  "nvimtools/none-ls.nvim",
  dependencies = {
    "nvimtools/none-ls-extras.nvim",
  },
  opts = function(_, config)
    -- config variable is the default configuration table for the setup function call
    local null_ls = require "null-ls"
    local u = require "null-ls.utils"

    -- Function to check for ESLint config files
    local function has_eslint_config(utils)
      -- Check for ESLint flat config files (new ESLint 9+ format)
      if utils.root_has_file({
        'eslint.config.js',
        'eslint.config.mjs',
        'eslint.config.cjs',
      }) then
        return true
      end

      -- Check for traditional ESLint config files
      if utils.root_has_file({
        '.eslintrc',
        '.eslintrc.js',
        '.eslintrc.cjs',
        '.eslintrc.yaml',
        '.eslintrc.yml',
        '.eslintrc.json',
      }) then
        return true
      end

      -- Check package.json for eslint config
      local package_json = utils.root_has_file("package.json")
      if package_json then
        local ok, package_content = pcall(vim.fn.json_decode, vim.fn.readfile(package_json))
        if ok then
          -- Only check for the eslintConfig field
          return package_content.eslintConfig ~= nil
        end
      end

      return false
    end

    -- Check supported formatters and linters
    -- https://github.com/nvimtools/none-ls.nvim/tree/main/lua/null-ls/builtins/formatting
    -- https://github.com/nvimtools/none-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
    config.sources = {
      -- Set a formatter
      -- null_ls.builtins.formatting.stylua,
      -- null_ls.builtins.formatting.prettier,
      require("none-ls.code_actions.eslint_d").with({
        condition = has_eslint_config,
      }),
      require("none-ls.diagnostics.eslint_d").with({
        condition = has_eslint_config,
      }),
      require("none-ls.formatting.eslint_d").with({
        condition = has_eslint_config,
      }),
    }
    return config -- return final config table
  end,
}
