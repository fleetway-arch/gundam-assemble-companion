package main

import (
	"log"
	"net/http"
	"os"

	"gundam-assemble-companion/backend/internal/controller"
	"gundam-assemble-companion/backend/internal/repository"
	"gundam-assemble-companion/backend/internal/router"
)

func main() {
	addr := os.Getenv("ADDR")
	if addr == "" {
		port := os.Getenv("PORT")
		if port == "" {
			port = "8080"
		}
		addr = ":" + port
	}
	databasePath := os.Getenv("DATABASE_PATH")
	if databasePath == "" {
		databasePath = "gundam.db"
	}

	repo, err := repository.NewSQLite(databasePath)
	if err != nil {
		log.Fatalf("open database: %v", err)
	}
	defer repo.Close()

	application := controller.New(repo)
	server := &http.Server{
		Addr:    addr,
		Handler: router.New(application),
	}

	log.Printf("Gundam Assemble API listening on %s", addr)
	if err := server.ListenAndServe(); err != nil && err != http.ErrServerClosed {
		log.Fatalf("serve: %v", err)
	}
}
