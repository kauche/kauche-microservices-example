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
			Comments: []*graphql.Comment{
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
			Comments: []*graphql.Comment{
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
