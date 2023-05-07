package main

import (
	"context"

	"github.com/kauche/kauche-microservices-example/lib/go/api/services/social/graphql"
)

type queryResolver struct{}

func (r *queryResolver) Products(ctx context.Context) ([]*graphql.Product, error) {
	return []*graphql.Product{
		{
			ID: "1",
		},
		{
			ID: "2",
		},
	}, nil
}

func (r *queryResolver) Product(ctx context.Context, id string) (*graphql.Product, error) {
	return &graphql.Product{
		ID: id,
	}, nil
}

func (r *queryResolver) Customer(ctx context.Context, id string) (*graphql.Customer, error) {
	return &graphql.Customer{
		ID:   id,
		Name: "John",
	}, nil
}
