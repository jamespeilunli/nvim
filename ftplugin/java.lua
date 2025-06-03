-- Configuration details: https://github.com/mfussenegger/nvim-jdtls?tab=readme-ov-file#configuration-verbose

local workspace_dir = vim.fn.systemlist("git rev-parse --show-toplevel")[1] or vim.fn.getcwd()
local project_name = vim.fn.fnamemodify(workspace_dir, ":p:h:t")
local workspace_cache = "/home/jamesli/.cache/jdtls/" .. project_name

vim.fn.mkdir(workspace_cache, "p")

-- See `:help vim.lsp.start_client` for an overview of the supported `config` options.
local config = {
  cmd = {
    "/usr/lib/jvm/java-21-openjdk-amd64/bin/java",

    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dlog.protocol=true",
    "-Dlog.level=ALL",
    "-Xms1g",
    "-Xmx2g",
    "--add-modules=ALL-SYSTEM",
    "--add-opens",
    "java.base/java.util=ALL-UNNAMED",
    "--add-opens",
    "java.base/java.lang=ALL-UNNAMED",

    "-jar",
    "/home/jamesli/.local/share/jdt-language-server-1.47.0/plugins/org.eclipse.equinox.launcher_1.7.0.v20250424-1814.jar",

    "-configuration",
    "/home/jamesli/.local/share/jdt-language-server-1.47.0/config_linux",

    "-data",
    workspace_cache,
  },

  root_dir = require("jdtls.setup").find_root({ "build.gradle", ".git" }),

  -- Configure eclipse.jdt.ls specific settings
  -- https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
  settings = {
    java = {
      home = "/usr/lib/jvm/java-21-openjdk-amd64",
      project = {
        referencedLibraries = {
          "**/build/libs/*.jar",
          "**/build/deps/*.jar",
          "lib/**/*.jar",
        },
      },
      import = {
        gradle = {
          enabled = true,
          wrapper = {
            enabled = true,
          },
        },
        maven = {
          enabled = false,
        },
        exclusions = {
          "**/node_modules/**",
          "**/.metadata/**",
        },
      },
      autobuild = {
        enabled = false,
      },

      configuration = {
        updateBuildConfiguration = "automatic",
      },
      server = {
        launchMode = "Standard",
      },
      completion = {
        favoriteStaticMembers = {
          "org.junit.Assert.*",
          "org.junit.Assume.*",
          "org.junit.jupiter.api.Assertions.*",
          "org.junit.jupiter.api.Assumptions.*",
          "org.junit.jupiter.api.DynamicContainer.*",
          "org.junit.jupiter.api.DynamicTest.*",
          "org.mockito.Mockito.*",
          "org.mockito.ArgumentMatchers.*",
          "org.mockito.Answers.*",
          "edu.wpi.first.units.Units.*",
        },
        filteredTypes = {
          "java.awt.*",
          "com.sun.*",
          "sun.*",
          "jdk.*",
          "org.graalvm.*",
          "io.micrometer.shaded.*",
          "java.beans.*",
          "java.util.Base64.*",
          "java.util.Timer",
          "java.sql.*",
          "javax.swing.*",
          "javax.management.*",
          "javax.smartcardio.*",
          "edu.wpi.first.math.proto.*",
          "edu.wpi.first.math.**.proto.*",
          "edu.wpi.first.math.**.struct.*",
        },
      },
    },
  },

  -- Language server `initializationOptions`
  -- You need to extend the `bundles` with paths to jar files
  -- if you want to use additional eclipse.jdt.ls plugins.
  --
  -- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
  --
  -- If you don't plan on using the debugger or other eclipse.jdt.ls plugins you can remove this
  init_options = {
    bundles = {},
    -- workspaceFolders = { workspace_dir }, -- issues on ubuntu?
  },
}

-- This starts a new client & server,
-- or attaches to an existing client & server depending on the `root_dir`.
require("jdtls").start_or_attach(config)
