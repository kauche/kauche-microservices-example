package main

import (
	"context"

	"github.com/kauche/kauche-microservices-example/lib/go/api/services/social/graphql"
)

var _ graphql.ProductResolver = (*productResolver)(nil)

type productResolver struct{}

func (r *productResolver) Comments(ctx context.Context, obj *graphql.Product) ([]*graphql.Comment, error) {
	return []*graphql.Comment{
		{
			ID:         "1",
			Text:       "Comment 1",
			CustomerID: "1",
		},
		{
			ID:         "2",
			Text:       "Comment 2",
			CustomerID: "2",
		},
	}, nil
}
