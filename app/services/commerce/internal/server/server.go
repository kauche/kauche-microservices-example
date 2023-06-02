package server

import (
	"context"
	"fmt"
	"os"

	"github.com/110y/run"
	"github.com/110y/servergroup"

	"github.com/kauche/kauche-microservices-example/app/services/commerce/internal/handler/grpc"
)

func Run() {
	run.Run(server)
}

func server(ctx context.Context) (code int) {
	gs := grpc.NewServer(8000)

	var sg servergroup.Group
	sg.Add(gs)

	if err := sg.Start(ctx); err != nil {
		// TODO: structured log
		fmt.Fprintf(os.Stderr, "the server aborted: %s\n", err)
		return 1
	}

	return 0
}
