package router

import (
	"net/http"

	"gundam-assemble-companion/backend/internal/controller"
)

func New(c *controller.Controller) http.Handler {
	mux := http.NewServeMux()
	mux.HandleFunc("/api/health", c.Health)
	mux.HandleFunc("/api/auth/signup", c.Signup)
	mux.HandleFunc("/api/auth/login", c.Login)
	mux.HandleFunc("/api/units", c.Units)
	mux.HandleFunc("/api/tactics-cards", c.TacticsCards)
	mux.HandleFunc("/api/squads", c.Squads)
	mux.HandleFunc("/api/squads/", c.Squad)
	return withCORS(mux)
}

func withCORS(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Access-Control-Allow-Origin", "*")
		w.Header().Set("Access-Control-Allow-Headers", "Content-Type")
		w.Header().Set("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS")
		if r.Method == http.MethodOptions {
			w.WriteHeader(http.StatusNoContent)
			return
		}
		next.ServeHTTP(w, r)
	})
}
