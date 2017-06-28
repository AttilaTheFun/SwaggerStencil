{% include "header.stencil" %}
package main

import (
	"log"
	"net/http"

	"github.com/gorilla/mux"
	"{{ path }}/bindings"
	"{{ path }}/handlers"
)

{% macro handlerName path operationType %}
{{ operationType|capitalize }}{{ path|pathToPascal }}
{% endmacro %}

{% for path,pathObject in swagger.paths %}
{% for operationType,operationObject in pathObject.operations %}
{% call handlerName path operationType %}
{% endfor %}
{% endfor %}

func main() {
	r := mux.NewRouter()
	bindings.BindServices()
	// r.HandleFunc("/", handlers.PostHandler).Methods("POST")
	// r.HandleFunc("/", handlers.GetHandler).Methods("GET")
	// r.HandleFunc("/{id}/verify", handlers.PostIDVerifyHandler).Methods("POST")
	// r.HandleFunc("/{id}/verify", handlers.GetIDVerifyHandler).Methods("GET")
	// r.HandleFunc("/{id}", handlers.GetIDHandler).Methods("GET")
	log.Fatal(http.ListenAndServe(":8080", r))
}