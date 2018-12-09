load("@io_bazel_rules_go//go:def.bzl", "go_library")

package(default_visibility = ["//visibility:public"])

load("@bazel_gazelle//:def.bzl", "gazelle")
load("@bazel_gazelle//:def.bzl", "DEFAULT_LANGUAGES", "gazelle_binary")

gazelle_binary(
    name = "gazelle_bin",
    languages = [
        "@bazel_gazelle//language/proto:go_default_library",
        "@bazel_gazelle//language/go:go_default_library",
        "//customlang:go_default_library",
    ],
)

# gazelle:prefix alpha
gazelle(
    name = "gazelle",
    gazelle = ":gazelle_bin",
)
