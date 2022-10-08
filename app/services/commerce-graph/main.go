package main

import (
	"log"
	"net/http"
	"os"

	"github.com/99designs/gqlgen/graphql/handler"
	"github.com/99designs/gqlgen/graphql/playground"

	"github.com/kauche/kauche-microservices-example/lib/go/api/services/commerce/graphql"
)

const defaultPort = "9000"

func main() {
	port := os.Getenv("PORT")
	if port == "" {
		port = defaultPort
	}

	resolver := graphql.NewResolver(&entityResolver{}, &queryResolver{})
	srv := handler.NewDefaultServer(graphql.NewExecutableSchema(graphql.Config{Resolvers: resolver}))

	http.Handle("/", playground.Handler("GraphQL playground", "/query"))
	http.Handle("/query", srv)

	log.Printf("connect to http://localhost:%s/ for GraphQL playground", port)
	log.Fatal(http.ListenAndServe(":"+port, nil))
}
