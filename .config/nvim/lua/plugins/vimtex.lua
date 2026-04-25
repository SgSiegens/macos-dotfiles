return {
{
  "lervag/vimtex",
  lazy = false,     -- we don't want to lazy load VimTeX
  -- tag = "v2.15", -- uncomment to pin to a specific release
  init = function()
    -- VimTeX configuration goes here, e.g.
    vim.g.vimtex_view_method = "zathura"
  end,
  keys = {
    -- Compile LaTeX file
    { "<leader>vc", "<cmd>VimtexCompile<CR>", desc = "Compile LaTeX file" },

    -- Stop compilation
    { "<leader>vs", "<cmd>VimtexStop<CR>", desc = "Stop LaTeX compilation" },

    -- Clean auxiliary files
    { "<leader>vC", "<cmd>VimtexClean<CR>", desc = "Clean auxiliary files" },

    -- View PDF (open viewer & enable live reload)
    { "<leader>vv", "<cmd>VimtexView<CR>", desc = "Open PDF viewer" },

    -- Reload VimTeX (restart server)
    { "<leader>vr", "<cmd>VimtexReload<CR>", desc = "Reload VimTeX" },

    -- View PDF in a new tab (custom)
    { "<leader>vt", "<cmd>tabnew | VimtexView<CR>", desc = "View PDF in new tab" },
  },

}
}
