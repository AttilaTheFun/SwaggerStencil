package service

{% import "Imports/schema_string.stencil" %}
{% import "Imports/items_string.stencil" %}
{% import "Imports/parameter_name.stencil" %}
{% import "Imports/parameter_type.stencil" %}
{% import "Imports/handler_name.stencil" %}
{% import "Imports/handler_parameters.stencil" %}

import (
	"{{ path }}/models/models.go"
)

// Service - Defines the interface for this webservice.
type Service interface {
{% for path,pathObject in swagger.paths %}
{% for operationType,operation in pathObject.operations %}
{% set handlerName %}{% call handlerName path operationType %}{% endset %}

    // {{ handlerName|removeNewlines }} - {{ operation.summary }}
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