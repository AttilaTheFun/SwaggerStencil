{% include "header.stencil" %}
package handlers

{% import "schema_string.stencil" %}
{% import "items_string.stencil" %}
{% import "parameter_name.stencil" %}
{% import "parameter_type.stencil" %}
{% import "handler_name.stencil" %}
{% import "handler_parameters.stencil" %}
{% import "has_parameter.stencil" %}
{% import "string_conversion.stencil" %}
import (
	"encoding/json"
	"net/http"

	"github.com/attilathefun/registry"
	"{{ path }}/models"
)

{% for path,pathObject in swagger.paths %}
{% for operationType,operation in pathObject.operations %}
{% set handlerName %}{% call handlerName path operationType %}{% endset %}
{% set comment %}{{ handlerName }}Handler - {{ operation.description }}{% endset %}
{{ comment|wrapWidth:120,"// " }}
func {{ handlerName }}Handler(w http.ResponseWriter, r *http.Request) {

{% set hasQueryParameter %}{% call hasQueryParameter operation %}{% endset %}
{% if hasQueryParameter %}
queryParameters := r.URL.Query()
{% endif %}


{% for either in operation.parameters %}
{% set name %}{% call parameterNameCamel either %}{% endset %}
{% set isQuery %}{% call isQueryParameter either %}{% endset %}
{% if isQuery %}
{% call convertQueryParameter name either %}
{% endif %}

{% endfor %}
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