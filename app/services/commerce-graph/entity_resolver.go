package main

import (
	"context"

	"github.com/kauche/kauche-microservices-example/lib/go/api/services/commerce/graphql"
)

type entityResolver struct{}

func (r *entityResolver) FindProductByID(ctx context.Context, id string) (*graphql.Product, error) {
	return &graphql.Product{
		ID:   "1",
		Name: "John",
	}, nil
}
