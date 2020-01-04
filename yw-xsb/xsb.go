//#!/usr/bin/env gorun

package main

import (
	"fmt"
	"os"
	"os/exec"
)

func main() {
	// s := "World"
	// if len(os.Args) > 1 {
	// 	s = os.Args[1]
	// }

	cmd := exec.Command("docker", "run", "yesworkflow/xsb:0.3.0")
	cmd.Stdin = os.Stdin
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr

	err := cmd.Start()
	cmd.Wait()

	if err != nil {
		fmt.Println(err)
		os.Exit(-1)
	}
}
