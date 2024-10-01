package demo

import (
	"context"
	"log/slog"
	"sync"

	"github.com/dlbarduzzi/demo/internal/logging"
)

type App struct {
	config *Config
	logger *slog.Logger
	wg     sync.WaitGroup
}

func NewApp(ctx context.Context, cfg *Config) (*App, error) {
	log := logging.LoggerFromContext(ctx)

	cfg, err := cfg.parseConfig()
	if err != nil {
		return nil, err
	}

	return &App{
		config: cfg,
		logger: log,
	}, nil
}

func (app *App) Port() int {
	return app.config.Port
}

func (app *App) WaitGroup() *sync.WaitGroup {
	return &app.wg
}
