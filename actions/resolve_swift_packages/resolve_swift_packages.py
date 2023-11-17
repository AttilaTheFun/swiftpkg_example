#!/usr/bin/env python3

import os
import tempfile
import shutil
import subprocess
import argparse
import logging

def main():

    # Parse the command line arguments:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--package_swift_path", 
        required=True, 
        help="/Path/To/Package.swift"
    )
    args = parser.parse_args()
    package_swift_path = args.package_swift_path

    # Make a temporary directory:
    temporary_directory = tempfile.mkdtemp()
    try:

        # Symlink the Package.swift file into the temporary directory:
        temporary_package_swift_path = os.path.join(temporary_directory, "Package.swift")
        os.symlink(package_swift_path, temporary_package_swift_path)

        # Preserve the original working directory:
        working_directory = os.getcwd()

        # Change directory into the temporary directory:
        os.chdir(temporary_directory)

        # Run the command:
        # TODO: Use toolchain to get swift binary path hermetically.
        cmd = ["/usr/bin/swift", "package", "resolve"]
        subprocess.run(cmd, check=True)

        # Restore the original working directory:
        os.chdir(working_directory)

        # Read the derived Swift files:
        package_resolved_path = os.path.join(temporary_directory, "Package.resolved")
        with open(package_resolved_path, 'r') as file:
            package_resolved_content = file.read()
            print(package_resolved_content)

    finally:
        # Remove the temporary directory:
        shutil.rmtree(temporary_directory)

if __name__ == "__main__":
    main()