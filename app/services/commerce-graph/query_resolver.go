package main

import (
	"context"
	"fmt"

	"github.com/kauche/kauche-microservices-example/lib/go/api/services/commerce/graphql"
	commercepb "github.com/kauche/kauche-microservices-example/lib/go/api/services/commerce/proto/v1"
)

type queryResolver struct {
	commerceClient commercepb.CommerceServerClient
}

func (r *queryResolver) Products(ctx context.Context) ([]*graphql.Product, error) {
	res, err := r.commerceClient.ListProducts(ctx, &commercepb.ListProductsRequest{})
	if err != nil {
		return nil, fmt.Errorf("failed to list products: %w", err)
	}

	products := make([]*graphql.Product, len(res.Products))

	for i, p := range res.Products {
		products[i] = &graphql.Product{
			ID:   p.Id,
			Name: p.Name,
		}
	}

	return products, nil
}

func (r *queryResolver) Product(ctx context.Context, id string) (*graphql.Product, error) {
	return &graphql.Product{
		ID:   id,
		Name: fmt.Sprintf("Product %s", id),
	}, nil
}
