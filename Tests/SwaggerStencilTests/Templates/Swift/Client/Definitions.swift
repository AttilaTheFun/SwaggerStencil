import Mapper

{% import "Imports/schema_string.stencil" %}
{% import "Imports/schema_description.stencil" %}
{% for structure in swagger.definitions %}
public struct {{ structure.name }}: Mappable {
    {% for property,schema in structure.structure.object.properties %}
    {% set description %}{% call schemaDescription schema %}{% endset %}
    {% if description %}

    // {{ description }}{% endif %}
    let {{ property|toCamel }}: {% call schemaString schema %}{% notcontains structure.structure.object.required property %}?{% endnotcontains %}
    {% endfor %}

    public func init(map: Map) throws {
        {% for property,schema in structure.structure.object.properties %}
        {% contains structure.structure.object.required property %}{{ property|toCamel }} = try map.from("{{ property }}"){% endcontains %}
        {% notcontains structure.structure.object.required property %}{{ property|toCamel }} = map.optionalFrom("{{ property }}"){% endnotcontains %}
        {% endfor %}
    }
}

{% endfor %}
{% endimport %}
{% endimport %}
