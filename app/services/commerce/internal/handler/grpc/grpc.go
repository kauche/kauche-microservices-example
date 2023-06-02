package grpc

import (
	"context"
	"fmt"
	"net"

	"github.com/110y/servergroup"
	"google.golang.org/grpc"

	commercepb "github.com/kauche/kauche-microservices-example/lib/go/api/services/commerce/proto/v1"
)

var (
	_ servergroup.Server  = (*Server)(nil)
	_ servergroup.Stopper = (*Server)(nil)
)

type Server struct {
	server *grpc.Server
	port   int
}

func NewServer(port int) *Server {
	server := grpc.NewServer()

	commercepb.RegisterCommerceServerServer(server, &commerceServer{})

	return &Server{
		server: server,
		port:   port,
	}
}

func (s *Server) Start(_ context.Context) error {
	lis, err := net.Listen("tcp", fmt.Sprintf(":%d", s.port))
	if err != nil {
		return fmt.Errorf("failed to listen on the port %d: %w", s.port, err)
	}

	if err := s.server.Serve(lis); err != nil {
		return fmt.Errorf("the server aborted: %w", err)
	}

	return nil
}

func (s *Server) Stop(_ context.Context) error {
	s.server.GracefulStop()

	return nil
}
