"""
Defines the swiftpkg_extension module extension.
"""

load("//rules/swiftpkg:swiftpkg.bzl", "swiftpkg")

def _swiftpkg_extension_impl(module_ctx):

    # Iterate over the modules and resolve the dependencies for each independently:
    for module in module_ctx.modules:

        # If the tag was not provided, just continue:
        if len(module.tags.from_file) == 0:
            continue

        # Ensure only one from file tag was provided for each module:
        if len(module.tags.from_file) > 1:
            fail(
                "Multiple \"swiftpkg_extension.from_file\" tags defined in module \"{}\": {}".format(
                    module.name,
                    ", ".join([str(tag.from_file) for tag in module.tags.from_file]),
                ),
            )
    
        # Extract the package swift path:
        package_swift_label = module.tags.from_file[0].package_swift
        package_swift_path = module_ctx.path(package_swift_label)

        # Extract the resolve swift packages path:
        resolve_swift_packages_label = Label("//actions/resolve_swift_packages:resolve_swift_packages.py")
        resolve_swift_packages_path = module_ctx.path(resolve_swift_packages_label)

        # Execute the command:
        result = module_ctx.execute([
            resolve_swift_packages_path,
            "--package_swift_path", 
            package_swift_path]
        )
        if result.return_code != 0:
            fail(result.stderr)
        package_resolved_json = json.decode(result.stdout)

        # Generate the dependencies:
        for dependency in package_resolved_json["pins"]:
            identity = dependency["identity"]
            swiftpkg(
                name="swiftpkg_" + identity,
                identity=identity,
                location=dependency["location"],
                revision=dependency["state"]["revision"]
            )

_from_file_tag = tag_class(
    attrs = {
        "package_swift": attr.label(mandatory = True),
    },
)

swiftpkg_extension = module_extension(
    implementation = _swiftpkg_extension_impl,
    tag_classes = {"from_file": _from_file_tag}
)
