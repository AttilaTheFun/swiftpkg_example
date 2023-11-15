"""
Defines the swiftpkg_extension module extension.
"""

load("//rules/swiftpkg:swiftpkg.bzl", "swiftpkg")

def _swiftpkg_ext_impl(_ctx):
    swiftpkg(name="swiftpkg")

swiftpkg_extension = module_extension(
    implementation = _swiftpkg_ext_impl,
)
