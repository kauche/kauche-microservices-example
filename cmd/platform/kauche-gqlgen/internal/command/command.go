package command

import (
	"context"
	"flag"
	"fmt"
	"os"

	"github.com/kauche/kauche-microservices-example/cmd/platform/kauche-gqlgen/internal/gqlgen"
)

func Run() {
	os.Exit(run(context.Background()))
}

func run(ctx context.Context) int {
	schema := flag.String("schema", "", "Schema File Path")
	path := flag.String("path", "", "Output File Path")

	flag.Parse()

	if err := gqlgen.Generate(ctx, *schema, *path); err != nil {
		fmt.Fprintf(os.Stderr, "failed to generate files: %s\n", err)
		return 1
	}

	return 0
}
