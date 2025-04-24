return {
  {
    "quarto-dev/quarto-nvim",
    lazy = true,
    ft = { "quarto" },
    dev = false,
    opts = {},
    dependencies = {
      "nvimtools/none-ls.nvim",
      "hrsh7th/nvim-cmp",
      "jalvesaq/Nvim-R",
    },
    config = function(_, opts)
      require("quarto").setup(opts)
    end,
  },
  {
    "jmbuhr/otter.nvim",
    lazy = false,
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    opts = function()
      return {
        keymap = {
          toggle_output_panel = "<leader>top",
        },
      }
    end,
    config = function(_, opts)
      require("otter").setup(opts)
    end,
  },
  {
    "dccsillag/magma-nvim",
    lazy = true,
    build = ":UpdateRemotePlugins",
    keys = {
      { "<leader>ms", ":MagmaEvaluateOperator<CR>", desc = "[m]agma [s]end" },
      { "<leader>ml", ":MagmaEvaluateLine<CR>", desc = "[m]agma evaluate [l]ine" },
      {
        "<leader>mv",
        ":MagmaEvaluateVisual<CR>",
        mode = "v",
        desc = "[m]agma evaluate [v]isual",
      },
    },
    config = function()
      vim.g.magma_automatically_open_output = false
    end,
  },
  {
    "GCBallesteros/jupytext.nvim",
    lazy = false,
    opts = {
      custom_language_formatting = {
        python = {
          extension = "qmd",
          style = "quarto",
          force_ft = "quarto",
        },
        r = {
          extension = "qmd",
          style = "quarto",
          force_ft = "quarto",
        },
      },
    },
  },
  {
    "jpalardy/vim-slime",
    lazy = false,
    dev = false,
    init = function()
      vim.b["quarto_is_python_chunk"] = false
      Quarto_is_in_python_chunk = function()
        require("otter.tools.functions").is_otter_language_context "python"
      end

      vim.cmd [[
        let g:slime_dispatch_ipython_pause = 100
        function SlimeOverride_EscapeText_quarto(text)
          call v:lua.Quarto_is_in_python_chunk()
          if exists('g:slime_python_ipython') && len(split(a:text,"\n")) > 1 && b:quarto_is_python_chunk && !(exists('b:quarto_is_r_mode') && b:quarto_is_r_mode)
            return ["%cpaste -q\n", g:slime_dispatch_ipython_pause, a:text, "--", "\n"]
          else
            if exists('b:quarto_is_r_mode') && b:quarto_is_r_mode && b:quarto_is_python_chunk
              return [a:text, "\n"]
            else
              return [a:text]
            end
          end
        endfunction
      ]]
      vim.g.slime_target = "neovim"
      vim.g.slime_no_mappings = true
      vim.g.slime_python_ipython = 1
    end,
    config = function()
      vim.g.slime_input_pid = false
      vim.g.slime_suggest_default = true
      vim.g.slime_menu_config = false
      vim.g.slime_neovim_ignore_unlisted = true
      local function mark_terminal()
        local job_id = vim.b.terminal_job_id
        vim.print("job_id: " .. job_id)
      end

      local function set_terminal()
        vim.fn.call("slime#config", {})
      end
      vim.keymap.set("n", "<leader>cm", mark_terminal, { desc = "[m]ark terminal" })
      vim.keymap.set("n", "<leader>cs", set_terminal, { desc = "[s]et terminal" })
    end,
  },
  {
    "HakonHarnes/img-clip.nvim",
    lazy = true,
    event = "BufEnter",
    ft = { "markdown", "quarto", "latex" },
    opts = {
      default = {
        dir_path = "img",
      },
      filetypes = {
        markdown = {
          url_encode_path = true,
          template = "![$CURSOR]($FILE_PATH)",
          drag_and_drop = {
            download_images = false,
          },
        },
        quarto = {
          url_encode_path = true,
          template = "![$CURSOR]($FILE_PATH)",
          drag_and_drop = {
            download_images = false,
          },
        },
      },
    },
    config = function(_, opts)
      require("img-clip").setup(opts)
      vim.keymap.set("n", "<leader>ii", ":PasteImage<cr>", { desc = "img-clip [i]nsert [i]mage from clipboard" })
    end,
  },
  {
    "jbyuki/nabla.nvim",
    lazy = false,
    keys = {
      { "<leader>qm", ':lua require"nabla".toggle_virt()<cr>', desc = "toggle [m]ath equations" },
    },
  },
  {
    "benlubas/molten-nvim",
    lazy = true,
    enabled = true,
    build = ":UpdateRemotePlugins",
    init = function()
      vim.g.molten_image_provider = "image.nvim"
      vim.g.molten_output_win_max_height = 20
      vim.g.molten_auto_open_output = false
    end,
    keys = {
      { "<leader>mi", ":MoltenInit<cr>", desc = "[m]olten [i]nit" },
      {
        "<leader>mv",
        ":<C-u>MoltenEvaluateVisual<cr>",
        mode = "v",
        desc = "molten eval visual",
      },
      { "<leader>mr", ":MoltenReevaluateCell<cr>", desc = "molten re-eval cell" },
    },
  },
}
