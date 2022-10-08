package gqlgen

import (
	"context"
	"fmt"
	"path/filepath"

	"github.com/99designs/gqlgen/api"
	"github.com/99designs/gqlgen/codegen/config"
	"github.com/99designs/gqlgen/plugin/federation"
	"github.com/99designs/gqlgen/plugin/modelgen"

	"github.com/kauche/kauche-microservices-example/cmd/platform/kauche-gqlgen/internal/gqlgen/plugin/resolvergen"
)

const apolloFederationVersion = 2

func Generate(_ context.Context, schema, path string) error {
	cfg, err := config.LoadConfigFromDefaultLocations()
	if err != nil {
		return fmt.Errorf("failed to load the gqlgen config file: %w", err)
	}

	cfg.SchemaFilename = []string{schema}

	cfg.Exec.Filename = filepath.Join(path, cfg.Exec.Filename)
	cfg.Federation.Filename = filepath.Join(path, cfg.Federation.Filename)
	cfg.Model.Filename = filepath.Join(path, cfg.Model.Filename)
	cfg.Resolver.Filename = filepath.Join(path, cfg.Resolver.Filename)

	// var schemaRaw []byte
	// schemaRaw, err = os.ReadFile(schema)
	// if err != nil {
	//     return fmt.Errorf("unable to open schema: %w", err)
	// }

	// cfg.Sources = append(cfg.Sources, &ast.Source{Name: schema, Input: string(schemaRaw)})

	if err := config.CompleteConfig(cfg); err != nil {
		return fmt.Errorf("failed to complete config: %w", err)
	}

	if err := api.Generate(
		cfg,
		api.NoPlugins(),
		api.AddPlugin(federation.New(apolloFederationVersion)),
		api.AddPlugin(modelgen.New()),
		api.AddPlugin(resolvergen.New()),
	); err != nil {
		return fmt.Errorf("failed to generate files: %w", err)
	}

	return nil
}
