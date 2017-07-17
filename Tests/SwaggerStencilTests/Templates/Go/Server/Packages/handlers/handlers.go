{% include "header.stencil" %}
package handlers

{% import "handler_parameters.stencil" %}
{% import "handler_responses.stencil" %}
{% import "query_conversion.stencil" %}
import (
	"encoding/json"
	"net/http"

	"github.com/attilathefun/registry"
	"{{ path }}/models"
	"{{ path }}/service"
)

{% for path,pathObject in swagger.paths %}
{% for operationType,operation in pathObject.operations %}
{% set handlerName %}{{ path|handlerName:operationType }}{% endset %}
{% set comment %}{{ handlerName }}Handler - {{ operation.description }}{% endset %}
{{ comment|wrapWidth:120,"// " }}
func {{ handlerName }}(w http.ResponseWriter, r *http.Request) {
{% set contents %}
var err error
maybeService, err := registry.Resolve((*service.Service)(nil))
service := maybeService.(service.Service)
{# Check if function has a query parameter: #}
{% set hasQueryParameter %}{{ operation|hasParameter:"query" }}{% endset %}
{% if hasQueryParameter %}
queryParameters := r.URL.Query()
{% endif %}

{# Check if function has a path parameter: #}
{# Parse out all the parameters into their respective types: #}
{% for either in operation.parameters %}
{% set parameterName %}{{ either|parameterName }}{% endset %}
{% set isQuery %}{{ either|isParameter:"query" }}{% endset %}
{% set isPath %}{{ either|isParameter:"path" }}{% endset %}
{% set isHeader %}{{ either|isParameter:"path" }}{% endset %}
{% set isBody %}{{ either|isParameter:"body" }}{% endset %}
{% if isBody %}
BODY
{% elif isPath %}
PATH
{% elif isHeader %}
HEADER
{% elif isQuery %}
	{% call convertQueryParameter parameterName either %}
{% endif %}
{% endfor %}
{# Call the function with the parsed parameters: #}
{# Return the appropriate result: #}
{% endset %}
{{ contents|setIndentation:"    " }}
}

{% endfor %}
{% endfor %}

{% endimport %}
{% endimport %}
{% endimport %}