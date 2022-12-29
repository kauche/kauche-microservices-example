package main

import (
	"context"

	"github.com/kauche/kauche-microservices-example/lib/go/api/services/social/graphql"
)

type commentResolver struct{}

func (r *commentResolver) User(ctx context.Context, obj *graphql.Comment) (*graphql.User, error) {
	return &graphql.User{
		ID:   "123",
		Name: "John",
	}, nil
}
