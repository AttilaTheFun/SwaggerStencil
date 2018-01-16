{% include "header.stencil" %}
package handlers

{% import "handler_parameters.stencil" %}
{% import "handler_responses.stencil" %}
{% import "return_error.stencil" %}
{% import "decode_item_from_string.stencil" %}
{% import "decode_parameter.stencil" %}
{% import "encode_response.stencil" %}
{% import "response_names.stencil" %}
{% set existsPathParameter %}{{ swagger|hasParameter:"path" }}{% endset %}
{% set existsBodyParameter %}{{ swagger|hasParameter:"body" }}{% endset %}
import (
    "encoding/json"
    "net/http"
    "strconv"
    "strings"

{% set externalImports %}
{% if existsBodyParameter %}
    "{{ path }}/models"
{% endif %}
    "{{ path }}/service"
    "github.com/aphelionapps/utils/registry"
{% if existsPathParameter %}
    "github.com/gorilla/mux"
{% endif %}
{% endset %}
{{ externalImports|alphabetizeLines }}
)

{% for path,pathObject in swagger.paths %}
{% for operationType,operation in pathObject.operations %}
{% set handlerName %}{{ path|handlerName:operationType }}{% endset %}
{% set parameterNames %}{% call handlerParameterNames operation %}{% endset %}
{% set responseNames %}{% call responseNames operation %}{% endset %}
// {{ handlerName }} - {{ operation.summary }}
func {{ handlerName }}(w http.ResponseWriter, r *http.Request) {
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
{% call decodeParameter either %}

{% endfor %}
{% set callServiceString %}
// Call the function with the parsed parameters:
{{ responseNames }} := service.{{ handlerName }}({{ parameterNames }})
{% endset %}
{{ callServiceString|setIndentation:"    " }}

{% call encodeResponse operation %}

    // Write the status code and the marshaled bytes:
    w.WriteHeader(code)
    if bytes != nil {
        w.Write(bytes)
    }
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
