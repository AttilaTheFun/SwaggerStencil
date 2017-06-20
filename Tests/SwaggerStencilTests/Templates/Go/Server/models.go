{% include "Includes/header.stencil" %}
package api

{% import "Imports/schema_string.stencil" %}
{% import "Imports/schema_description.stencil" %}
{% for structure in swagger.definitions %}
// {{ structure.name|toPascal }} - {% call schemaDescription structure.structure %}
type {{ structure.name|toPascal }} struct {
{% set contents %}
{% for propertyName,property in structure.structure.object.properties %}
{% set description %}{% call schemaDescription property %}{% endset %}
{% if description %}// {{ description }}

{% endif %}
{{ propertyName|toPascal }} {% call schemaString property %}

{% endfor %}
{% endset %}
{{ contents|alignColumns|setIndentation:"    " }}
}

{% endfor %}
{% endimport %}
{% endimport %}