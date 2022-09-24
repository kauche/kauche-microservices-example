package main

import (
	"context"
	"fmt"

	"github.com/kauche/kauche-microservices-example/api/services/customer/graphql/gqlgen/model"
)

type entityResolver struct{}

func (r *entityResolver) FindProductByID(ctx context.Context, id string) (*model.Product, error) {
	panic(fmt.Errorf("not implemented: FindProductByID - findProductByID"))
}
