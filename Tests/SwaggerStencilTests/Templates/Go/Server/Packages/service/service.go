{% include "header.stencil" %}
package service

{% import "schema_string.stencil" %}
{% import "items_string.stencil" %}
{% import "parameter_name.stencil" %}
{% import "parameter_type.stencil" %}
{% import "handler_name.stencil" %}
{% import "handler_parameters.stencil" %}
import (
	"{{ path }}/models/models.go"
)

// Service - Defines the interface for this webservice.
type Service interface {
{% for path,pathObject in swagger.paths %}
{% for operationType,operation in pathObject.operations %}
{% set handlerName %}{% call handlerName path operationType %}{% endset %}

    // {{ handlerName }} - {{ operation.summary }}
    {{ handlerName }}({% call handlerParameters operation %})
{% endfor %}
{% endfor %}
}

{% endimport %}
{% endimport %}
{% endimport %}
{% endimport %}
{% endimport %}
{% endimport %}