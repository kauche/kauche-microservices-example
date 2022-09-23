package command

import (
	"context"
	"fmt"
	"os"

	"github.com/kauche/kauche-microservices-example/cmd/platform/gqlgen/gqlgen"
)

func Run() {
	os.Exit(run(context.Background()))
}

func run(ctx context.Context) int {
	if err := gqlgen.Generate(ctx); err != nil {
		fmt.Fprintf(os.Stderr, "failed to generate files: %s\n", err)
		return 1
	}

	return 0
}
