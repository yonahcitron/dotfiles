return {
  -- Configure mini.ai
  "echasnovski/mini.ai",
  -- `opts` can be a function to lazy-load the plugin
  opts = function()
    local ai = require("mini.ai")
    return {
      -- Here we define our custom text objects
      custom_textobjects = {
        -- Use 'r' for the right-hand side of an assignment
        r = ai.gen_spec.treesitter({ a = "@assignment.rhs", i = "@assignment.rhs" }),

        -- Use '=' for the whole assignment with 'a', and the lhs with 'i'
        ["="] = ai.gen_spec.treesitter({ a = "@assignment.outer", i = "@assignment.inner" }),
      },
    }
  end,
}
