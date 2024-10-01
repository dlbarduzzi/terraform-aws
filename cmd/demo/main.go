package main

import (
	"context"
	"os"

	"github.com/dlbarduzzi/demo/internal/demo"
	"github.com/dlbarduzzi/demo/internal/logging"
	"github.com/dlbarduzzi/demo/internal/registry"
	"github.com/dlbarduzzi/demo/internal/server"
	"github.com/spf13/viper"
)

func main() {
	log := logging.NewLoggerFromEnv()

	ctx := context.Background()
	ctx = logging.LoggerWithContext(ctx, log)

	if err := start(ctx); err != nil {
		log.Error(err.Error())
		os.Exit(2)
	}
}

func start(ctx context.Context) error {
	log := logging.LoggerFromContext(ctx)

	reg, err := registry.NewRegistry()
	if err != nil {
		return err
	}

	appConfig := getAppConfig(reg)
	log.Info("database connection established")

	app, err := demo.NewApp(ctx, appConfig)
	if err != nil {
		return err
	}

	srv, err := server.NewServer(app.Port())
	if err != nil {
		return err
	}

	srv.WaitGroup = app.WaitGroup()
	return srv.Start(ctx, app.Routes())
}

func getAppConfig(v *viper.Viper) *demo.Config {
	return &demo.Config{
		Port: v.GetInt("DEMO_APP_PORT"),
	}
}
