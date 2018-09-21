{% include "header.stencil" %}
import Foundation

{% for name,schema in swagger.definitions %}
public struct {{ name }}: Codable, Equatable, Hashable {
{% set contents %}
{% for propertyName,propertySchema in schema.type.object.properties %}
{% set description %}{{ propertySchema.metadata.description }}{% endset %}
{% if description %}

{{ description|wrapWidth:120,"// " }}
{% endif %}
public let {{ propertyName|toCamel }}: {{ propertySchema|swiftSchemaType }}
{% endfor %}

enum CodingKeys: String, CodingKey {
{% for propertyName,propertySchema in schema.type.object.properties %}
    case {{ propertyName|toCamel }} = "{{ propertyName }}"
{% endfor %}
}
{% endset %}
{{ contents|setIndentation:"    " }}
}

{% endfor %}
