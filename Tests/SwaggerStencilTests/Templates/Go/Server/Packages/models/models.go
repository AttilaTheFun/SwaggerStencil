{% include "header.stencil" %}
package models

// Empty - Used to indicate an empty response.
type Empty struct{}

{% import "schema_string.stencil" %}
{% import "schema_description.stencil" %}
{% for structure in swagger.definitions %}
// {{ structure.name|toPascal }} - {% call schemaDescription structure.structure %}
type {{ structure.name|toPascal }} struct {
{% set contents %}
{% for propertyName,property in structure.structure.object.properties %}
{% set description %}{% call schemaDescription property %}{% endset %}

{% if description %}{{ description|wrapWidth:120,"// " }}

{% endif %}
{{ propertyName|toPascal }} {% call schemaString property %}
{% endfor %}
{% endset %}
{{ contents|setIndentation:"    " }}
}

{% endfor %}
{% endimport %}
{% endimport %}