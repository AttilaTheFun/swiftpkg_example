package main

import (
	"flag"
	"log"
	"os"
	"os/exec"
	"path/filepath"
)

func main() {

	// Parse the command line arguments:
	packageSwiftPathPointer := flag.String("package_swift_path", "", "/Path/To/Package.swift")
	flag.Parse()
	packageSwiftPath := *packageSwiftPathPointer
	if packageSwiftPath == "" {
		panic("package_swift_path flag not provided")
	}

	// Make a temporary directory:
	temporaryDirectory, err := os.MkdirTemp("", "")
	if err != nil {
		panic(err)
	}
	defer func() {
		err := os.RemoveAll(temporaryDirectory)
		if err != nil {
			panic(err)
		}
	}()

	// Symlink the Package.swift file into the temporary directory:
	temporaryPackageSwiftPath := filepath.Join(temporaryDirectory, "Package.swift")
	err = os.Symlink(packageSwiftPath, temporaryPackageSwiftPath)
	if err != nil {
		panic(err)
	}

	// Preserve the original working directory:
	workingDirectory, err := os.Getwd()
	if err != nil {
		panic(err)
	}

	// Change directory into the temporary directory:
	err = os.Chdir(temporaryDirectory)
	if err != nil {
		panic(err)
	}

	// Run the command:
	// TODO: Use toolchain to get swift binary path hermetically.
	cmd := exec.Command("/usr/bin/swift", "package", "resolve")
	err = cmd.Run()
	if err != nil {
		panic(err)
	}

	// Restore the original working directory:
	err = os.Chdir(workingDirectory)
	if err != nil {
		panic(err)
	}

	// Read the derived Swift files:
	packageResolvedPath := filepath.Join(temporaryDirectory, "Package.resolved")
	packageResolvedBytes, err := os.ReadFile(packageResolvedPath)
	if err != nil {
		panic(err)
	}

	log.Println("Package.resolved:\n", string(packageResolvedBytes))
}
