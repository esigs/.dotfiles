return {
  "seblyng/roslyn.nvim",
  ft = "cs",
  opts = {
    broad_search = true,
    config = {
      settings = {
        ["csharp|background_analysis"] = {
          dotnet_analyzer_diagnostics_scope = "fullSolution",
          dotnet_compiler_diagnostics_scope = "fullSolution",
        },
      },
    },
  },
}
