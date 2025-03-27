-- if true then
--   return {}
-- end
return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      yamlls = {
        settings = {
          yaml = {
            customTags = {
              "!Cidr",
              "!Cidr sequence",
              "!And",
              "!And sequence",
              "!If",
              "!If sequence",
              "!Not",
              "!Not sequence",
              "!Equals",
              "!Equals sequence",
              "!Or",
              "!Or sequence",
              "!FindInMap",
              "!FindInMap sequence",
              "!Base64",
              "!Join",
              "!Join sequence",
              "!Ref",
              "!Sub",
              "!Sub sequence",
              "!GetAtt",
              "!GetAZs",
              "!ImportValue",
              "!ImportValue sequence",
              "!Select",
              "!Select sequence",
              "!Split",
              "!Split sequence",
            },
          },
        },
      },
    },
  },
}
