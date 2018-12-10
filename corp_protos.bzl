load("@build_stack_rules_proto//:compile.bzl", "proto_compile")
load("@build_stack_rules_proto//:plugin.bzl", "proto_plugin")
load("@build_stack_rules_proto//go:utils.bzl", "get_importmappings")
load("@io_bazel_rules_go//go:def.bzl", "go_library")

def corp_protos(name, srcs = [], deps = [], verbose = 0, **kwargs):
    visibility = kwargs.pop("visibility", None)
    importpath = kwargs.pop("importpath", "alpha/"+native.package_name())
    go_plugins = kwargs.pop("go_plugins", None)

    native.proto_library(
        name = name,
        srcs = srcs,
        deps = deps,
        visibility = visibility,
        **kwargs
    )

    _go_protos(name, deps, importpath, visibility, verbose, go_plugins, **kwargs)

def _target_name(name, suffix):
    base_name = name
    if name.endswith("_proto"):
        base_name = name[0:-len("_proto")]
    return base_name + suffix

def _is_wkt_proto(dep):
    if dep.startswith("@"):
        return True
    pkg = native.package_name()
    if dep.startswith("//"):
        pkg = Label(dep).package
    return pkg in ["thirdparty/protos/google/protobuf", "tools/protobuf"]

_wkt_mappings = get_importmappings({
    "google/protobuf/any.proto":         "github.com/gogo/protobuf/types",
    "google/protobuf/api.proto":         "github.com/gogo/protobuf/types",
    "google/protobuf/descriptor.proto":  "github.com/gogo/protobuf/protoc-gen-gogo/descriptor",
    "google/protobuf/duration.proto":    "github.com/gogo/protobuf/types",
    "google/protobuf/empty.proto":       "github.com/gogo/protobuf/types",
    "google/protobuf/struct.proto":      "github.com/gogo/protobuf/types",
    "google/protobuf/timestamp.proto":   "github.com/gogo/protobuf/types",
    "google/protobuf/wrappers.proto":    "github.com/gogo/protobuf/types",
})

def _go_protos(name, deps, importpath, visibility, verbose, go_plugins, **kwargs):
    if not go_plugins:
        name_default_plugin = name + "_plugin"
        proto_plugin(
            name = name_default_plugin,
            outputs = ["{package}/%s/{basename}.pb.go" % importpath],
            tool = "@com_github_gogo_protobuf//protoc-gen-gogo",
        )
        go_plugins = [":"+name_default_plugin]

    go_proto_compile_name = _target_name(name, "_go_proto_compile")
    proto_compile(
        name = go_proto_compile_name,
        deps = [name],
        plugins = go_plugins,
        plugin_options = _wkt_mappings,
        visibility = ["//visibility:private"],
        verbose = verbose,
        **kwargs
    )

    go_library_name = _target_name(name, "_go_proto")
    go_library(
        name = go_library_name,
        srcs = [go_proto_compile_name],
        deps = ["@com_github_gogo_protobuf//proto:go_default_library",
                "@com_github_gogo_protobuf//types:go_default_library",
                "@com_github_gogo_protobuf//protoc-gen-gogo/descriptor:go_default_library"]
             + [_target_name(d, "_go_proto") for d in deps if not _is_wkt_proto(d)],
        importpath = importpath,
        visibility = visibility,
        **kwargs
    )
