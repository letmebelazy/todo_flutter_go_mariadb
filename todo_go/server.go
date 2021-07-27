package main

import (
	"fmt"
	"log"
	"net/http"

	"github.com/gorilla/mux"
)

const port = ":5500"

type Todo struct {
	Index int
	Name  string
	Title string
}

func main() {
	router := mux.NewRouter()
	router.HandleFunc("/", getToRootPage)
	router.HandleFunc("/todos", getAllTodos).Methods("GET")
	router.HandleFunc("/todos/${index}", getTodo).Methods("GET")
	router.HandleFunc("/todos", createTodo).Methods("POST")
	router.HandleFunc("/todos/${index}", updateTodo).Methods("PATCH")
	router.HandleFunc("/todos/${index}", deleteTodo).Methods("DELETE")

	fmt.Println("Serving @ http://127.0.0.1" + port)
	log.Fatal(http.ListenAndServe(port, router))
}

func getToRootPage(w http.ResponseWriter, r *http.Request) {

}

func getAllTodos(w http.ResponseWriter, r *http.Request) {

}

func getTodo(w http.ResponseWriter, r *http.Request) {

}

func createTodo(w http.ResponseWriter, r *http.Request) {

}

func updateTodo(w http.ResponseWriter, r *http.Request) {

}

func deleteTodo(w http.ResponseWriter, r *http.Request) {

}
