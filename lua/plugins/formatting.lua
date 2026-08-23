return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters = {
        pint = {
          command = "vendor/bin/pint",
          args = { "$FILENAME" },
          stdin = false,
          cwd = require("conform.util").root_file({ "artisan", "composer.json" }),
          require_cwd = true, -- no Laravel/composer root found => skip formatting
        },
      },
      formatters_by_ft = {
        php = { "pint" },
      },
    },
  },
}
