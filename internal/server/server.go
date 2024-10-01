package server

import (
	"context"
	"errors"
	"fmt"
	"log/slog"
	"net"
	"net/http"
	"os"
	"os/signal"
	"sync"
	"syscall"
	"time"

	"github.com/dlbarduzzi/demo/internal/logging"
)

type Server struct {
	ip        string
	port      int
	listener  net.Listener
	WaitGroup *sync.WaitGroup
}

func NewServer(port int) (*Server, error) {
	l, err := net.Listen("tcp", fmt.Sprintf(":%d", port))
	if err != nil {
		return nil, fmt.Errorf("failed to create listener - %w", err)
	}
	return &Server{
		ip:       l.Addr().(*net.TCPAddr).IP.String(),
		port:     l.Addr().(*net.TCPAddr).Port,
		listener: l,
	}, nil
}

func (s *Server) Start(ctx context.Context, handler http.Handler) error {
	log := logging.LoggerFromContext(ctx)

	srv := &http.Server{
		Addr:         fmt.Sprintf(":%d", s.port),
		Handler:      handler,
		IdleTimeout:  time.Second * 60,
		ReadTimeout:  time.Second * 10,
		WriteTimeout: time.Second * 30,
	}

	shutdownErr := make(chan error)

	go func() {
		quit := make(chan os.Signal, 1)
		signal.Notify(quit, syscall.SIGINT, syscall.SIGTERM)
		sig := <-quit

		log.Info("shutting down server", slog.String("signal", sig.String()))

		ctx, cancel := context.WithTimeout(context.Background(), time.Second*30)
		defer cancel()

		err := srv.Shutdown(ctx)
		if err != nil {
			shutdownErr <- err
		}

		log.Info("completing background tasks")

		if s.WaitGroup != nil {
			s.WaitGroup.Wait()
		}

		shutdownErr <- nil
	}()

	log.Info("starting server", slog.Int("port", s.port))

	err := srv.Serve(s.listener)
	if !errors.Is(err, http.ErrServerClosed) {
		return err
	}

	err = <-shutdownErr
	if err != nil {
		return err
	}

	log.Info("server stopped", slog.Int("port", s.port))

	return nil
}
