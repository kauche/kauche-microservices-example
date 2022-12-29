package main

import (
	"context"

	"github.com/kauche/kauche-microservices-example/lib/go/api/services/social/graphql"
)

var _ graphql.CommentResolver = (*commentResolver)(nil)

type commentResolver struct{}

func (r *commentResolver) Customer(ctx context.Context, obj *graphql.Comment) (*graphql.Customer, error) {
	return &graphql.Customer{
		ID:   "123",
		Name: "John",
	}, nil
}
