package graph

// This file will be automatically regenerated based on the schema, any resolver implementations
// will be copied through when generating and any unknown code will be moved to the end.

import (
	"context"

	"github.com/kauche/kauche-microservices-example/app/services/commerce-graph/graph/generated"
	"github.com/kauche/kauche-microservices-example/app/services/commerce-graph/graph/model"
)

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

// Query returns generated.QueryResolver implementation.
func (r *Resolver) Query() generated.QueryResolver { return &queryResolver{r} }

type queryResolver struct{ *Resolver }
