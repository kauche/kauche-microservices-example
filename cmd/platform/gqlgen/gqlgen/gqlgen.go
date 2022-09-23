package gqlgen

import (
	"context"
	"fmt"

	"github.com/99designs/gqlgen/api"
	"github.com/99designs/gqlgen/codegen/config"
	"github.com/99designs/gqlgen/plugin/federation"
	"github.com/99designs/gqlgen/plugin/modelgen"

	"github.com/kauche/kauche-microservices-example/cmd/platform/gqlgen/gqlgen/plugin/resolvergen"
)

const apolloFederationVersion = 2

func Generate(_ context.Context) error {
	config, err := config.LoadConfigFromDefaultLocations()
	if err != nil {
		return fmt.Errorf("failed to load the gqlgen config file: %w", err)
	}

	if err := api.Generate(
		config,
		api.NoPlugins(),
		api.AddPlugin(federation.New(apolloFederationVersion)),
		api.AddPlugin(modelgen.New()),
		api.AddPlugin(resolvergen.New()),
	); err != nil {
		return fmt.Errorf("failed to generate files: %w", err)
	}

	return nil
}
