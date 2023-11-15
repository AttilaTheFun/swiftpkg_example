"""
Defines the swiftpkg_dependency_extension module extension.
"""

load("//rules/swiftpkg_dependency:swiftpkg_dependency.bzl", "swiftpkg_dependency")

def _swiftpkg_dependency_extension_impl(module_ctx):
    for module in module_ctx.modules:
        for index_tag in module.tags.index:
            index_file = index_tag._index_file
            index_string = module_ctx.read(index_file)
            index_json = json.decode(index_string)
            for dependency in index_json["dependencies"]:
                swiftpkg_dependency(
                    name="swiftpkg_" + dependency["identity"],
                    location=dependency["identity"],
                    revision=dependency["revision"]
                )

_index_tag_class = tag_class(attrs = {
    "_index_file": attr.label(default = "@swiftpkg//:index.json", allow_files = True),
})

swiftpkg_dependencies_extension = module_extension(
    implementation = _swiftpkg_dependency_extension_impl,
    tag_classes = {"index": _index_tag_class}
)
