package main

import (
	"context"
	"fmt"

	"github.com/kauche/kauche-microservices-example/lib/go/api/services/commerce/graphql"
)

type queryResolver struct{}

func (r *queryResolver) Products(ctx context.Context) ([]*graphql.Product, error) {
	return []*graphql.Product{
		{
			ID:   "1",
			Name: "Product 1",
		},
		{
			ID:   "2",
			Name: "Product 2",
		},
	}, nil
}

func (r *queryResolver) Product(ctx context.Context, id string) (*graphql.Product, error) {
	return &graphql.Product{
		ID:   id,
		Name: fmt.Sprintf("Product %s", id),
	}, nil
}
