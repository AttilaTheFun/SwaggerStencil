{% include "header.stencil" %}
package handlers

{% import "handler_parameters.stencil" %}
{% import "handler_responses.stencil" %}
{% import "return_error.stencil" %}
{% import "item_conversion.stencil" %}
{% import "body_conversion.stencil" %}
{% import "query_conversion.stencil" %}
{% import "path_conversion.stencil" %}
{% import "header_conversion.stencil" %}
{% import "response_names.stencil" %}
{% set existsPathParameter %}{{ swagger|hasParameter:"path" }}{% endset %}
import (
    "encoding/json"
    "net/http"

{% if existsPathParameter %}
    "github.com/gorilla/mux"
{% endif %}
    "github.com/attilathefun/registry"
    "{{ path }}/models"
    "{{ path }}/service"
)

{% for path,pathObject in swagger.paths %}
{% for operationType,operation in pathObject.operations %}
{% set handlerName %}{{ path|handlerName:operationType }}{% endset %}
{% set comment %}{{ handlerName }} - {{ operation.description }}{% endset %}
{{ comment|wrapWidth:120,"// " }}
func {{ handlerName }}(w http.ResponseWriter, r *http.Request) {
{% set contents %}
{% set hasQueryParameter %}{{ operation|hasParameter:"query" }}{% endset %}
{% set hasPathParameter %}{{ operation|hasParameter:"path" }}{% endset %}
{% set hasHeaderParameter %}{{ operation|hasParameter:"header" }}{% endset %}
var err error
service := registry.Resolve((*service.Service)(nil)).(service.Service)

{% if hasQueryParameter %}
// Has query parameter(s):
queryParameters := r.URL.Query()

{% endif %}
{% if hasPathParameter %}
// Has path parameter(s):
pathParameters := mux.Vars(r)

{% endif %}
{% if hasHeaderParameter %}
// Has header parameter(s):
headerParameters := r.Header

{% endif %}
{% for either in operation.parameters %}
{% set parameterName %}{{ either|parameterName }}{% endset %}
{% set isQuery %}{{ either|isParameter:"query" }}{% endset %}
{% set isPath %}{{ either|isParameter:"path" }}{% endset %}
{% set isHeader %}{{ either|isParameter:"header" }}{% endset %}
{% set isBody %}{{ either|isParameter:"body" }}{% endset %}
// Extract {{ parameterName|toCamel }}:

{% if isBody %}
{% call convertBodyParameter parameterName either %}
{% elif isQuery %}
{% call convertQueryParameter parameterName either %}
{% elif isPath %}
{% call convertPathParameter parameterName either %}
{% elif isHeader %}
{% call convertHeaderParameter parameterName either %}
{% endif %}
{% endfor %}
// Call the function with the parsed parameters:
{% call responseNames operation %} := service.{{ handlerName }}({% call handlerParameterNames operation %})

// Marshal the response:
var bytes []byte
switch code {
{% for code,either in operation.responses %}
case {{ code }}:
    bytes, err = json.Marshal(response{{ code }})
{% endfor %}
{% if operation.defaultResponse %}
default:
    bytes, err = json.Marshal(defaultResponse)
{% endif %}
}

// Check if the marshaling was successful:
if err != nil {
    w.WriteHeader(500)
    w.Write([]byte(err.Error()))
    return
}

// Write the status code and the marshaled bytes:
w.WriteHeader(code)
w.Write(bytes)
{% endset %}
{{ contents|setIndentation:"    " }}
}

{% endfor %}
{% endfor %}
{% endimport %}
{% endimport %}
{% endimport %}
{% endimport %}
{% endimport %}
{% endimport %}
{% endimport %}
{% endimport %}
{% endimport %}