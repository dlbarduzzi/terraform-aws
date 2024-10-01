package demo

import (
	"net/http"
	"strings"
	"testing"
)

func TestHealthHandler(t *testing.T) {
	t.Parallel()
	app := newTestApp(t)

	srv := newTestServer(t, app.Routes())
	defer srv.Close()

	code, body := srv.get(t, "/api/v1/health")

	if code != http.StatusOK {
		t.Errorf("expected status code to be %v; got %v", http.StatusOK, code)
	}

	wantBody := "healthy"

	if !strings.Contains(body, wantBody) {
		t.Errorf("expected response body to contain %v; got %v", wantBody, body)
	}
}
