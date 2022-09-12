package graph

// This file will be automatically regenerated based on the schema, any resolver implementations
// will be copied through when generating and any unknown code will be moved to the end.

import (
	"context"
	"fmt"

	"github.com/kauche/kauche-microservices-example/app/services/commerce-graph/graph/generated"
	"github.com/kauche/kauche-microservices-example/app/services/commerce-graph/graph/model"
)

// FindProductByID is the resolver for the findProductByID field.
func (r *entityResolver) FindProductByID(ctx context.Context, id string) (*model.Product, error) {
	panic(fmt.Errorf("not implemented: FindProductByID - findProductByID"))
}

// Entity returns generated.EntityResolver implementation.
func (r *Resolver) Entity() generated.EntityResolver { return &entityResolver{r} }

type entityResolver struct{ *Resolver }
