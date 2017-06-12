package api

{% import "Includes/type_string.stencil" %}
{% for structure in swagger.definitions %}
type {{ structure.name|toPascal }} struct {
	{% for propertyName,property in structure.structure.object.properties %}
	{% set type %}{% call typeString property %}{% endset %}
	{{ propertyName|toPascal }} {{ type|removeNewlines }}
	{% endfor %}
}

{% endfor %}
{% endimport %}