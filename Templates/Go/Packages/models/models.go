{% include "header.stencil" %}
package models

// Empty - Used to indicate an empty response.
type Empty struct{}

{% for name,schema in swagger.definitions %}
// {{ name }} - {{ schema.metadata.description }}
type {{ name }} struct {
{% set contents %}
{% for propertyName,propertySchema in schema.type.object.properties %}

{% set description %}{{ propertySchema.metadata.description }}{% endset %}
{% if description %}{{ description|wrapWidth:120,"// " }}

{% endif %}
{{ propertyName|toPascal }} {{ propertySchema|golangSchemaType:0 }} `json:"{{ propertyName }}"`
{% endfor %}
{% endset %}
{{ contents|setIndentation:"    " }}
}

{% endfor %}
