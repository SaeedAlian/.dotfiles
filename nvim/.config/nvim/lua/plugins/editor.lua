vim.opt.runtimepath:append("$HOME/.local/share/treesitter")

local map = require("util.keymapper").map
local file_browser_icons = require("util.icons").file_browser_icons

local comment_config = function()
  require("Comment").setup({
    toggler = {
      line = "\\",
      block = "<leader>\\",
    },
    opleader = {
      line = "\\",
      block = "<leader>\\",
    },
  })
end

local treesitter_config = function()
  require("nvim-treesitter.configs").setup({
    -- build = ":TSUpdate",
    indent = {
      enable = true,
    },
    autotag = {
      enable = true,
    },
    event = {
      "BufReadPre",
      "BufNewFile",
    },
    ensure_installed = {
      "c",
      "cpp",
      "rust",
      "json",
      "javascript",
      "typescript",
      "html",
      "tsx",
      "css",
      "bash",
      "lua",
      "dockerfile",
      "gitignore",
      "sql",
    },
    auto_install = true,
    parser_install_dir = "$HOME/.local/share/treesitter",
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },
    textobjects = {
      move = {
        enable = true,
        set_jumps = true,
        goto_previous_start = {
          ["[f"] = { query = "@function.outer", desc = "Previous function" },
          ["[c"] = { query = "@class.outer", desc = "Previous class" },
        },
        goto_next_start = {
          ["]f"] = { query = "@function.outer", desc = "Next function" },
          ["]c"] = { query = "@class.outer", desc = "Next class" },
        },
      },
    },
  })
end

local telescope_config = function()
  local telescope = require("telescope")
  local actions = require("telescope.actions")
  local fb_actions = require("telescope").extensions.file_browser.actions

  telescope.setup({
    defaults = {
      file_ignore_patterns = {
        ".git/",
        "target/",
        ".cache/",
        -- "build/",
        "node_modules/",
        "__pycache__/",
      },
      wrap_results = true,
      prompt_prefix = " > ",
      color_devicons = true,
      layout_strategy = "vertical",
      layout_config = { prompt_position = "top" },
      sorting_strategy = "ascending",
      winblend = 0,
      mappings = {
        n = {
          ["q"] = actions.close,
          ["/"] = function()
            vim.cmd("startinsert")
          end,
        },
        i = {
          ["<C-j>"] = "move_selection_next",
          ["<C-k>"] = "move_selection_previous",
          ["<C-w>"] = function()
            vim.cmd("normal vbd")
          end,
          ["<C-i>"] = function()
            vim.cmd("stopinsert")
          end,
        },
      },
    },
    pickers = {
      find_files = {
        theme = "dropdown",
        previewer = true,
        hidden = true,
      },
      live_grep = {
        theme = "dropdown",
        previewer = true,
        hidden = true,
      },
      buffers = {
        theme = "dropdown",
        previewer = true,
        hidden = true,
      },
    },
    extensions = {
      file_browser = {
        theme = "dropdown",
        hijack_netrw = true,
        grouped = true,
        initial_mode = "normal",
        hide_parent_dir = true,
        dir_icon = file_browser_icons.Directory,
        hidden = true,
        file_ignore_patterns = {
          "__pycache__/",
        },
        mappings = {
          ["n"] = {
            ["n"] = fb_actions.create,
            ["h"] = fb_actions.goto_parent_dir,
            ["wd"] = fb_actions.goto_cwd,
            ["r"] = fb_actions.rename,
            ["y"] = fb_actions.copy,
            ["x"] = fb_actions.move,
            ["d"] = fb_actions.remove,
            ["<leader>."] = fb_actions.toggle_hidden,
            ["<leader>g."] = fb_actions.toggle_respect_gitignore,
            ["A"] = fb_actions.toggle_all,
          },
        },
      },
    },
  })

  telescope.load_extension("file_browser")
end

return {
  {
    "numToStr/Comment.nvim",
    lazy = false,
    config = comment_config,
  },
  {
    "tpope/vim-fugitive",
    lazy = false,
  },
  {
    "szw/vim-maximizer",
    lazy = false,
    keys = {
      { "sm", "<cmd>MaximizerToggle<CR>", desc = "Maximize/minimize a split" },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    config = treesitter_config,
    lazy = false,
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      "windwp/nvim-ts-autotag",
    },
  },
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.5",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-file-browser.nvim",
    },
    config = telescope_config,
    keys = {
      map("n", "<leader>pd", ":Telescope file_browser path=%:p:h select_buffer=true<CR>", { noremap = true }),
      map("n", "<leader>vh", ":Telescope help_tags<CR>"),
      map("n", "<leader>pf", ":Telescope find_files<CR>"),
      map("n", "<leader>pg", ":Telescope git_files<CR>"),
      map("n", "<leader>lg", ":Telescope live_grep<CR>"),
      map("n", "<leader>pb", ":Telescope buffers<CR>"),
      map("n", "<leader>pt", function()
        local builtin = require("telescope.builtin")
        builtin.treesitter()
      end),
    },
  },
  {
    "windwp/nvim-ts-autotag",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
  },
  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
    },
    keys = {
      { "<c-h>",  "<cmd><C-U>TmuxNavigateLeft<cr>" },
      { "<c-j>",  "<cmd><C-U>TmuxNavigateDown<cr>" },
      { "<c-k>",  "<cmd><C-U>TmuxNavigateUp<cr>" },
      { "<c-l>",  "<cmd><C-U>TmuxNavigateRight<cr>" },
      { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
    },
  },
  {
    "mbbill/undotree",
    lazy = false,
  },
}
