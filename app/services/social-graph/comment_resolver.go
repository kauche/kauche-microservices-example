package main

import (
	"context"
	"fmt"

	"github.com/kauche/kauche-microservices-example/lib/go/api/services/social/graphql"
)

var _ graphql.CommentResolver = (*commentResolver)(nil)

type commentResolver struct{}

func (r *commentResolver) Customer(ctx context.Context, obj *graphql.Comment) (*graphql.Customer, error) {
	return &graphql.Customer{
		ID:   obj.CustomerID,
		Name: fmt.Sprintf("John-%s", obj.CustomerID),
	}, nil
}
