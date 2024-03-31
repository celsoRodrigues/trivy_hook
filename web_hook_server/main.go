package main

import (
	"fmt"
	"log"
	"net/http"
	"net/http/httputil"
	"os"
	"time"
)

func main() {
	port, ok := os.LookupEnv("SRV_PORT")
	if !ok {
		port = "8000"
	}
	mux := http.NewServeMux()
	mux.HandleFunc("GET /", home)
	mux.HandleFunc("POST /trivy/report", trivyReport)

	srv := http.Server{
		Addr:        fmt.Sprintf(":%s", port),
		Handler:     mux,
		ReadTimeout: 3 * time.Second,
		IdleTimeout: 60 * time.Second,
	}
	log.Println("starting server on port", port)
	log.Fatal(srv.ListenAndServe())

}

func home(w http.ResponseWriter, r *http.Request) {
	w.Write([]byte("Home!"))
}

func trivyReport(w http.ResponseWriter, r *http.Request) {
	report, err := httputil.DumpRequest(r, true)
	if err != nil {
		log.Fatal(err)
	}
	log.Println(string(report))
}
