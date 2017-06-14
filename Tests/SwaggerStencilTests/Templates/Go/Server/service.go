package service

import (
	"{{ path }}/models/models.go"
)

// Service - Defines the interface for this webservice.
type Service interface {
{% import "Imports/handler_name.stencil" %}
{% import "Imports/handler_parameters.stencil" %}
{% for path,pathObject in swagger.paths %}
{% for operationType,operation in pathObject.operations %}
{% set handlerName %}{% call handlerName path operationType %}{% endset %}
{% set parameters %}{% call handlerParameters operation %}{% endset %}

    // {{ handlerName|removeNewlines }} - {{ operation.summary }}
    {{ handlerName|removeNewlines }}({{ parameters }})
{% endfor %}
{% endfor %}
{% endimport %}
{% endimport %}
}
