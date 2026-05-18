package main

import (
	"log"
	"net/http"
)

func main() {
	fileServer := http.FileServer(http.Dir("."))
	http.Handle("/", fileServer)

	log.Println("Server starting on http://localhost:8080")
	log.Fatal(http.ListenAndServe(":8080", nil))

}
