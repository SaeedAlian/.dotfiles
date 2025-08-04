return {
  cmd = { "clangd" },
  filetypes = { "h", "hpp", "c", "cpp", "objc", "objcpp", "cuda", "proto" },
  root_markers = {
    ".clang-tidy",
    ".clang-format",
    "CMakeLists.txt",
    "compile_commands.json",
    "compile_flags.txt",
    "configure.ac",
    ".git",
  },
  single_file_support = true,
  capabilities = {
    textDocument = {
      completion = {
        editsNearCursor = true,
      },
    },
    offsetEncoding = { "utf-8", "utf-16" },
  },
}
