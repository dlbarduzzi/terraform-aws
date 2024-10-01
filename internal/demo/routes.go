package demo

import (
	"net/http"

	"github.com/dlbarduzzi/demo/internal/middleware"
)

func (app *App) Routes() http.Handler {
	mux := http.NewServeMux()

	// Health endpoint.
	mux.HandleFunc("GET /api/v1/health", app.healthHandler)

	return middleware.Recovery(middleware.RecordRequest(mux))
}
