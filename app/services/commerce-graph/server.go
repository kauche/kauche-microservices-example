package main

import (
	"log"
	"net/http"
	"os"

	"github.com/99designs/gqlgen/graphql/handler"
	"github.com/99designs/gqlgen/graphql/playground"

	"github.com/kauche/kauche-microservices-example/api/services/customer/graphql/gqlgen"
)

const defaultPort = "9000"

func main() {
	port := os.Getenv("PORT")
	if port == "" {
		port = defaultPort
	}

	resolver := gqlgen.NewResolver(&entityResolver{}, &queryResolver{})
	srv := handler.NewDefaultServer(gqlgen.NewExecutableSchema(gqlgen.Config{Resolvers: resolver}))

	http.Handle("/", playground.Handler("GraphQL playground", "/query"))
	http.Handle("/query", srv)

	log.Printf("connect to http://localhost:%s/ for GraphQL playground", port)
	log.Fatal(http.ListenAndServe(":"+port, nil))
}
