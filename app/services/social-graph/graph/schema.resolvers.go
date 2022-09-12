package graph

// This file will be automatically regenerated based on the schema, any resolver implementations
// will be copied through when generating and any unknown code will be moved to the end.

import (
	"context"

	"github.com/kauche/kauche-microservices-example/app/services/social-graph/graph/generated"
	"github.com/kauche/kauche-microservices-example/app/services/social-graph/graph/model"
)

// Products is the resolver for the products field.
func (r *queryResolver) Products(ctx context.Context) ([]*model.Product, error) {
	return []*model.Product{
		{
			ID: "1",
			Comments: []*model.Comment{
				{
					ID:   "1",
					Text: "Comment 1",
				},
				{
					ID:   "2",
					Text: "Comment 2",
				},
			},
		},
		{
			ID: "2",
			Comments: []*model.Comment{
				{
					ID:   "3",
					Text: "Comment 3",
				},
				{
					ID:   "4",
					Text: "Comment 4",
				},
			},
		},
	}, nil
}

// Query returns generated.QueryResolver implementation.
func (r *Resolver) Query() generated.QueryResolver { return &queryResolver{r} }

type queryResolver struct{ *Resolver }
