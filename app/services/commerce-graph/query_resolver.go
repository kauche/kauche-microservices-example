package main

import (
	"context"

	"github.com/kauche/kauche-microservices-example/api/services/customer/graphql/gqlgen/model"
)

type queryResolver struct{}

func (r *queryResolver) Products(ctx context.Context) ([]*model.Product, error) {
	return []*model.Product{
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
