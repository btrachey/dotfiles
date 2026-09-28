return {
  cmd = { "protols" },
  root_markers = { "build.sbt", "pom.xml" },
  filetypes = { "proto" },
  init_options = {
    include_paths = { "src/main/protobuf" },
  },
}
