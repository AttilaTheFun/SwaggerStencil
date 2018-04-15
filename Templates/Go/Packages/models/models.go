{% include "header.stencil" %}
package models

{% import "model_definitions.stencil" %}
{% for name,schema in swagger.definitions %}
{% set enumValues %}{{ schema.metadata.enumeratedValues }}{% endset %}
{% if enumValues %}
{% call enumDefinition name schema schema.metadata.enumeratedValues %}
{% endif %}
{% endfor %}
// Empty - Used to indicate an empty response.
type Empty struct{}

{% for name,schema in swagger.definitions %}
{% set enumValues %}{{ schema.metadata.enumeratedValues }}{% endset %}
{% if not enumValues %}
{% call modelDefinition name schema %}
{% endif %}
{% endfor %}
{% endimport %}
