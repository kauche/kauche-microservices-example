package main

import (
	"context"
	"fmt"
	"log"
	"net/http"
	"os"

	"github.com/99designs/gqlgen/graphql/handler"
	"github.com/99designs/gqlgen/graphql/playground"
	"google.golang.org/grpc"

	"github.com/kauche/kauche-microservices-example/lib/go/api/services/commerce/graphql"
	commercepb "github.com/kauche/kauche-microservices-example/lib/go/api/services/commerce/proto/v1"
)

const defaultPort = "9000"

func main() {
	ctx := context.Background()

	port := os.Getenv("PORT")
	if port == "" {
		port = defaultPort
	}

	addr := os.Getenv("COMMERCE_GRPC_ADDR")
	if addr == "" {
		fmt.Fprintf(os.Stderr, "COMMERCE_GRPC_ADDR is not set\n")
		os.Exit(1)
	}

	cc, err := grpc.DialContext(ctx, addr, grpc.WithInsecure())
	if err != nil {
		fmt.Fprintf(os.Stderr, "failed to dial to the commerce grpc server: %v\n", err)
		os.Exit(1)

	}

	commerceClient := commercepb.NewCommerceServerClient(cc)

	resolver := graphql.NewResolver(&entityResolver{}, &queryResolver{commerceClient: commerceClient})
	srv := handler.NewDefaultServer(graphql.NewExecutableSchema(graphql.Config{Resolvers: resolver}))

	http.Handle("/", playground.Handler("GraphQL playground", "/query"))
	http.Handle("/query", srv)

	log.Printf("connect to http://localhost:%s/ for GraphQL playground", port)
	log.Fatal(http.ListenAndServe(":"+port, nil))
}
