return {

  cmd = { 'texlab' }
  filetypes = { 'tex', 'bib' }
  root_dir = function(filename)
    return util.path.dirname(filename)
  end,
  settings = {
    texlab = {
      auxDirectory = '.',
      bibtexFormatter = 'texlab',
      build = {
        args = { '-pdf', '-interaction=nonstopmode', '-synctex=1', '%f' },
        executable = 'latexmk',
        forwardSearchAfter = false,
        onSave = false,
      },
      chktex = {
        onEdit = false,
        onOpenAndSave = false,
      },
      diagnosticsDelay = 300,
      formatterLineLength = 80,
      forwardSearch = {
        args = {},
      },
      latexFormatter = 'latexindent',
      latexindent = {
        modifyLineBreaks = false,
      },
    },
  },
}
