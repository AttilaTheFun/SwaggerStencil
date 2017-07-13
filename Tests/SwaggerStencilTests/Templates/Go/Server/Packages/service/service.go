{% include "header.stencil" %}
package service

{% import "handler_name.stencil" %}
{% import "handler_parameters.stencil" %}
{% import "handler_responses.stencil" %}
import "{{ path }}/models"

// Service - Defines the interface for this webservice.
type Service interface {
{% for path,pathObject in swagger.paths %}
{% for operationType,operation in pathObject.operations %}
{% set handlerName %}{% call handlerName path operationType %}{% endset %}

    // {{ handlerName }} - {{ operation.summary }}
    {{ handlerName }}({% call handlerParameters operation %}) {% call handlerResponses operation %}
{% endfor %}
{% endfor %}
}

{% endimport %}
{% endimport %}
{% endimport %}