package main

import (
	"database/sql"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"

	_ "github.com/go-sql-driver/mysql"
	"github.com/gorilla/mux"
)

const port = ":5500"

type Todo struct {
	Id    int    `json:"id"`
	Name  string `json:"name"`
	Title string `json:"title"`
}

var db *sql.DB
var err error

func main() {
	db, err = sql.Open("mysql", "letmebelazy:19880122@tcp(127.0.0.1:3306)/db")
	if err != nil {
		panic(err.Error())
	}

	defer db.Close()

	router := mux.NewRouter()
	router.HandleFunc("/", getToRootPage)
	router.HandleFunc("/todos", getAllTodos).Methods("GET")
	router.HandleFunc("/todos/{id}", getTodo).Methods("GET")
	router.HandleFunc("/todos", createTodo).Methods("POST")
	router.HandleFunc("/todos/{id}", updateTodo).Methods("PATCH")
	router.HandleFunc("/todos/{id}", deleteTodo).Methods("DELETE")

	fmt.Println("Serving @ http://127.0.0.1" + port)
	log.Fatal(http.ListenAndServe(port, router))
}

func getToRootPage(w http.ResponseWriter, r *http.Request) {
	w.Write([]byte("This is root page"))
}

func getAllTodos(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")

	var todos []Todo

	result, err := db.Query("SELECT * FROM todos")
	if err != nil {
		panic(err.Error())
	}

	defer result.Close()

	for result.Next() {
		var todo Todo
		err := result.Scan(&todo.Id, &todo.Name, &todo.Title)
		if err != nil {
			panic(err.Error())
		}
		todos = append(todos, todo)
	}

	json.NewEncoder(w).Encode(todos)
}

func getTodo(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")

	params := mux.Vars(r)
	result, err := db.Query("SELECT * FROM todos WHERE id = ?", params["id"])
	if err != nil {
		panic(err.Error())
	}

	defer result.Close()

	var todo Todo

	for result.Next() {
		err := result.Scan(&todo.Id, &todo.Name, &todo.Title)
		if err != nil {
			panic(err.Error())
		}
	}

	json.NewEncoder(w).Encode(todo)
}

func createTodo(w http.ResponseWriter, r *http.Request) {
	stmt, err := db.Prepare("INSERT INTO todos(name, title) VALUES(?, ?)")
	if err != nil {
		panic(err.Error())
	}

	body, err := ioutil.ReadAll(r.Body)
	if err != nil {
		panic(err.Error())
	}

	todoMap := make(map[string]string)
	json.Unmarshal(body, &todoMap)
	name := todoMap["name"]
	title := todoMap["title"]

	_, err = stmt.Exec(name, title)
	if err != nil {
		panic(err.Error())
	}

	fmt.Fprintf(w, "New todo was created")
}

func updateTodo(w http.ResponseWriter, r *http.Request) {
	params := mux.Vars(r)

	stmt, err := db.Prepare("UPDATE todos SET name = ?, title = ? WHERE id = ?")
	if err != nil {
		panic(err.Error())
	}

	body, err := ioutil.ReadAll(r.Body)
	if err != nil {
		panic(err.Error())
	}

	todoMap := make(map[string]string)
	json.Unmarshal(body, &todoMap)
	name := todoMap["name"]
	title := todoMap["title"]

	_, err = stmt.Exec(name, title, params["id"])
	if err != nil {
		panic(err.Error())
	}

	fmt.Fprintf(w, "Todo with id = %s was updated", params["id"])
}

func deleteTodo(w http.ResponseWriter, r *http.Request) {
	params := mux.Vars(r)

	stmt, err := db.Prepare("DELETE FROM todos WHERE id =?")
	if err != nil {
		panic(err.Error())
	}

	_, err = stmt.Exec(params["id"])
	if err != nil {
		panic(err.Error())
	}

	fmt.Fprintf(w, "Todo with id = %s was deleted", params["id"])
}
