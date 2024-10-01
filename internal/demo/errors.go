package demo

import (
	"log/slog"
	"net/http"

	"github.com/dlbarduzzi/demo/internal/jsoner"
)

const ErrCodeServerError = "internal-server-error"

func (app *App) sendServerError(w http.ResponseWriter, r *http.Request, err error) {
	app.logger.Error(err.Error(),
		slog.String("method", r.Method),
		slog.String("path", r.URL.Path),
	)
	data := jsoner.Envelope{
		"ok":        false,
		"message":   "Something went wrong while processing your request.",
		"errorCode": ErrCodeServerError,
	}
	if err := jsoner.Marshal(w, data, http.StatusInternalServerError, nil); err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}
}
