return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      -- Standard YAML server
      yamlls = {
        -- This is the crucial part:
        -- Stop yamlls from attaching to Helm files
        filetypes = { "yaml" },
        settings = {
          yaml = {
            customTags = {
              "!reference sequence",
            },
          },
        },
      },
      -- Dedicated Helm server
      helm_ls = {
        filetypes = { "helm" },
      },
    },
  },
}
