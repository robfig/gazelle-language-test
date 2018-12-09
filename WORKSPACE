http_archive(
    name = "com_google_protobuf",
    url = "https://github.com/protocolbuffers/protobuf/releases/download/v3.6.1/protobuf-all-3.6.1.tar.gz",
    sha256 = "fd65488e618032ac924879a3a94fa68550b3b5bcb445b93b7ddf3c925b1a351f",
    strip_prefix = "protobuf-3.6.1",
)

http_archive(
    name = "build_stack_rules_proto",
    url = "https://github.com/stackb/rules_proto/archive/4c2226458203a9653ae722245cc27e8b07c383f7.zip",
    sha256 = "47d9f2fe7d9219f7f08a494e9c76a94e0d97bc6c787401ebefad678bdd5a0b77",
    strip_prefix = "rules_proto-4c2226458203a9653ae722245cc27e8b07c383f7"
)

http_archive(
    name = "io_bazel_rules_go",
    sha256 = "f87fa87475ea107b3c69196f39c82b7bbf58fe27c62a338684c20ca17d1d8613",
    url = "https://github.com/bazelbuild/rules_go/releases/download/0.16.2/rules_go-0.16.2.tar.gz",
)

git_repository(
    name = "bazel_gazelle",
    commit = "6231478988f0a0b751a436d57d38bc09c1dcfdca",
    remote = "https://github.com/bazelbuild/bazel-gazelle",
)

load("@io_bazel_rules_go//go:def.bzl", "go_rules_dependencies", "go_register_toolchains")

go_rules_dependencies()

go_register_toolchains()

load("@bazel_gazelle//:deps.bzl", "gazelle_dependencies", "go_repository")

gazelle_dependencies()
