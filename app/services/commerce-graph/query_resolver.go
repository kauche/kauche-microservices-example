package main

import (
	"context"

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
