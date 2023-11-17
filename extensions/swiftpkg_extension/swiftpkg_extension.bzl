"""
Defines the swiftpkg_extension module extension.
"""

load("//rules/swiftpkg:swiftpkg.bzl", "swiftpkg")
load("//rules/swiftpkg_dependency:swiftpkg_dependency.bzl", "swiftpkg_dependency")

def _swiftpkg_extension_impl(module_ctx):
    print("here1")
    ctx.path(Label("//:librarian.cmd"))

    result = module_ctx.execute([librarian, "select"] + books)
    if result.return_code != 0:
        fail(result.stderr)
    resolved_book_list = json.decode(module_ctx.read("./booklist.json"))
    
    
    # swiftpkg(name="swiftpkg")

    # print("here2")
    # index_file = Label("@swiftpkg//:index.json")
    # index_string = module_ctx.read(index_file)
    # print(index_string)
    # index_json = json.decode(index_string)
    # for dependency in index_json["dependencies"]:
    #     swiftpkg_dependency(
    #         name="swiftpkg_" + dependency["identity"],
    #         location=dependency["identity"],
    #         revision=dependency["revision"]
    #     )

_from_file_tag = tag_class(
    attrs = {
        "package_swift": attr.label(mandatory = True),
    },
)

swiftpkg_extension = module_extension(
    implementation = _swiftpkg_extension_impl,
    tag_classes = {"from_file": _from_file_tag}
)
