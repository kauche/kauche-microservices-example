package grpc

import (
	"context"
	"fmt"

	commercepb "github.com/kauche/kauche-microservices-example/lib/go/api/services/commerce/proto/v1"
)

type commerceServer struct{}

func (c *commerceServer) GetProduct(_ context.Context, req *commercepb.GetProductRequest) (*commercepb.Product, error) {
	// TODO: use db
	return &commercepb.Product{
		Id:   req.Id,
		Name: fmt.Sprintf("name-%s", req.Id),
	}, nil
}

func (c *commerceServer) ListProducts(_ context.Context, _ *commercepb.ListProductsRequest) (*commercepb.ListProductsResponse, error) {
	// TODO: use db
	return &commercepb.ListProductsResponse{
		Products: []*commercepb.Product{
			{
				Id:   "0c722b27-8ee3-481f-9675-7065edbdb419",
				Name: "Product 1",
			},
			{
				Id:   "76089452-025e-4561-a8f8-665a9d414bed",
				Name: "Product 2",
			},
		},
	}, nil
}
