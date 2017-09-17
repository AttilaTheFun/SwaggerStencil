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
{% import "encode_response.stencil" %}
{% set existsPathParameter %}{{ swagger|hasParameter:"path" }}{% endset %}
{% set existsBodyParameter %}{{ swagger|hasParameter:"body" }}{% endset %}
import (
    "encoding/json"
    "net/http"

{% if existsBodyParameter %}
    "{{ path }}/models"
{% endif %}
    "{{ path }}/service"
    "github.com/attilathefun/registry"
{% if existsPathParameter %}
    "github.com/gorilla/mux"
{% endif %}
)

{% for path,pathObject in swagger.paths %}
{% for operationType,operation in pathObject.operations %}
{% set handlerName %}{{ path|handlerName:operationType }}{% endset %}
// {{ handlerName }} - {{ operation.summary }}
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

{% call encodeResponse operation %}

// Write the status code and the marshaled bytes:
w.WriteHeader(code)
if bytes != nil {
    w.Write(bytes)
}
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
{% endimport %}