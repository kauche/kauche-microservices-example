package main

import (
	"context"
	"fmt"

	"github.com/kauche/kauche-microservices-example/lib/go/api/services/social/graphql"
)

type entityResolver struct{}

func (r *entityResolver) FindProductByID(ctx context.Context, id string) (*graphql.Product, error) {
	panic(fmt.Errorf("not implemented: FindProductByID - findProductByID"))
}
