local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local workspace_dir = "/home/parasonge/.local/state/nvim/" .. project_name
return {
  "mfussenegger/nvim-jdtls",
  opts = {
    jdtls = {
      cmd = {
        "/home/parasonge/.sdkman/candidates/java/24.0.1-open/bin/java",
        "-Declipse.application=org.eclipse.jdt.ls.core.id1",
        "-Dosgi.bundles.defaultStartLevel=4",
        "-Declipse.product=org.eclipse.jdt.ls.core.product",
        "-Dlog.protocol=true",
        "-Dlog.level=ALL",
        "-Xmx1g",
        "--add-modules=ALL-SYSTEM",
        "--add-opens",
        "java.base/java.util=ALL-UNNAMED",
        "--add-opens",
        "java.base/java.lang=ALL-UNNAMED",
        -- jar jdtls
        "-jar",
        "/home/parasonge/.local/share/nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_1.6.900.v20240613-2009.jar",
        -- config dir os specific
        "-configuration",
        "/home/parasonge/.local/share/nvim/mason/packages/jdtls/config_linux",
        -- workspace data dir for lsp
        "-data",
        workspace_dir,
      },
    },
    settings = {
      java = {
        inlayHints = {
          parameterNames = {
            enabled = "all",
          },
        },
        configuration = {
          runtimes = {
            {
              name = "JavaSE-11",
              path = "/home/parasonge/.sdkman/candidates/java/11.0.15-trava",
            },
          },
        },
      },
    },
  },
}
