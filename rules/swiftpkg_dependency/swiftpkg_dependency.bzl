"""
Defines the swiftpkg_dependency repository rule.
"""

def _swiftpkg_dependency_impl(repository_ctx):
    print(repository_ctx.attr.location)
    print(repository_ctx.attr.revision)
    repository_ctx.file("name.txt", repository_ctx.name)
    repository_ctx.file("BUILD.bazel", 'exports_files(["name.txt"])')

swiftpkg_dependency = repository_rule(
    implementation=_swiftpkg_dependency_impl,
    attrs={
        "location": attr.string(),
        "revision": attr.string(),
    }
)
