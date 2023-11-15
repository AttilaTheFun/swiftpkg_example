"""
Defines the swiftpkg repository rule.
"""

def _swiftpkg_impl(repository_ctx):
    """
    Implementation of swiftpkg repository rule.
    """

    repository_ctx.file("index.json", """{
  "dependencies" : [
    {
      "identity": "devicekit",
      "location": "https://github.com/devicekit/DeviceKit",
      "revision": "d37e70cb2646666dcf276d7d3d4a9760a41ff8a6"
    },
    {
      "identity": "kingfisher",
      "location": "https://github.com/onevcat/Kingfisher",
      "revision": "b6f62758f21a8c03cd64f4009c037cfa580a256e"
    }
  ]
}""")
    repository_ctx.file("BUILD.bazel", 'exports_files(["index.json"])')

swiftpkg = repository_rule(
    implementation=_swiftpkg_impl,
    attrs={
    }
)
