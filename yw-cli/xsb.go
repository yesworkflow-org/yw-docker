#!/usr/bin/env gorun

package main

import (
	"fmt"
	"os"
)

func main() {
	s := "World"
	if len(os.Args) > 1 {
		s = os.Args[1]
	}
	fmt.Printf("Hello, %v!\n", s)

	os.Exit(0)
}
