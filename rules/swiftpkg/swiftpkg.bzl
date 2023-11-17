"""
Defines the swiftpkg repository rule.
"""

def _swiftpkg_impl(repository_ctx):
    repository_ctx.file("name.txt", repository_ctx.name)
    repository_ctx.file("BUILD.bazel", 'exports_files(["name.txt"])')

swiftpkg = repository_rule(
    implementation=_swiftpkg_impl,
    attrs={
        "identity": attr.string(),
        "location": attr.string(),
        "revision": attr.string(),
    }
)
