require('nightfox').setup({
  options = {
    transparent = true,
    styles = {
      comments = "bold",
      keywords = "bold",
      types = "bold",
    }
  }
})

vim.cmd("colorscheme nightfox")

