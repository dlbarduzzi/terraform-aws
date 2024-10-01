package demo

import (
	"net/http"

	"github.com/dlbarduzzi/demo/internal/jsoner"
)

func (app *App) healthHandler(w http.ResponseWriter, r *http.Request) {
	data := jsoner.Envelope{
		"ok":     true,
		"status": "healthy",
	}
	if err := jsoner.Marshal(w, data, http.StatusOK, nil); err != nil {
		app.sendServerError(w, r, err)
		return
	}
}
