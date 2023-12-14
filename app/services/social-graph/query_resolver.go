package main

import (
	"context"

	"github.com/kauche/kauche-microservices-example/lib/go/api/services/social/graphql"
)

type queryResolver struct{}

func (r *queryResolver) Customer(ctx context.Context, id string) (*graphql.Customer, error) {
	return &graphql.Customer{
		ID:   id,
		Name: "John",
	}, nil
}
