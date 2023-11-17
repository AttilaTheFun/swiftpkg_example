package main

import "os/exec"

func main() {
	cmd := exec.Command("/usr/bin/swift", "package", "resolve")
	err := cmd.Run()
	if err != nil {
		panic(err)
	}
}
