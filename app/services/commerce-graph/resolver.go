package main

import (
	"context"
	"fmt"

	"github.com/kauche/kauche-microservices-example/api/services/customer/graphql/graph/generated"
	"github.com/kauche/kauche-microservices-example/api/services/customer/graphql/graph/model"
)

type Resolver struct {
	QueryResolver  generated.QueryResolver
	EntityResolver generated.EntityResolver
}

func (r *Resolver) Query() generated.QueryResolver { return r.QueryResolver }

func (r *Resolver) Entity() generated.EntityResolver { return r.EntityResolver }

type queryResolver struct{}

// Products is the resolver for the products field.
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

type entityResolver struct{}

func (r *entityResolver) FindProductByID(ctx context.Context, id string) (*model.Product, error) {
	panic(fmt.Errorf("not implemented: FindProductByID - findProductByID"))
}
