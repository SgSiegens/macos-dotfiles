---@type vim.lsp.Config
return {
  cmd = { 'ruff', 'server' },
  filetypes = { 'python' },
  root_markers = { 'pyproject.toml', 'ruff.toml', '.ruff.toml', '.git' },
  settings = {},
}
-- }		settings = {
-- 			configurationPreference = 'filesystemFirst',
-- 			fixAll = true,
-- 			organizeImports = true,
-- 			lint = {
-- 				enable = true,
-- 				preview = true,
-- 			},
-- 			format = {
-- 				preview = true,
-- 			},
-- 		},
