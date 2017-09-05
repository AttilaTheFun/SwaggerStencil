{% include "header.stencil" %}
package main

import (
    "log"
    "net/http"

    "github.com/gorilla/mux"
    "{{ path }}/bindings"
    "{{ path }}/handlers"
)

func main() {
{% set contents %}
r := mux.NewRouter()
bindings.BindServices()
{% for path,pathObject in swagger.paths %}
{% for operationType,operationObject in pathObject.operations %}
{% set handlerName %}{{ path|handlerName:operationType }}{% endset %}
r.HandleFunc("{{ path }}", handlers.{{ handlerName }}).Methods("{{ operationType|uppercase }}")
{% endfor %}
{% endfor %}
log.Fatal(http.ListenAndServe(":8080", r))
{% endset %}
{{ contents|setIndentation:"    " }}
}
