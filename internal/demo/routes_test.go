package demo

import "testing"

func TestRoutes(t *testing.T) {
	t.Parallel()
	app := newTestApp(t)
	if app.Routes() == nil {
		t.Errorf("expected routes not to be nil")
	}
}
